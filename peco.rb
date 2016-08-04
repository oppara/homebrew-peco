# WARNING: Automatically generated. All changes to this file will be lost
require 'formula'

HOMEBREW_PECO_VERSION='0.3.3'
class Peco < Formula
  homepage 'https://github.com/peco/peco'
  if OS.mac?
    url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_darwin_amd64.zip"
    sha256 "7d2c56202f9b1273cd03b351e41e8a472c3b8bff9450a807ef77dc4e261dcb70"
  elsif OS.linux?
    url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_linux_amd64.tar.gz"
    sha256 "90728c44afbf63fe38cbdc54f6953c2d4187844288fb9a85f1ecd5c273e4ec94"
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