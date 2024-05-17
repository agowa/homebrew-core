class SpiceServer < Formula
  desc "SPICE server"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/releases/spice-0.15.2.tar.bz2"
  sha256 "6d9eb6117f03917471c4bc10004abecff48a79fb85eb85a1c45f023377015b81"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.spice-space.org/download/releases/"
    regex(/href=.*?spice[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  #bottle do
  #  sha256 cellar: :any_skip_relocation, all: "c95213126a4de3d3ab508fbfc7f23f11ece2f0011d3a6d251d7f79034376066e"
  #end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "pixman"
  depends_on "opus"
  depends_on "libjpeg-turbo"
  depends_on "glib"
  #depends_on "libsasl"
  depends_on "lz4"
  depends_on "spice-protocol"
  #depends_on "libcacard"
  depends_on "six" => :build
  #depends_on "pyparsing" => :build

  def install
    meson_args = std_meson_args + %w[
      --auto-features=enabled
      --wrap-mode=nodownload
      -Db_pie=true
      -Dpython.bytecompile=1
      -Dgstreamer=no
    ]
    # Warning not gnu-sed. -i needs a zero length argument after it.
    system "sed", "-i", "", "s/if not version_info.contains('git')/if version_info.length() >= 4/", "server/meson.build"
    system "sed", "-i", "", "/meson-dist/d", "meson.build"
    system "pip3", "install", "--break-system-packages", "--user", "pyparsing"
    system "meson", "setup", "build", *meson_args
    system "nija", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    #(testpath/"test.cpp").write <<~EOS
    #  #include <spice/protocol.h>
    #  int main() {
    #    return (SPICE_LINK_ERR_OK == 0) ? 0 : 1;
    #  }
    #EOS

    #system "meson", "test", "-C", "build", "--print-errorlogs"
    # running meson test needs additional dependencies: gdk-pixbuf and glib-networking
    
    #system ENV.cc, "test.cpp", "-I#{include}/spice-1", "-o", "test"
    #system "./test"
  end
end
