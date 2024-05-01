class MagicVlsi < Formula
  include Language::Python::Virtualenv

  desc "VLSI layout tool written in Tcl"
  homepage "http://opencircuitdesign.com/magic/"
  url "https://github.com/RTimothyEdwards/magic/archive/refs/tags/8.3.475.tar.gz"
  sha256 "52591761f9ea99d88f7374a8a6d8d8a8d27402c749f7fa7a1a5e2c371decc08c"
  license "MIT"

  livecheck do
    url :stable
  end

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
  depends_on "shaunplee/asic/tk-with-x"

  def install
    ENV.deparallelize
    tcl = Formula["shaunplee/asic/tcl"]
    tk = Formula["shaunplee/asic/tk-with-x"]
    virtualenv_create(libexec, "python3")

    # magic crashes on start with a BadMatch error:
    ### X Error of failed request:  BadMatch (invalid parameter attributes)
    ### Major opcode of failed request:  149 (GLX)
    ### Minor opcode of failed request:  27 (X_GLXCreatePbuffer)
    # So let's set --with-opengl=no
    system "./configure",
           "--with-tcl=#{tcl.opt_prefix}",
           "--with-tk=#{tk.opt_prefix}",
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
    assert_match version.to_s, shell_output("#{bin}/magic --version").strip
  end
end
