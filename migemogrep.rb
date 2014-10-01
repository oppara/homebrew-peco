# WARNING: Automatically generated. All changes to this file will be lost
require 'formula'

HOMEBREW_MIGEMOGREP_VERSION='0.1.0'
class Migemogrep < Formula
  homepage 'https://github.com/peco/migemogrep'
  if OS.mac?
    url "https://github.com/peco/migemogrep/releases/download/v#{HOMEBREW_MIGEMOGREP_VERSION}/migemogrep_darwin_amd64.zip"
    sha1 "d565035fe29e92858ba4b4393d36a1f338758b6b"
  elsif OS.linux?
    url "https://github.com/peco/migemogrep/releases/download/v#{HOMEBREW_MIGEMOGREP_VERSION}/migemogrep_linux_amd64.tar.gz"
    sha1 "2f95ffb8c440ccfa9bf2e35a83f5e79aceb36985"
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