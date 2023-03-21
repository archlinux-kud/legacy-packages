# Maintainer: Albert I <kras@raphielgang.org>

pkgname=megacmd
pkgver=1.6.0
_sdkver=4.16.0b
pkgrel=1
pkgdesc='MEGA Command Line Interactive and Scriptable Application'
arch=('x86_64')
url='https://mega.nz/cmd'
license=('GPL3' 'custom:BSD-2-Clause')
depends=(
    'crypto++' 'freeimage' 'libmediainfo' 'libpdfium'
    'libsodium' 'libuv' 'openssl' 'pcre' 'sqlite' 'zlib'
    'libavcodec.so' 'libavformat.so' 'libavutil.so' 'libcares.so'
    'libcurl.so' 'libreadline.so' 'libswscale.so'
)
optdepends=('bash-completion: for completion script')
provides=("mega-sdk=${_sdkver}" 'libmega.so')
replaces=('megacmd-dynamic')
conflicts=('megacmd-dynamic' 'mega-sdk')
source=(
    "MEGAcmd::git+https://github.com/meganz/MEGAcmd.git#tag=${pkgver}_Linux"
    "meganz-sdk::git+https://github.com/meganz/sdk.git#tag=v${_sdkver}"
    'ffmpeg.patch' # fix compile with newer FFmpeg versions
    'pdfium.patch' # libpdfium-nojs has headers on /usr/include/pdfium
)
b2sums=(
    'SKIP'
    'SKIP'
    'f3ff19d916fbf6ec46e1f9e81c7c3111f143ebe5670804da91859ec304a46662812c00d2bba3d818e68f9798e161f78d7e2ea041766fbb3a5b7ab904e07ab1c2'
    '5650db077305e3d8ef49629437a6cdb0abad56232b1d7f364e4214157a715841406e16b45cfce87bea8ad903a6d1d3db0cbf89ada3e2e47f42bfd19414012bea'
)

prepare() {
    # file:/// protocol now defaults to user for security reasons
    export GIT_ALLOW_PROTOCOL=file

    cd MEGAcmd

    # init SDK
    git submodule init sdk
    git config submodule.sdk.url ../meganz-sdk
    git submodule update sdk

    pushd sdk
    patch -Np1 -i "$srcdir"/ffmpeg.patch
    patch -Np1 -i "$srcdir"/pdfium.patch
    popd

    ./autogen.sh
}

build() {
    cd MEGAcmd

    CPPFLAGS="$CPPFLAGS -DREQUIRE_HAVE_FFMPEG -DREQUIRE_HAVE_LIBUV -DREQUIRE_HAVE_PDFIUM -DREQUIRE_USE_MEDIAINFO -DREQUIRE_USE_PCRE" \
    ./configure --prefix=/usr \
        --disable-curl-checks \
        --disable-examples \
        --disable-silent-rules \
        --without-libraw \
        --with-cares \
        --with-cryptopp \
        --with-curl \
        --with-ffmpeg \
        --with-freeimage \
        --with-libmediainfo \
        --with-libuv \
        --with-libzen \
        --with-openssl \
        --with-pcre \
        --with-pdfium \
        --with-readline \
        --with-sodium \
        --with-sqlite \
        --with-zlib

    make
}

package() {
    make -C MEGAcmd DESTDIR="$pkgdir" install
    # the Makefile installs bash completion scripts at wrong path
    mv "$pkgdir"/{usr/,}etc
    install -Dm644 MEGAcmd/LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}
