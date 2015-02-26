# WARNING: Automatically generated. All changes to this file will be lost
require 'formula'

HOMEBREW_PECO_VERSION='0.2.12'
class Peco < Formula
  homepage 'https://github.com/peco/peco'
  if OS.mac?
    url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_darwin_amd64.zip"
    sha1 "c5a473382f59829e05bf9bca14b7425b7068e70a"
  elsif OS.linux?
    url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_linux_amd64.tar.gz"
    sha1 "6a32a163b402778d073ea39d664eed5724594341"
  end

  version HOMEBREW_PECO_VERSION
  head 'https://github.com/peco/peco.git', :branch => 'master'

  if build.head?
    depends_on 'go' => :build
    depends_on 'hg' => :build
  end

  def install
    if build.head?
      ENV['GOPATH'] = buildpath
      mkdir_p buildpath/'src/github.com/peco'
      ln_s buildpath, buildpath/'src/github.com/peco/peco'
      system 'go', 'get', 'github.com/jessevdk/go-flags'
      system 'go', 'get', 'github.com/mattn/go-runewidth'
      system 'go', 'get', 'github.com/nsf/termbox-go'
      system 'go', 'get', 'github.com/peco/peco'
      system 'go', 'build', 'cmd/peco/peco.go'
    end
    bin.install 'peco'
  end
end