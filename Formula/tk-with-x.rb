class TkWithX < Formula
  desc "Tk user interface toolkit"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.15/tk8.6.15-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tk8.6.15-src.tar.gz"
  sha256 "550969f35379f952b3020f3ab7b9dd5bfd11c1ef7c9b7c6a75f5c49aca793fec"
  license "TCL"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:tcl|tk).?v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  keg_only "it conflicts with homebrew core/tcl-tk"

  depends_on "libx11"
  depends_on "shaunplee/asic/tcl"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    ENV.prepend_path "PATH", bin

    tcl = Formula["shaunplee/asic/tcl"]

    cd "unix" do
      system "./configure", *args,
             "--with-tcl=#{tcl.opt_prefix}/lib",
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

  test do
    assert_equal "hello", pipe_output("#{bin}/tclsh", "puts hello\n").chomp
  end
end
