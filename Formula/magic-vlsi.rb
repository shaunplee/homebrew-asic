class MagicVlsi < Formula
  version '8.3.456'
  desc "VLSI layout tool written in Tcl"
  homepage "http://opencircuitdesign.com/magic/"
  url "https://github.com/RTimothyEdwards/magic/archive/refs/tags/#{version}.tar.gz"
  sha256 "ef17c343c89ac54699f87f6c853ec7e4814f322734bd3b54a157a7d95cab905a"
  license "MIT"

  # magic crashes on start with a BadMatch error:
  ### X Error of failed request:  BadMatch (invalid parameter attributes)
  ### Major opcode of failed request:  149 (GLX)
  ### Minor opcode of failed request:  27 (X_GLXCreatePbuffer)
  # So let's not use OpenGL
  # depends_on "mesa" => :build
  # depends_on "mesa-glu" => :build
  depends_on "python3"

  resource "tcl" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.13/tcl8.6.13-src.tar.gz"
    sha256 "43a1fae7412f61ff11de2cfd05d28cfc3a73762f354a417c62370a54e2caf066"
  end

  resource "tk" do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.13/tk8.6.13-src.tar.gz"
    mirror "https://fossies.org/linux/misc/tk8.6.13-src.tar.gz"
    sha256 "2e65fa069a23365440a3c56c556b8673b5e32a283800d8d9b257e3f584ce0675"
  end

  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    resource("tcl").stage do
      tcl_tk_args = %W[
        --prefix=#{prefix}/tcl-tk
        --mandir=#{man}
        --enable-threads
        --enable-64bit
      ]

      cd "unix" do
        system "./configure",
               *tcl_tk_args
        system "make"
        system "make", "install"
        system "make", "install-private-headers"
      end

      ENV.prepend_path "PATH", bin

      resource("tk").stage do
        cd "unix" do
          system "./configure",
                 "--with-tcl=#{prefix}/tcl-tk/lib",
                 "--enable-xss=no",
                 "--with-x",
                 "--x-includes=/opt/X11/include",
                 "--x-libraries=/opt/X11/lib",
                 *tcl_tk_args

          inreplace "Makefile",
                    /^LIB_RUNTIME_DIR[^\n]*$/,
                    "LIB_RUNTIME_DIR = $(libdir)"

          system "make"
          system "make", "install"
          system "make", "install-private-headers"
        end
      end
    end

    system "./configure",
           "--prefix=#{prefix}",
           "--with-tcl=#{prefix}/tcl-tk/lib",
           "--with-tk=#{prefix}/tcl-tk/lib",
           "--x-includes=/opt/X11/include",
           "--x-libraries=/opt/X11/lib",
           "--with-opengl=no", # disable OpenGL
           "--disable-silent-rules",
           "CFLAGS=-Wno-implicit-function-declaration",
           "PYTHON3=#{Formula["python3"].bin}/python3",
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
    assert_match version, shell_output("#{bin}/magic --version", 0)
  end
end
