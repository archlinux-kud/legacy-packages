# Maintainer: Albert I <kras@raphielgang.org>
# Contributor: Thibaut Sautereau (thithib) <thibaut at sautereau dot fr>

_pkgname=hardened_malloc
cpuopt=${_cpuopt:+$(echo "${_cpuopt}" | sed s/-/_/g)}
pkgname=${_pkgname}${_cpuopt:+-${cpuopt}}
pkgver=13.qpr1.r11.g2d302f7
_pkgver=${pkgver/.*/}
pkgrel=1
epoch=1
pkgdesc="Hardened allocator designed for modern systems"
arch=('x86_64')
url="https://github.com/GrapheneOS/hardened_malloc"
license=('MIT')
# https://github.com/GrapheneOS/hardened_malloc#dependencies
depends=('gcc-libs>=12.2.0' 'glibc>=2.36')
makedepends=('gcc>=12.2.0' 'git' 'linux-api-headers>=6.1')
# https://github.com/GrapheneOS/hardened_malloc#compatibility; not really required
optdepends=('openssh: mprotect PROT_READ|PROT_WRITE syscalls in seccomp-bpf filter')
checkdepends=('python')
provides=("libhardened_malloc.so=${_pkgver}" "libhardened_malloc-light.so=${_pkgver}")
# use latest commit that passes CI tests: https://github.com/GrapheneOS/hardened_malloc/actions
source=("git+https://github.com/GrapheneOS/${_pkgname}#commit=2d302f7d85944bcaa1ce6419a4c51732f76daaa6")
sha256sums=('SKIP')
# only used when it matches versioned tags
validpgpkeys=('65EEFE022108E2B708CBFCF7F9E712E59AF5F22A') # Daniel Micay <danielmicay@gmail.com>

if [[ -n "${cpuopt}" ]]; then
  provides+=("${_pkgname}")
  conflicts+=("${_pkgname}")
fi

pkgver() {
  # avoid matching GrapheneOS Android release tags
  git -C "${_pkgname}" describe --long --match '[0-9]*' HEAD | sed 's/\([^-]*-g\)/r\1/;s/-/./g'
}

build() {
  CFLAGS+="${_cpuopt:+ -march=${_cpuopt}}"
  CXXFLAGS+="${_cpuopt:+ -march=${_cpuopt}}"

  cd "${_pkgname}"

  # disable CONFIG_NATIVE, pass desired target to ${_cpuopt} variable instead
  make CONFIG_EXAMPLE=false CONFIG_NATIVE=false VARIANT=default
  make CONFIG_EXAMPLE=false CONFIG_NATIVE=false VARIANT=light
}

check() {
  make -C "${_pkgname}" test
}

package() {
  cd "${_pkgname}"

  install -Dm755 -t "${pkgdir}/usr/lib" out/libhardened_malloc.so
  install -Dm755 -t "${pkgdir}/usr/lib" out-light/libhardened_malloc-light.so

  install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${_pkgname}/LICENSE"
}

# vim:set ts=2 sw=2 et:
