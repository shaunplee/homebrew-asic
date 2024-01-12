class NgspiceAT36 < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/old-releases/36/ngspice-36.tar.gz"
  sha256 "4f818287efba245341046635b757ae81f879549b326a4316b5f6e697aa517f8c"

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # conflicts_with "ngspice"

  keg_only :versioned_formula

  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on "libxt"
  depends_on "ncurses"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh" if build.head?

    args = %w[
      --with-readline=yes
      --enable-xspice
    ]

    ENV["CPPFLAGS"] = " -I#{Formula["freetype"].opt_include}/freetype2"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1
      c1 2 0 1 ic=0
      .tran 100u 100m uic
      .control
      run
      quit
      .endc
      .end
    EOS
    system "#{bin}/ngspice", "test.cir"
  end
end
