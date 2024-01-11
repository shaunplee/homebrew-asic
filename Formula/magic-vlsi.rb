class MagicVlsi < Formula
  desc "VLSI layout tool written in Tcl"
  homepage "http://opencircuitdesign.com/magic/"
  url "https://github.com/RTimothyEdwards/magic/archive/refs/tags/8.3.456.tar.gz"
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
      cd "unix" do
        system "./configure", "--prefix=#{lib}/tcl-tk"
        system "make"
        system "make", "install"
      end

      ENV.prepend_path "PATH", bin

      resource("tk").stage do
        cd "unix" do
          system "./configure",
                 "--prefix=#{lib}/tcl-tk",
                 "--with-tcl=#{lib}/tcl-tk/lib",
                 "--with-x",
                 "--enable-xss=no",
                 "--x-includes=/usr/X11/include",
                 "--x-libraries=/usr/X11/lib"

          inreplace "Makefile",
                    /^LIB_RUNTIME_DIR[^\n]*$/,
                    "LIB_RUNTIME_DIR		= $(libdir)"

          system "make"
          system "make", "install"
        end
      end
    end

    system "./configure",
           "--prefix=#{prefix}",
           "--with-tcl=#{lib}/tcl-tk/lib",
           "--with-tk=#{lib}/tcl-tk/lib",
           "--x-includes=/usr/X11/include",
           "--x-libraries=/usr/X11/lib",
           "--with-opengl=no", # disable OpenGL
           "--disable-silent-rules",
           "PYTHON3=#{Formula["python3"].bin}/python3",
           *std_configure_args
    ENV["CFLAGS"] = "-Wno-error=implicit-function-declaration"
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
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test magic-vlsi`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.

    # TODO: write a real test
    system "magic --version"
  end
end
