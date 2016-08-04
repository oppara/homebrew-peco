# WARNING: Automatically generated. All changes to this file will be lost
require 'formula'

HOMEBREW_MIGEMOGREP_VERSION='0.1.0'
class Migemogrep < Formula
  homepage 'https://github.com/peco/migemogrep'
  if OS.mac?
    url "https://github.com/peco/migemogrep/releases/download/v#{HOMEBREW_MIGEMOGREP_VERSION}/migemogrep_darwin_amd64.zip"
    sha256 "5b6eefbfbc2c6f89693988a17b96d4355b297dbe1cf8d517dd8d620d74fc0d51"
  elsif OS.linux?
    url "https://github.com/peco/migemogrep/releases/download/v#{HOMEBREW_MIGEMOGREP_VERSION}/migemogrep_linux_amd64.tar.gz"
    sha256 "db1fe734036b12e89644d73ea94e47983899c100ae6a154107ef912163a603fe"
  end

  version HOMEBREW_MIGEMOGREP_VERSION
  head 'https://github.com/peco/migemogrep.git', :branch => 'master'

  if build.head?
    depends_on 'go' => :build
    depends_on 'hg' => :build
  end

  def install
    if build.head?
      ENV['GOPATH'] = buildpath
      mkdir_p buildpath/'src/github.com/peco'
      system 'go', 'get', 'github.com/koron/gomigemo'
      system 'go', 'build', '.'
    end
    bin.install 'migemogrep'
  end
end