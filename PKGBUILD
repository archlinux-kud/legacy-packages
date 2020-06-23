# Maintainer: Albert I <kras@raphielgang.org>

pkgname=megacmd-dynamic
pkgver=1.3.0
_sdkver=3.7.0b
pkgrel=1
pkgdesc='MEGA Command Line Interactive and Scriptable Application (dynamic version)'
arch=(x86_64)
url='https://mega.nz/cmd'
license=(BSD-2-Clause GPL3)
depends=('c-ares' 'crypto++' 'ffmpeg' 'freeimage' 'libsodium' 'libuv' 'mediainfo' 'sqlite' 'zlib')
optdepends=('bash-completion: for completion script')
provides=("megacmd=$pkgver" "mega-sdk=$_sdkver")
conflicts=(megacmd mega-sdk)
source=("git+https://github.com/meganz/MEGAcmd.git#branch=release/$pkgver"
        'git+https://github.com/meganz/sdk.git#commit=b2948c7c77862e99dee912f4fe321d3c6dac6b09'
        '100-megacmd-inotify-limit.conf')
sha384sums=('SKIP'
            'SKIP'
            '2deaecee10d8b0d350cf3ee57f0aafdb2096fbff21b364596f2f57dfe0f82eff85c77510d7a1569f7b9d85116160c360')

prepare() {
    cd MEGAcmd

    # init SDK
    git submodule init sdk
    git config submodule.sdk.url ../sdk
    git submodule update sdk

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

    install -Dm644 100-megacmd-inotify-limit.conf "$pkgdir"/etc/sysctl.d/100-megacmd-inotify-limit.conf
    install -Dm644 MEGAcmd/LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}
