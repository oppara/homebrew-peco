package main

import (
	"crypto/sha1"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

const pecoRbFmt = `# WARNING: Automatically generated. All changes to this file will be lost
require 'formula'

HOMEBREW_PECO_VERSION='%s'
class Peco < Formula
  homepage 'https://github.com/peco/peco'
  url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_darwin_amd64.zip"
  sha1 "%x"

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
      system 'go', 'get', 'github.com/peco/peco'
      system 'go', 'build', 'cmd/peco/peco.go'
    end
    bin.install 'peco'
  end
end`

func main() {
	updatePecoRb(os.Args[1])
}

// fetch applicable binary, generate checksum, and update the .rb file
func updatePecoRb(version string) {
	url := fmt.Sprintf("https://github.com/peco/peco/releases/download/v%s/peco_darwin_amd64.zip", version)

	log.Printf("Fetching url %s...", url)
	res, err := http.Get(url)
	if err != nil {
		log.Fatal(err)
	}

	if res.StatusCode != 200 {
		log.Fatalf("Got %d instead of 200", res.StatusCode)
	}

	h := sha1.New()
	io.Copy(h, res.Body)

	file, err := os.OpenFile("peco.rb", os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Fatalf("Failed to open file peco.rb: %s", err)
	}

	fmt.Fprintf(file, pecoRbFmt, version, h.Sum(nil))
}
