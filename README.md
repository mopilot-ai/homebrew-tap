# MoPilot Homebrew tap

Install [MoPilot](https://mopilot.ai), a desktop home for coding agents, on macOS 13 or later:

```bash
brew install --cask mopilot-ai/tap/mopilot
```

The cask installs the signed, notarized app from the public
[release downloads](https://github.com/mopilot-ai/mopilot-code-release/releases) into `/Applications`.
MoPilot then updates itself, so `brew upgrade` leaves it alone unless you run it with `--greedy`.
`brew uninstall --cask --zap mopilot` also removes its settings and data.

`Casks/mopilot.rb` is written by MoPilot's release workflow each time a stable version reaches 100% rollout
(the version [mopilot.ai/download](https://mopilot.ai/download) serves), after it installs on Apple silicon and Intel.
Edits made here by hand are replaced by the next release.
