class Tcl < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.14/tcl8.6.14-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tcl8.6.14-src.tar.gz"
  sha256 "5880225babf7954c58d4fb0f5cf6279104ce1cd6aa9b71e9a6322540e1c4de66"
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
