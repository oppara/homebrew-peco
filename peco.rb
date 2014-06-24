# WARNING: Automatically generated. All changes to this file will be lost
require 'formula'

HOMEBREW_PECO_VERSION='0.1.7'
class Peco < Formula
  homepage 'https://github.com/peco/peco'
  url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_darwin_amd64.zip"
  sha1 "71b359cbebb82ea56606c9b975ad36b9d3baea00"

  version HOMEBREW_PECO_VERSION
  head 'https://github.com/peco/peco.git', :branch => 'master'

  if build.head?
    depends_on 'go' => :build
    depends_on 'hg' => :build
  else
    depends_on 'unzip' => :build
  end

  def install
    if build.head?
      ENV['GOPATH'] = buildpath
      mkdir_p buildpath/'src/github.com/lestrrat'
      ln_s buildpath, buildpath/'src/github.com/lestrrat/peco'
      system 'go', 'get', 'github.com/jessevdk/go-flags'
      system 'go', 'get', 'github.com/mattn/go-runewidth'
      system 'go', 'get', 'github.com/nsf/termbox-go'
      system 'go', 'build', 'cmd/peco/peco.go'
    end
    bin.install 'peco'
  end
end