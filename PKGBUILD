# Maintainer: Albert I <kras@raphielgang.org>
# Contributor: Thibaut Sautereau (thithib) <thibaut at sautereau dot fr>

_pkgname=hardened_malloc
cpuopt=${_cpuopt:+$(echo "$_cpuopt" | sed s/-/_/g)}
pkgname=${_pkgname}${_cpuopt:+-$cpuopt}
pkgver=11
pkgrel=6
pkgdesc="Hardened allocator designed for modern systems"
arch=('x86_64')
url="https://github.com/GrapheneOS/hardened_malloc"
license=('custom:MIT')
depends=('gcc-libs>=10.2.0' 'glibc>=2.31' 'openssh>=8.1')
makedepends=('gcc>=10.2.0' 'git')
checkdepends=('python')
provides=("libhardened_malloc.so=$pkgver" "libhardened_malloc-light.so=$pkgver")
source=("git+https://github.com/GrapheneOS/$_pkgname#tag=$pkgver?signed")
sha256sums=('SKIP')
validpgpkeys=('65EEFE022108E2B708CBFCF7F9E712E59AF5F22A') # Daniel Micay <danielmicay@gmail.com>

if [[ -n "$cpuopt" ]]; then
  provides+=("$_pkgname")
  conflicts+=("$_pkgname")
fi

build() {
  CFLAGS+="${_cpuopt:+ -march=$_cpuopt}"
  CXXFLAGS+="${_cpuopt:+ -march=$_cpuopt}"

  cd "$_pkgname"

  make CONFIG_EXAMPLE=false CONFIG_NATIVE=false VARIANT=default
  make CONFIG_EXAMPLE=false CONFIG_NATIVE=false VARIANT=light
}

check() {
  make -C "$_pkgname" test
}

package() {
  cd "$_pkgname"

  install -Dm755 --target-directory="$pkgdir/usr/lib" out/libhardened_malloc.so
  install -Dm755 --target-directory="$pkgdir/usr/lib" out-light/libhardened_malloc-light.so

  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$_pkgname/LICENSE"
}

# vim:set ts=2 sw=2 et:
