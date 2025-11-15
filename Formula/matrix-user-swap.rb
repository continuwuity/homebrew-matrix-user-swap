class MatrixUserSwap < Formula
  desc "A Matrix account migration tool."
  homepage "https://forgejo.ellis.link/continuwuation/matrix-user-swap"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/continuwuity/matrix-user-swap/releases/download/v0.1.3/matrix-user-swap-aarch64-apple-darwin.tar.xz"
      sha256 "a82d607eb74602c53686792c47006a6b938b47d2c3e1f87b05bd077c224a0f50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/continuwuity/matrix-user-swap/releases/download/v0.1.3/matrix-user-swap-x86_64-apple-darwin.tar.xz"
      sha256 "f0816a5069a818a70eaaedd5e5ebd0f06cc05096aaaf31cb933f56e7c37d4d14"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/continuwuity/matrix-user-swap/releases/download/v0.1.3/matrix-user-swap-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7825c006e16a148781d829d15e781b6cf4f408c0b11f4dbd40d0fb510f3c64c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/continuwuity/matrix-user-swap/releases/download/v0.1.3/matrix-user-swap-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c92b11321bcf4dc7fd9795c1abe17b92a6d9a0af92715ac0777d18e8964240b7"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "matrix-user-swap" if OS.mac? && Hardware::CPU.arm?
    bin.install "matrix-user-swap" if OS.mac? && Hardware::CPU.intel?
    bin.install "matrix-user-swap" if OS.linux? && Hardware::CPU.arm?
    bin.install "matrix-user-swap" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
