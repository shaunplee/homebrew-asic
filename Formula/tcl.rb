class Tcl < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/9.0.0/tcl9.0.0-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl9.0.0-src.tar.gz"
  sha256 "3bfda6dbaee8e9b1eeacc1511b4e18a07a91dff82d9954cdb9c729d8bca4bbb7"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  keg_only "it conflicts with homebrew core/tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh#{version.to_f}", bin/"tclsh"
    end
  end

  test do
    assert_equal "hello", pipe_output("#{bin}/tclsh", "puts hello\n").chomp
  end
end
