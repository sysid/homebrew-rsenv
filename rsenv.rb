class Rsenv < Formula
  desc "Unified development environment manager: hierarchical env vars, file guarding, and swap-in/out"
  homepage "https://github.com/sysid/rs-env"
  url "https://github.com/sysid/rs-env/archive/refs/tags/v5.2.4.tar.gz"
  sha256 "3def8aac24673fab87bd9d6c2a0e58dadcf8fbff9c84341e5a88b1e5303df54d"
  license "BSD-3-Clause"

  depends_on "rust" => :build

  def install
    cd "rsenv" do
      system "cargo", "install", "--verbose", "--locked", "--root", prefix, "--path", "."
    end
    generate_completions_from_executable(bin/"rsenv", "completion")
  end

  test do
    # assert_match "rsenv", shell_output("#{bin}/rsenv --help")
    assert_match version.to_s, shell_output("#{bin}/rsenv --version")
    assert_match(/Vault:\s+\(not initialized\)/, shell_output("#{bin}/rsenv info 2>&1"))
  end
end
