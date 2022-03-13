# Maintainer: Albert I <kras@raphielgang.org>
# Contributor: Thibaut Sautereau (thithib) <thibaut at sautereau dot fr>

pkgname=hardened_malloc
pkgver=11
pkgrel=1
pkgdesc="Hardened allocator designed for modern systems"
arch=('x86_64')
url="https://github.com/GrapheneOS/hardened_malloc"
license=('MIT')
depends=('gcc-libs>=10.2.0' 'glibc>=2.31' 'openssh>=8.1')
makedepends=('gcc>=10.2.0' 'git')
checkdepends=('python')
options=('!buildflags')
provides=("libhardened_malloc.so=$pkgver" "libhardened_malloc-light.so=$pkgver")
source=("git+https://github.com/GrapheneOS/$pkgname#tag=$pkgver?signed")
sha256sums=('SKIP')
validpgpkeys=('65EEFE022108E2B708CBFCF7F9E712E59AF5F22A') # Daniel Micay <danielmicay@gmail.com>

build() {
  cd "$pkgname"

  make CONFIG_EXAMPLE=false CONFIG_NATIVE=false VARIANT=default
  make CONFIG_EXAMPLE=false CONFIG_NATIVE=false VARIANT=light
}

check() {
  cd "$pkgname"
  make CONFIG_WERROR=false test
}

package() {
  cd "$pkgname"

  install -Dm755 --target-directory="$pkgdir/usr/lib" out/libhardened_malloc.so
  install -Dm755 --target-directory="$pkgdir/usr/lib" out-light/libhardened_malloc-light.so

  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

# vim:set ts=2 sw=2 et:
