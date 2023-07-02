# Maintainer: Albert I <kras@raphielgang.org>

pkgname=megacmd
pkgver=1.6.3
_sdkver=4.17.1d
pkgrel=3
pkgdesc='MEGA Command Line Interactive and Scriptable Application'
arch=('x86_64')
url='https://mega.nz/cmd'
license=('BSD' 'GPL3')
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
    'ffmpeg.patch' # fix compilation with FFmpeg 6.x
    'pdfium.patch' # libpdfium-nojs has headers on /usr/include/pdfium
)
sha512sums=('SKIP'
            'SKIP'
            '45ad4d0a50057e4500e5ef312691d958b96a20905b9dbe7851da0411f6da20ae287a9aca275bae30689ee38a4ea5dd881c3ddc3e1db736f4b3d1052335917fb1'
            '8fbf76a670c2923fe61de46b159128180cf69caead90ef8bc62c2829a8ca94846127149863089f9c572fcb998229244f828230791fd51b8339698732704c94f6')
b2sums=('SKIP'
        'SKIP'
        '1d902c55fa8c5ceb5a225d1eceff3b15d8c62cb72c232a78d902c8afcd45a8d0f87e906cf21a7331aa287cd40926e9ab7d411a1fcfc7060db72f8116814938aa'
        '3c140752bd1be91525888ee88048ab0df9aa1834096773301f9672f6d4e1651a88c6318e1e5dc5349f47292ca1adf2778223c10a973f43bb7c8a997972b18109')

prepare() {
    cd "${srcdir}/MEGAcmd"

    # init SDK
    git submodule init sdk
    git config submodule.sdk.url "${srcdir}/meganz-sdk"
    GIT_ALLOW_PROTOCOL=file git submodule update sdk

    # cherry-pick from newer SDK to fix build against FFmpeg >= 4.4
    git -C sdk cherry-pick --no-commit \
        1a1b4a8c24099d7cf69fb7754966aed4507d727e \
        a6a4d19149eae0f7e3ebe7cc8be0d4ca2b6f99e9

    # see comments on ${source[@]} above on what these patches do
    patch -d sdk -N -p1 < "${srcdir}/ffmpeg.patch"
    patch -d sdk -N -p1 < "${srcdir}/pdfium.patch"

    ./autogen.sh
}

build() {
    cd "${srcdir}/MEGAcmd"

    CPPFLAGS+=" -DREQUIRE_HAVE_FFMPEG -DREQUIRE_HAVE_LIBUV -DREQUIRE_HAVE_PDFIUM -DREQUIRE_USE_MEDIAINFO -DREQUIRE_USE_PCRE" \
    ./configure --prefix=/usr --sysconfdir=/etc \
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
    DESTDIR="${pkgdir}" make -C "${srcdir}/MEGAcmd" install

    # copy BSD license file for included mega-sdk
    install -Dm644 "${srcdir}/MEGAcmd/sdk/LICENSE" \
        "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE.sdk"
}
