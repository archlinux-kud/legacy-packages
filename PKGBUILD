# Maintainer: Rodrigo Bezerra <rodrigobezerra21 at gmail dot com>
# Contributor: orumin <dev@orum.in>

_basename=chromaprint
pkgname="lib32-$_basename"
pkgver=1.5.0
pkgrel=1
pkgdesc='Library that implements a custom algorithm for extracting fingerprints from any audio source (32-bit)'
url='https://acoustid.org/chromaprint'
arch=('x86_64')
license=('LGPL')
depends=('lib32-ffmpeg' 'chromaprint')
makedepends=('cmake')
source=("https://github.com/acoustid/chromaprint/releases/download/v${pkgver}/chromaprint-${pkgver}.tar.gz"
        'lib32.patch' # otherwise it'll try to link lib64 one
)
sha256sums=('573a5400e635b3823fc2394cfa7a217fbb46e8e50ecebd4a61991451a8af766a'
            '25b77b8ba5bd1efb8f0b234117cb57ee1f007ea6e05c9693fae8b8e583c82c46')

prepare() {
    mkdir build || /bin/true

    cd "$_basename-v$pkgver"
    patch -Np1 < ../lib32.patch
}

build() {
    cd build

    export CC='gcc -m32'
    export CXX='g++ -m32'
    export PKG_CONFIG_PATH='/usr/lib32/pkgconfig'

    cmake "../$_basename-v$pkgver" \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DLIB_SUFFIX=32 \
        -DCMAKE_BUILD_TYPE=Release

    make
}

package() {
    cd build

    make DESTDIR="$pkgdir" install
    rm -r "$pkgdir"/usr/include
}
