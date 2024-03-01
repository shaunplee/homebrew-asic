class TkWithX < Formula
  desc "Tk user interface toolkit"
  homepage "https://www.tcl-lang.org"
  url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.14/tk8.6.14-src.tar.gz"
  mirror "https://fossies.org/linux/misc/tk8.6.14-src.tar.gz"
  sha256 "8ffdb720f47a6ca6107eac2dd877e30b0ef7fac14f3a84ebbd0b3612cee41a94"
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

  test do
    assert_equal "hello", pipe_output("#{bin}/tclsh", "puts hello\n").chomp
  end
end
