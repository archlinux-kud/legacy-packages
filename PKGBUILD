# Maintainer: Albert I <kras@raphielgang.org>

pkgname=megacmd-dynamic
pkgver=1.4.1
_sdkver=3.7.3h
pkgrel=1
pkgdesc='MEGA Command Line Interactive and Scriptable Application (dynamically linked version)'
arch=(x86_64)
url='https://mega.nz/cmd'
license=(BSD-2-Clause GPL3)
depends=(crypto++ freeimage libmediainfo libsodium libuv sqlite zlib
         libavcodec.so libavformat.so libavutil.so libcares.so libswscale.so)
optdepends=('bash-completion: for completion script')
provides=("megacmd=$pkgver" "mega-sdk=$_sdkver")
conflicts=(megacmd mega-sdk)
source=(
    git+https://github.com/meganz/MEGAcmd.git#commit=ef6cdeaf2d289d487c77f2231af45a1677dfb566
    git+https://github.com/meganz/sdk.git#commit=0e79b2739f695d08efed5a61bbf44362e127c30b
    libavformat58.patch
)
b2sums=(
    SKIP
    SKIP
    909f810df6402af8c533b02b0b36a59d9ccbc06c6b3b851676b2691b752fdb7cb0ca9c50c14dea138d7c192cdc58d61c35e5621495e6488f6e4fe09169f5c2c3
)

prepare() {
    cd MEGAcmd

    # init SDK
    git submodule init sdk
    git config submodule.sdk.url ../sdk
    git submodule update sdk

    cd sdk
    patch -Np1 -i "$srcdir"/libavformat58.patch

    cd ..
    ./autogen.sh
}

build() {
    cd MEGAcmd

    CPPFLAGS="$CPPFLAGS -DREQUIRE_HAVE_FFMPEG -DREQUIRE_HAVE_LIBUV -DREQUIRE_USE_MEDIAINFO -DREQUIRE_USE_PCRE" \
    ./configure --prefix=/usr \
        --disable-examples \
        --without-libraw \
        --with-cares \
        --with-cryptopp \
        --with-curl \
        --with-freeimage \
        --with-libmediainfo \
        --with-libsodium \
        --with-libuv \
        --with-libzen \
        --with-pcre \
        --with-readline

    make
}

package() {
    make -C MEGAcmd DESTDIR="$pkgdir" install
    # the Makefile installs bash completion scripts at wrong path
    mv "$pkgdir"/{usr/,}etc
    install -Dm644 MEGAcmd/LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}
