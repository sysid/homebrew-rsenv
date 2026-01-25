class Rsenv < Formula
  desc "Unified development environment manager: hierarchical env vars, file guarding, and swap-in/out"
  homepage "https://github.com/sysid/rs-env"
  url "https://github.com/sysid/rs-env/archive/refs/tags/v5.1.6.tar.gz"
  sha256 "50dee2aeadf3afc28d297bc0170fcda102db8332cc0f4d776054d03f99e352d5"
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
