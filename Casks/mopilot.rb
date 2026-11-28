# Written by MoPilot's release workflow from the stable update feed on each stable release: edits here are replaced.
cask "mopilot" do
  arch arm: "arm64", intel: "x64"

  version "0.4.94"
  sha256 arm:   "41f53f18964fab3cbe2a9caacc2ee593f23d9bd98f6902d727dc326f73c2c000",
         intel: "76de2e41c9e9d2381a931e34e656fef03d2ceaac75cdb78ccb5f78e784ad61f6"

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
