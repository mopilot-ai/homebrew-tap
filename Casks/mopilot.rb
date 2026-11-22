# Written by MoPilot's release workflow from the stable update feed on each stable release: edits here are replaced.
cask "mopilot" do
  arch arm: "arm64", intel: "x64"

  version "0.4.49"
  sha256 arm:   "d83e49a0d0c4a8ccd6e7db886e23c2f70e5e2335dc3f1b53fe86cb2c97ddb2a8",
         intel: "700624a953a9f5e03d5706d7dfed0f0802c144031f3718884d81d1a8b7d0abe3"

  url "https://github.com/mopilot-ai/mopilot-code-release/releases/download/v#{version}/MoPilot-#{version}-#{arch}.zip",
      verified: "github.com/mopilot-ai/mopilot-code-release/"
  name "MoPilot"
  desc "Desktop home for coding agents"
  homepage "https://mopilot.ai/"

  # The newest version at 100% rollout on both architectures, as this cask is written from the feed.
  livecheck do
    url "https://raw.githubusercontent.com/mopilot-ai/mopilot-code-release/main/updates/stable.json"
    strategy :json do |json|
      live = (json["releases"].to_a + json["promotions"].to_a).select do |item|
        item.is_a?(Hash) && item["platform"] == "darwin" && item["rolloutPct"] == 100 &&
          item["version"].to_s.match?(/^\d+\.\d+\.\d+$/)
      end
      live.group_by { |item| item["version"] }
          .select { |_, items| items.any? { |i| i["arch"] == "arm64" } && items.any? { |i| i["arch"] == "x64" } }
          .keys
    end
  end

  # The app updates itself in /Applications between brew upgrades.
  auto_updates true
  depends_on macos: :ventura

  app "MoPilot.app"

  # ~/.mopilot is left alone: it holds the user's agent worktrees, plugins and connectors.
  zap trash: [
    "~/Library/Application Support/MoPilot",
    "~/Library/Caches/ai.mopilot.code",
    "~/Library/Caches/ai.mopilot.code.ShipIt",
    "~/Library/HTTPStorages/ai.mopilot.code",
    "~/Library/Logs/MoPilot",
    "~/Library/Preferences/ai.mopilot.code.plist",
    "~/Library/Saved Application State/ai.mopilot.code.savedState",
  ]
end
