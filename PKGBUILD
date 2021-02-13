# Maintainer: Albert I <kras@raphielgang.org>
# Contributor: Thibaut Sautereau (thithib) <thibaut at sautereau dot fr>

pkgname=hardened_malloc
pkgver=5
pkgrel=1
pkgdesc="Hardened allocator designed for modern systems"
arch=('x86_64')
url="https://github.com/GrapheneOS/hardened_malloc"
license=('MIT')
depends=('gcc-libs>=8.3.0' 'glibc>=2.28')
makedepends=('gcc>=8.3.0' 'git')
checkdepends=('python')
options=('!buildflags')
provides=("libhardened_malloc.so=$pkgver")
source=("git+https://github.com/GrapheneOS/$pkgname#tag=$pkgver?signed")
sha256sums=('SKIP')
validpgpkeys=('65EEFE022108E2B708CBFCF7F9E712E59AF5F22A') # Daniel Micay <danielmicay@gmail.com>

build() {
  cd "$pkgname"
  make \
      CONFIG_NATIVE=false \
      CONFIG_WRITE_AFTER_FREE_CHECK=false \
      CONFIG_SLOT_RANDOMIZE=false \
      CONFIG_SLAB_QUARANTINE_RANDOM_LENGTH=0 \
      CONFIG_SLAB_QUARANTINE_QUEUE_LENGTH=0 \
      CONFIG_GUARD_SLABS_INTERVAL=8
}

check() {
  cd "$pkgname"
  make CONFIG_WERROR=false test
}

package() {
  cd "$pkgname"
  install -Dm755 --target-directory="$pkgdir/usr/lib" libhardened_malloc.so
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

# vim:set ts=2 sw=2 et:
