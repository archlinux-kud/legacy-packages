# Maintainer: Albert I <kras@raphielgang.org>

pkgname=srandom-moesyndrome
pkgver=1.38.0
pkgrel=3
pkgdesc='Kernel modules for the srandom for linux-moesyndrome'
arch=(x86_64)
url='https://github.com/josenk/srandom'
license=(GPL3)
_kernver=5.10.2~ms15-1
depends=("linux-moesyndrome=$_kernver")
makedepends=("linux-moesyndrome-headers=$_kernver")
options=('!buildflags' '!strip')
source=("srandom::git+$url#commit=939c5e0980875b1c51b3cbb2b00ad91de6b90719")
b2sums=('SKIP')
_kernsrc=/usr/lib/modules/${_kernver/-*/+arch}/build

build() {
    make -C "$_kernsrc" M="$srcdir"/srandom modules
}

package() {
    make -C "$_kernsrc" M="$srcdir"/srandom INSTALL_MOD_PATH="$pkgdir"/usr INSTALL_MOD_STRIP=1 modules_install
    find "$pkgdir"/usr -name modules.* -delete;

    install -Dm644 "$srcdir"/srandom/LICENSE "$pkgdir"/usr/share/licenses/"$pkgname"/LICENSE
}
