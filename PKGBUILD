pkgname=ccache-git
pkgver=v3.7.1_62_g3d05ccd
pkgrel=1
pkgdesc="A compiler cache"
arch=('x86_64')
url="https://ccache.dev/"
license=('GPL3')
depends=('zlib')
makedepends=('git' 'asciidoc' 'gperf')
conflicts=('ccache')
provides=('ccache')
source=("git://github.com/ccache/ccache")
sha256sums=('SKIP')

pkgver() {
  cd ${srcdir}/ccache
  git describe | sed 's/[- ]/_/g'
}

build() {
  cd ${srcdir}/ccache
  ./autogen.sh
  ./configure --prefix=/usr --sysconfdir=/etc

  make
  make docs
}

check() {
  cd ${srcdir}/ccache
  make test
}

package() {
  cd ${srcdir}/ccache

  install -Dm 755 ccache -t "${pkgdir}/usr/bin"
  install -Dm 644 doc/ccache.1 -t "${pkgdir}/usr/share/man/man1"
  install -Dm 644 doc/{AUTHORS,MANUAL,NEWS}.adoc README.md -t "${pkgdir}/usr/share/doc/${pkgname/-git}"

  install -d ${pkgdir}/usr/lib/ccache/bin
  local _prog
  for _prog in c++ gcc g++; do
    ln -sf /usr/bin/ccache "${pkgdir}/usr/lib/ccache/bin/$_prog" 
    ln -sf /usr/bin/ccache "${pkgdir}/usr/lib/ccache/bin/${CHOST}-$_prog" 
  done
  for _prog in cc clang clang++; do
    ln -sf /usr/bin/ccache "${pkgdir}/usr/lib/ccache/bin/$_prog"
  done
}
