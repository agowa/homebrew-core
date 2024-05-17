class Libcacard < Formula
  desc "Provides smart card emulation to guests"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/libcacard/libcacard-2.8.1.tar.xz"
  sha256 "fbbf4de8cb7db5bdff5ecb672ff0dbe6939fb9f344b900d51ba6295329a332e7"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.spice-space.org/download/libcacard/"
    regex(/href=.*?libcacard[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  #bottle do
  #  sha256 cellar: :any_skip_relocation, all: "c95213126a4de3d3ab508fbfc7f23f11ece2f0011d3a6d251d7f79034376066e"
  #end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cmake" => :build

  depends_on "glib"
  depends_on "nspr"
  depends_on "nss"
  depends_on "pkcs11-tools"
  depends_on "softhsm"
  depends_on "pcsc-lite"

  def install
    system "sed", "-i", "", "/subdir('fuzz')/d; /subdir('tests')/d", "meson.build"
    system "meson", "setup", "build", *std_meson_args
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
