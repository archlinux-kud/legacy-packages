# Based on PKGBUILD by:
# Felix Yan <felixonmars@archlinux.org>
# Ionut Biru <ibiru@archlinux.org>
# Hugo Doria <hugo@archlinux.org>

# Maintainer: Albert I <kras@raphielgang.org>

pkgname=libtorrent-rasterbar-1_1
pkgver=1.1.14
pkgrel=1
pkgdesc="A C++ BitTorrent library that aims to be a good alternative to all the other implementations around (version 1.1)"
url="https://www.rasterbar.com/products/libtorrent/"
arch=('x86_64')
license=('BSD')
depends=('boost-libs')
makedepends=('boost' 'python2' 'python')
provides=("libtorrent-rasterbar=$pkgver")
conflicts=('libtorrent-rasterbar')
options=('!emptydirs')
_pkgname=${pkgname/-1_1}
_pkgver=${pkgver//./_}
source=(https://github.com/arvidn/libtorrent/releases/download/libtorrent-$_pkgver/$_pkgname-$pkgver.tar.gz)
sha512sums=('b640ada016f8e68a3fb0e033dd33ab79b345b0f691aa722c4256b8cd8524c6e55067ccd1f11584984bbb82c0f64151f0b5223bd2b8431b899ffca46d2d31fff5')

prepare() {
  mkdir py2 py3
  cd $_pkgname-$pkgver

  # Avoid depending on newer processors
  sed -i 's/-msse4.2//' configure.ac

  autoreconf -if
}

_build() (
  cd py$1

  # FS#50745
  _boost="boost_python"
  if [ $1 -eq 3 ]; then _boost="boost_python3"; fi

  # https://github.com/qbittorrent/qBittorrent/issues/5265#issuecomment-220007436
  CXXFLAGS="$CXXFLAGS -std=c++11" \
  PYTHON=/usr/bin/python$1 \
  ../$_pkgname-$pkgver/configure \
    --prefix=/usr \
    --enable-python-binding \
    --enable-examples \
    --disable-static \
    --with-libiconv \
    --with-boost-python=$_boost
)

build() {
  _build 2
  _build 3
}

package() {
  make -C py2 DESTDIR="$pkgdir" install
  make -C py3 DESTDIR="$pkgdir" install
  install -Dm644 $_pkgname-$pkgver/COPYING \
    "$pkgdir/usr/share/licenses/$_pkgname/LICENSE"

  # Remove most example binaries
  rm "$pkgdir"/usr/bin/{*_test,*_tester,simple_client,stats_counters}
}
