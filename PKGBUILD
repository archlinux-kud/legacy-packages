# Maintainer: Albert I <kras@raphielgang.org>

# Special thanks to the following people that provided the
# original PKGBUILD from hyper (https://aur.archlinux.org/packages/hyper/)
# Contributor: Frederic Bezies <fredbezies at gmail dot com>
# Contributor: ahrs <Forward dot to at hotmail dot co dot uk>
# Contributor: Aaron Abbott <aabmass@gmail.com>
# Contributor: fleischie
# Contributor: auk
# Contributor: Bet4 <0xbet4@gmail.com>

pkgname=hyper
_pkgver=3.1.0-canary.4
pkgver=${_pkgver/-/.}
pkgrel=1
pkgdesc="A terminal built on web technologies"
arch=('any')
url="https://hyper.is/"
license=('MIT')
makedepends=('git' 'npm' 'yarn' 'python')
conflicts=('hyperterm')
replaces=('hyperterm')
source=(
    "git+https://github.com/zeit/$pkgname.git#tag=$_pkgver"
    'https://raw.githubusercontent.com/zeit/art/master/hyper/mark/Hyper-Mark-120@3x.png'
    'Hyper.desktop'
    'disable-auto-update.diff'
)
sha256sums=('SKIP'
         'a928049af63f49dd270a26c7099dccbe038124e4195507919f2d062e5cd2ecaa'
         'ae29bd930c822c3144817a0e2fe2e2a8253fde90d31b0e19ad7880cd35609ebf'
         '20244b8ca2b253be04f6f8a009d9f4c6b78bc391b40445eff7c6f762b145a0ce')

prepare() {
    cd "$pkgname"

    patch -p1 < ../disable-auto-update.diff

    # yarn is a build-dep according to the README
    yarn install
}

build() {
    cd "$pkgname"

    # This build command is the same as the one defined in package.json via
    # npm run dist except that it doesn't build for debian, rpm, etc. and
    # doesn't require some other dependencies

    # add node_modules binaries to PATH
    oldpath=$PATH
    PATH=$(pwd)/node_modules/.bin:$PATH

    yarn run build &&
    cross-env BABEL_ENV=production babel target/renderer/bundle.js \
        --out-file target/renderer/bundle.js \
        --no-comments \
        --minified &&
    electron-builder --linux --dir

    PATH=$oldpath
}

package() {
    cd "$pkgname"

    install -dm755 "$pkgdir/usr/lib/$pkgname"
    cp -r dist/linux-unpacked/* "$pkgdir/usr/lib/$pkgname"

    # fix chrome-sandbox permissions
    chmod 4755 "$pkgdir/usr/lib/$pkgname/chrome-sandbox"

    install -dm755 "$pkgdir/usr/bin"
    # link the binary to /usr/bin
    ln -s "../lib/$pkgname/resources/bin/hyper" "$pkgdir/usr/bin/hyper"

    install -Dm644 "$srcdir/Hyper.desktop" "$pkgdir/usr/share/applications/Hyper.desktop"
    install -Dm644 "$srcdir/Hyper-Mark-120@3x.png" "$pkgdir/usr/share/pixmaps/hyper.png"
}
