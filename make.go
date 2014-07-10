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
end`

const migemogrepRbFmt = `# WARNING: Automatically generated. All changes to this file will be lost
require 'formula'

HOMEBREW_MIGEMOGREP_VERSION='%s'
class Migemogrep < Formula
  homepage 'https://github.com/peco/migemogrep'
  url "https://github.com/peco/migemogrep/releases/download/v#{HOMEBREW_MIGEMOGREP_VERSION}/migemogrep_darwin_amd64.zip"
  sha1 "%x"

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
end`

func main() {
	st := _main()
	os.Exit(st)
}

func _main() int {
	// Usage:
	//   go run make.go peco 0.2.0
	//   go run make.go migemogrep 0.1.0
	if len(os.Args) != 3 {
		fmt.Fprintln(os.Stderr, "Usage:\n  go run make.go [target] [version]\n")
		return 1
	}

	switch os.Args[1] {
	case "peco":
		return updatePecoRb(os.Args[2])
	case "migemogrep":
		return updateMigemogrepRb(os.Args[2])
	default:
		fmt.Fprintf(os.Stderr, "Unknown target: %s\n", os.Args[1])
		return 1
	}
}

func updatePecoRb(version string) int {
	return updateGenericRb("peco", version, pecoRbFmt)
}

func updateMigemogrepRb(version string) int {
	return updateGenericRb("migemogrep", version, migemogrepRbFmt)
}

// fetch applicable binary, generate checksum, and update the .rb file
func updateGenericRb(target, version, template string) int {
	url := fmt.Sprintf(
		"https://github.com/peco/%s/releases/download/v%s/%s_darwin_amd64.zip",
		target,
		version,
		target,
	)

	log.Printf("Fetching url %s...", url)
	res, err := http.Get(url)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		return 1
	}

	if res.StatusCode != 200 {
		fmt.Fprintf(os.Stderr, "Got %d instead of 200", res.StatusCode)
		return 1
	}

	h := sha1.New()
	io.Copy(h, res.Body)

	filename := fmt.Sprintf("%s.rb", target)
	file, err := os.OpenFile(filename, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, 0644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to open file %s: %s", filename, err)
		return 1
	}

	fmt.Fprintf(file, template, version, h.Sum(nil))
	return 0
}
