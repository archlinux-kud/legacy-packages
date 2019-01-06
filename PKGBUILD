pkgname=ccache-git
pkgver=v3.2.4_110_g1cfdf73
pkgrel=1
pkgdesc="A compiler cache"
arch=('x86_64')
url="http://ccache.samba.org/"
license=('GPL3')
depends=('zlib')
makedepends=('git' 'asciidoc')
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

  local _prog

  install -Dm 755 ccache "${pkgdir}/usr/bin/ccache"
  install -Dm 644 doc/ccache.1 -t "${pkgdir}/usr/share/man/man1/ccache.1"
  for _prog in AUTHORS MANUAL NEWS; do 
    install -Dm 644 doc/${_prog}.adoc "${pkgdir}/usr/share/doc/${pkgname}/${_prog}.adoc"
  done

  install -d ${pkgdir}/usr/lib/ccache/bin
  for _prog in gcc g++ c++; do
    ln -sf /usr/bin/ccache "${pkgdir}/usr/lib/ccache/bin/$_prog" 
    ln -sf /usr/bin/ccache "${pkgdir}/usr/lib/ccache/bin/${CHOST}-$_prog" 
  done
  for _prog in cc clang clang++; do
    ln -sf /usr/bin/ccache "${pkgdir}/usr/lib/ccache/bin/$_prog"
  done
}
