# WARNING: Automatically generated. All changes to this file will be lost
require 'formula'

HOMEBREW_PECO_VERSION='0.3.1'
class Peco < Formula
  homepage 'https://github.com/peco/peco'
  if OS.mac?
    url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_darwin_amd64.zip"
    sha1 "2fe563c7af4157e1ecd0b92686c86015dbb7ced0"
  elsif OS.linux?
    url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_linux_amd64.tar.gz"
    sha1 "20e33f7469b5c06c7e87ba6c0da21c4d5fa5fd37"
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