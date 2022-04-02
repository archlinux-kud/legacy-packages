# Maintainer: Albert I <kras@raphielgang.org>

pkgname=megacmd-dynamic
pkgver=1.5.0b
_sdkver=3.9.11b
pkgrel=2
pkgdesc='MEGA Command Line Interactive and Scriptable Application (dynamically linked version)'
arch=(x86_64)
url='https://mega.nz/cmd'
license=(BSD-2-Clause GPL3)
depends=(
    crypto++ freeimage libmediainfo libpdfium libsodium libuv openssl pcre sqlite zlib
    libavcodec.so libavformat.so libavutil.so libcares.so libcurl.so libreadline.so libswscale.so
)
optdepends=('bash-completion: for completion script')
provides=("megacmd=$pkgver" "mega-sdk=$_sdkver")
conflicts=(megacmd mega-sdk)
source=(
    "git+https://github.com/meganz/MEGAcmd.git#tag=${pkgver}_Linux"
    'git+https://github.com/meganz/sdk.git#commit=f6438d55fa6b1ef54eb2b8832a1da7502a56df13'
    'ffmpeg.patch' # fix compile with newer FFmpeg versions
    'pdfium.patch' # libpdfium-nojs has headers on /usr/include/pdfium
)
b2sums=(
    'SKIP'
    'SKIP'
    'a8b7a49237a0594ca33b30eccc9350ac298514aa4afc37fe7701cc7790f201566d45ac13c2a77a2084166f086d6c288d952c0e931ae1e514f012e56ae67ef2b4'
    '5650db077305e3d8ef49629437a6cdb0abad56232b1d7f364e4214157a715841406e16b45cfce87bea8ad903a6d1d3db0cbf89ada3e2e47f42bfd19414012bea'
)

prepare() {
    cd MEGAcmd

    # init SDK
    git submodule init sdk
    git config submodule.sdk.url ../sdk
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
