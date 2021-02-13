# Maintainer: Albert I <kras@raphielgang.org>
# Contributor: AndyRTR <andyrtr@archlinux.org>

pkgname=xorg-xwayland-hidpi

# https://gitlab.freedesktop.org/xorg/xserver/-/commits/xwayland-21.1
_commit=1e72c3ce84e29d51d50f301b986a687e15679cf8 # xwayland 21.1 branch

pkgver=1.20.0.r844.g1e72c3ce8
pkgrel=1
arch=('x86_64')
license=('custom')
groups=('xorg')
url="https://xorg.freedesktop.org"
pkgdesc="Run X clients under Wayland, with HiDPI"
depends=('nettle' 'libepoxy' 'systemd-libs' 'libxfont2' 
         'pixman' 'xorg-server-common')
makedepends=('meson' 'git' 
             'xorgproto' 'xtrans' 'libxkbfile' 'dbus'
             'xorg-font-util'
             'wayland' 'wayland-protocols'
             'libdrm' 'mesa-libgl'
             'systemd'
             'egl-wayland'
)
source=("git+https://gitlab.freedesktop.org/xorg/xserver#commit=${_commit}"
        'xwlScaling.diff')
sha256sums=('SKIP'
            '58e9118b093acd6a9457f6da3157ad673a463cee16e3180bff580ebafe1f2406')
provides=('xorg-server-xwayland' 'xorg-xwayland')
conflicts=('xorg-server-xwayland' 'xorg-xwayland')
#replaces=('xorg-server-xwayland-hidpi')

pkgver() {
  cd xserver
  git describe --tags | sed 's/^xorg.server.//;s/\([^-]*-g\)/r\1/;s/-/./g'
}

prepare() {
  cd xserver
  patch --forward --strip=1 --input="${srcdir}/xwlScaling.diff"
}

build() {
  # Since pacman 5.0.2-2, hardened flags are now enabled in makepkg.conf
  # With them, module fail to load with undefined symbol.
  # See https://bugs.archlinux.org/task/55102 / https://bugs.archlinux.org/task/54845
#  export CFLAGS=${CFLAGS/-fno-plt}
#  export CXXFLAGS=${CXXFLAGS/-fno-plt}
#  export LDFLAGS=${LDFLAGS/,-z,now}

  arch-meson xserver build \
    -D ipv6=true \
    -D xvfb=false \
    -D xcsecurity=true \
    -D xwayland_eglstream=true \
    -D glamor=true \
    -D xkb_dir=/usr/share/X11/xkb \
    -D xkb_output_dir=/var/lib/xkb

  # Print config
  meson configure build
  ninja -C build
}

package() {
  # bin + manpage + .pc file
  install -m755 -Dt "${pkgdir}"/usr/bin build/hw/xwayland/Xwayland
  install -m644 -Dt "${pkgdir}"/usr/share/man/man1 build/hw/xwayland/Xwayland.1
  install -m644 -Dt "${pkgdir}"/usr/lib/pkgconfig build/hw/xwayland/xwayland.pc

  # license
  install -m644 -Dt "${pkgdir}/usr/share/licenses/${pkgname}" xserver/COPYING
}

