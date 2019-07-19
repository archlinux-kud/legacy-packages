# Contributor: Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>
# Contributor: Ionut Biru <ibiru@archlinux.org>
# Contributor: Hugo Doria <hugo@archlinux.org>

# Package branching
# Maintainer: Albert I <kras@raphielgang.org>

pkgname=deluge-legacy
pkgver=1.3.15+19+gd62987089
pkgrel=1
pkgdesc="A BitTorrent client with multiple user interfaces in a client/server model (version 1.3.x)"
arch=(any)
url="https://deluge-torrent.org/"
license=(GPL3)
depends=(python2-xdg libtorrent-rasterbar python2-twisted python2-pyopenssl
         python2-chardet python2-setuptools)
makedepends=(intltool pygtk librsvg python2-mako git)
optdepends=('python2-notify: libnotify notifications'
            'python2-pygame: audible notifications'
            'python2-libappindicator: appindicator notifications'
            'pygtk: needed for gtk ui'
            'librsvg: needed for gtk ui'
            'python2-mako: needed for web ui'
            'python2-service-identity: for ssl verification')
_srcname=${pkgname/-legacy}
provides=($_srcname)
conflicts=($_srcname)
_srcver=$(echo "$pkgver" | cut -d '.' -f 1,2)
source=("$_srcname::git://git.deluge-torrent.org/deluge.git#branch=${_srcver}-stable"
        untag-build.patch
        deluged.service deluge-web.service)
sha256sums=('SKIP'
            'fbd17f13765f5560bab01a81a42aff0f2f757a4a6fa29379ae31d95b9721e4f2'
            '58a451bb6cf4fe6ff78a4fb71d51c5910340a2de032ff435c3c7365015ab538f'
            'c3f2d6ad5bc9de5ffd9973d92badbe04a9ecf12c0c575e13d505a96add03275a')

prepare() {
  cd $_srcname
  patch -Np1 -i ../untag-build.patch
  sed -i '1s/python$/&2/' \
    deluge/ui/Win32IconImagePlugin.py \
    deluge/ui/web/gen_gettext.py
}

pkgver() {
  cd $_srcname
  git describe | sed 's/^deluge-//;s/-/+/g'
}

build() {
  cd $_srcname
  python2 setup.py build
}

package() {
  cd $_srcname
  python2 setup.py install --prefix=/usr --root="$pkgdir" --optimize=1
  install -Dt "$pkgdir/usr/lib/systemd/system" -m644 ../*.service
  echo 'u deluge - "Deluge BitTorrent daemon" /srv/deluge' |
    install -Dm644 /dev/stdin "$pkgdir/usr/lib/sysusers.d/$pkgname.conf"
  echo 'd /srv/deluge 0775 deluge deluge' |
    install -Dm644 /dev/stdin "$pkgdir/usr/lib/tmpfiles.d/$pkgname.conf"
}
