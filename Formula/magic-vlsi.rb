class MagicVlsi < Formula
  include Language::Python::Virtualenv

  desc "VLSI layout tool written in Tcl"
  homepage "http://opencircuitdesign.com/magic/"
  url "https://github.com/RTimothyEdwards/magic/archive/refs/tags/8.3.456.tar.gz"
  version "8.3.456"
  sha256 "ef17c343c89ac54699f87f6c853ec7e4814f322734bd3b54a157a7d95cab905a"
  license "MIT"

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libglu"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on :macos
  depends_on "python3"
  depends_on "shaunplee/asic/tcl-tk-with-x"

  def install
    ENV.deparallelize
    tcltk = Formula["shaunplee/asic/tcl-tk-with-x"]
    virtualenv_create(libexec, "python3")

    # magic crashes on start with a BadMatch error:
    ### X Error of failed request:  BadMatch (invalid parameter attributes)
    ### Major opcode of failed request:  149 (GLX)
    ### Minor opcode of failed request:  27 (X_GLXCreatePbuffer)
    # So let's set --with-opengl=no
    system "./configure",
           "--with-tcl=#{tcltk.opt_prefix}",
           "--with-tk=#{tcltk.opt_prefix}",
           "--x-includes=/opt/X11/include",
           "--x-libraries=/opt/X11/lib",
           "--with-opengl=no", # disable OpenGL
           "--disable-silent-rules",
           "CFLAGS=-Wno-implicit-function-declaration",
           "PYTHON3=#{libexec}/bin/python3",
           *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      This package has an implicit dependency on the xquartz cask.
      Please 'brew install xquartz' before installing.
    EOS
  end

  test do
    assert_match version, shell_output("#{bin}/magic --version")
  end
end
