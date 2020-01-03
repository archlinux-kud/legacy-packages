# Based on PKGBUILD by:
# Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>
# Ionut Biru <ibiru@archlinux.org>
# Hugo Doria <hugo@archlinux.org>

# Maintainer: Albert I <kras@raphielgang.org>

pkgname=deluge-legacy
pkgver=1.3.15+19+gd62987089
pkgrel=2
pkgdesc="A BitTorrent client with multiple user interfaces in a client/server model (version 1.3.x)"
url="https://deluge-torrent.org/"
arch=('any')
license=('GPL3')
depends=('libtorrent-rasterbar<1.2.1' 'python2-chardet' 'python2-pyopenssl'
         'python2-setuptools' 'python2-twisted' 'python2-xdg')
makedepends=('git' 'intltool' 'librsvg' 'pygtk' 'python2-mako')
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
        deluged.service
        deluge-web.service
        untag-build.patch)
sha384sums=('SKIP'
            'deee15cb4bcb11786792b2230454ec59a6ae47fd08881a599d422655e63881487ce918d2486490a64df8eee7e2bd0ef0'
            '881dec17e240a84d82bfaf790845e96559ed37d8e48a1c0c8c887299b41acd6b0053b6130b7283e9cc0d1fe1a919c630'
            'c5f4a3d38ecd3cba8792d62da6b7a451102d27b34c005dadbc90704d1590706bd32a106198a285b411f2f24e9340f87a')

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
