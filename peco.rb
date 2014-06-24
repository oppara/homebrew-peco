# WARNING: Automatically generated. All changes to this file will be lost
require 'formula'

HOMEBREW_PECO_VERSION='0.1.7'
class Peco < Formula
  homepage 'https://github.com/peco/peco'
  url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_darwin_amd64.zip"
  sha1 "71b359cbebb82ea56606c9b975ad36b9d3baea00"

  version HOMEBREW_PECO_VERSION
  head 'https://github.com/peco/peco.git', :branch => 'master'

  depends_on 'unzip' => :build

  def install
    bin.install 'peco'
  end
end