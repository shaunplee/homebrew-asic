class TclTkWithX < Formula
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

  bottle do
    root_url "https://github.com/shaunplee/homebrew-asic/releases/download/tcl-tk-with-x-8.6.13_10"
    sha256 ventura: "71015590462d315553d4a662bd447d4ece1d0fe3becb21f46c631d72d5017b38"
  end

  keg_only "it conflicts with homebrew core/tcl-tk"

  depends_on "libx11"

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.13/tk8.6.13-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.13-src.tar.gz"
    sha256 "2e65fa069a23365440a3c56c556b8673b5e32a283800d8d9b257e3f584ce0675"
  end

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

    ENV.prepend_path "PATH", bin

    resource("tk").stage do
      cd "unix" do
        system "./configure", *args,
               "--with-tcl=#{lib}",
               "--with-x"
        inreplace "Makefile",
                  /^LIB_RUNTIME_DIR[^\n]*$/,
                  "LIB_RUNTIME_DIR		= $(libdir)"
        system "make"
        system "make", "install"
        system "make", "install-private-headers"
        ln_s bin/"wish#{version.to_f}", bin/"wish"
      end
    end
  end

  test do
    assert_equal "hello", pipe_output("#{bin}/tclsh", "puts hello\n").chomp
  end
end
