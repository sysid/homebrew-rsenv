# Homebrew Installation Guide for rsenv
[rsenv 5.1.2 (new formula) by sysid · Pull Request #264298 · Homebrew/homebrew-core · GitHub](https://github.com/Homebrew/homebrew-core/pull/264298)

This guide explains how to maintain the rsenv Homebrew formula.

## Prerequisites

1. Project hosted on GitHub: https://github.com/sysid/rs-env
2. Release created with version tag (e.g., `v5.1.1`)
3. Basic familiarity with Git and Homebrew

## Installation (Users)

```bash
# Using personal tap
brew tap sysid/rsenv
brew install rsenv

# Verify installation
rsenv --version
rsenv --help
```

## Testing the Formula Locally

```bash
brew tap sysid/rsenv
brew install rsenv
brew test rsenv
```

## Updating the Formula (Version Bump)

When releasing a new version:

1. Generate SHA256 for new release:
   ```bash
   curl -L https://github.com/sysid/rs-env/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256
   ```

2. Update `rsenv.rb`:
   - Change `url` to new version tag
   - Update `sha256` with new hash

3. Commit and push:
   ```bash
   git add rsenv.rb
   git commit -m "Upgrade to rsenv X.Y.Z"
   git push
   ```

4. Test:
   ```bash
   brew reinstall rsenv
   brew test rsenv
   ```

## Submit to Homebrew Core (Optional)

If you want your formula included in the main Homebrew repository:

1. Fork [Homebrew/homebrew-core](https://github.com/Homebrew/homebrew-core)
2. Clone homebrew-core locally:
   ```bash
   # clone into /opt/homebrew/Library/Taps/homebrew/homebrew-core (1GB !!)
   brew tap --force homebrew/core
   ```
3. Add/update formula in `Formula/r/rsenv.rb`
   ```bash
   # creates $(brew --repository)/Library/Taps/homebrew/homebrew-core/Formula/f/foo.rb
   brew create --rust https://github.com/sysid/rs-env/archive/refs/tags/v5.1.2.tar.gz
   ```
4. Test thoroughly:
   ```bash
   HOMEBREW_NO_INSTALL_FROM_API=1 brew audit --new rsenv
   HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source --verbose rsenv
   HOMEBREW_NO_INSTALL_FROM_API=1 brew test rsenv
   ```
5. Submit pull request
   - sync forked repo
   ```bash
   brew update # required in more ways than you think (initialises the Homebrew/brew Git repository if you don't already have it)
   cd "$(brew --repository homebrew/core)"
   # Create a new git branch for your formula so your pull request is easy to
   git checkout -b rsenv origin/HEAD
   git add Formula/r/rsenv.rb
   git commit -m "rsenv 7.3.1 (new formula)"
   git push https://github.com/sysid/homebrew-core/ rsenv
   ```
   - create PR

Note: Homebrew Core has strict requirements for acceptance.

## Documentation

- [Formula Cookbook](https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md)
- [Acceptable Formulae](https://github.com/Homebrew/brew/blob/master/docs/Acceptable-Formulae.md)
- [How To Open a Pull Request](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request)
- [Formula Ruby API](https://rubydoc.brew.sh/Formula.html)

## Formula Structure

### Bottles

```ruby
bottle do
  sha256 cellar: :any_skip_relocation, arm64_sequoia: "..."
  ...
end
```

Bottles are precompiled binaries for specific platforms. They are:
- **Not required** for personal taps
- **Automatically built** by Homebrew CI when merged to homebrew-core
- Provide faster installs (no compilation needed)

### Key Formula Elements

| Element | Purpose |
|---------|---------|
| `desc` | One-line description |
| `homepage` | Project URL |
| `url` | Release tarball URL |
| `sha256` | Integrity check hash |
| `license` | License identifier |
| `depends_on "rust" => :build` | Build-time dependency |
| `generate_completions_from_executable` | Auto-generate shell completions |

## Updating in homebrew-core

After initial acceptance:

1. Navigate to homebrew-core:
   ```bash
   cd /opt/homebrew/Library/Taps/homebrew/homebrew-core
   ```
2. Update and create branch:
   ```bash
   git switch master
   git pull
   git switch -c rsenv-update
   ```
3. Update formula, commit, push, create PR

Or use automated bump:
```bash
brew bump-formula-pr rsenv --url=https://github.com/sysid/rs-env/archive/refs/tags/vX.Y.Z.tar.gz
```

## Notes

- Homebrew maintainers may auto-update versions if releases are consistent
- Tests should verify actual functionality, not just version output
- Bottles are built automatically after PR merge
