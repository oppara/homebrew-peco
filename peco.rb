require 'formula'

HOMEBREW_PECO_VERSION='0.1.1'
class Peco < Formula
  homepage 'https://github.com/lestrrat/peco'
  url 'https://github.com/lestrrat/peco.git', :tag => "v#{HOMEBREW_PECO_VERSION}"
  version HOMEBREW_PECO_VERSION
  head 'https://github.com/lestrrat/peco.git', :branch => 'master'

  depends_on 'go' => :build
  depends_on 'hg' => :build

  def install
    ENV['GOPATH'] = buildpath
    mkdir_p buildpath/'src/github.com/lestrrat'
    ln_s buildpath, buildpath/'src/github.com/lestrrat/peco'
    system 'go', 'get', 'github.com/jessevdk/go-flags'
    system 'go', 'get', 'github.com/mattn/go-runewidth'
    system 'go', 'get', 'github.com/nsf/termbox-go'
    system 'go', 'build', 'cmd/peco/peco.go'
    bin.install 'peco'
  end
end