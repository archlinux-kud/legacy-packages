# Maintainer: Albert I <kras@raphielgang.org>
# Contributor: Sven-Hendrik Haase <svenstaro@gmail.com>
# Contributor: hexchain <i@hexchain.org>
pkgname=tdesktop-x64
pkgver=2.7.1.1
pkgrel=1
pkgdesc='Third party Telegram Desktop client with various enhancements'
arch=('x86_64')
url="https://github.com/TDesktop-x64"
license=('GPL3')
depends=('hunspell' 'ffmpeg' 'hicolor-icon-theme' 'lz4' 'minizip' 'openal'
         'qt5-imageformats' 'xxhash' 'libdbusmenu-qt5' 'kwayland' 'gtk3' 'glibmm')
makedepends=('cmake' 'git' 'ninja' 'python' 'range-v3' 'tl-expected' 'microsoft-gsl' 'libtg_owt-git')
optdepends=('ttf-opensans: default Open Sans font family')
provides=("telegram-desktop")
conflicts=("telegram-desktop")
# Use stable versions wherever possible
source=("tdesktop::git+https://github.com/TDesktop-x64/tdesktop#tag=v$pkgver"
        "telegram-desktop-libtgvoip::git+https://github.com/telegramdesktop/libtgvoip#commit=13a5fcb16b04472d808ce122abd695dbf5d206cd"
        "telegram-desktop-GSL::git+https://github.com/microsoft/GSL#tag=v3.1.0"
        "telegram-desktop-Catch::git+https://github.com/catchorg/Catch2#tag=v2.13.4"
        "telegram-desktop-xxHash::git+https://github.com/Cyan4973/xxHash#tag=v0.8.0"
        "telegram-desktop-rlottie::git+https://github.com/desktop-app/rlottie.git#commit=cbd43984ebdf783e94c8303c41385bf82aa36d5b"
        "telegram-desktop-lz4::git+https://github.com/lz4/lz4#tag=v1.9.3"
        "telegram-desktop-lib_crl::git+https://github.com/desktop-app/lib_crl.git#commit=16150bf71d79382738114b913f137ec1a1a7630c"
        "telegram-desktop-lib_rpl::git+https://github.com/desktop-app/lib_rpl.git#commit=e1b96399d9031c4ef0354631e6bb375029d29d9f"
        "telegram-desktop-lib_base::git+https://github.com/TDesktop-x64/lib_base#commit=b2988bc06efc9900e7505a8c777d5c58a8708eb0"
        "telegram-desktop-codegen::git+https://github.com/desktop-app/codegen.git#commit=a4904e076b1d1bfd00cd26f283a5e9ccd9740ac1"
        "telegram-desktop-lib_ui::git+https://github.com/TDesktop-x64/lib_ui#commit=60588946890de3b20479660d9344575284f8e5f6"
        "telegram-desktop-lib_rlottie::git+https://github.com/desktop-app/lib_rlottie.git#commit=0671bf70547381effcf442ec9618e04502a8adbc"
        "telegram-desktop-lib_lottie::git+https://github.com/desktop-app/lib_lottie.git#commit=475d43337a3b397e2c9f6e975929ae15695aa346"
        "telegram-desktop-lib_tl::git+https://github.com/desktop-app/lib_tl.git#commit=404c83d77e5edb8a39f8e9f56a6340960fe5070e"
        "telegram-desktop-lib_spellcheck::git+https://github.com/desktop-app/lib_spellcheck#commit=5ae68777478250c49520629420290f231173e1ca"
        "telegram-desktop-lib_storage::git+https://github.com/desktop-app/lib_storage.git#commit=99d7122ddc9f61b6e910db11692426661525647f"
        "telegram-desktop-cmake_helpers::git+https://github.com/TDesktop-x64/cmake_helpers#commit=e9b78045251584dc069c2a302126448b40a0667d"
        "telegram-desktop-expected::git+https://github.com/TartanLlama/expected#tag=v1.0.0"
        "telegram-desktop-QR-Code-generator::git+https://github.com/nayuki/QR-Code-generator#tag=v1.6.0"
        "telegram-desktop-lib_qr::git+https://github.com/desktop-app/lib_qr.git#commit=92ce41a690a463eb462089a4eb1e51e019308018"
        "telegram-desktop-libdbusmenu-qt::git+https://github.com/desktop-app/libdbusmenu-qt.git#commit=75afa1003c1d0f6fdfa3a76ce2db689b49f86968"
        "telegram-desktop-hunspell::git+https://github.com/hunspell/hunspell#tag=v1.7.0"
        "telegram-desktop-range-v3::git+https://github.com/ericniebler/range-v3#tag=0.11.0"
        "telegram-desktop-fcitx-qt5::git+https://github.com/fcitx/fcitx-qt5#tag=1.2.5"
        "telegram-desktop-nimf::git+https://github.com/hamonikr/nimf#tag=1.3.0"
        "telegram-desktop-hime::git+https://github.com/hime-ime/hime#tag=v0.9.11"
        "telegram-desktop-qt5ct::git+https://github.com/desktop-app/qt5ct#commit=9f60cd2352a4dcc55c8ca267f29bd8fff5c6a659" # 1.2
        "telegram-desktop-fcitx5-qt::git+https://github.com/fcitx/fcitx5-qt#tag=5.0.3"
        "telegram-desktop-lib_webrtc::git+https://github.com/desktop-app/lib_webrtc.git#commit=f95214cbe4b0a31ac989e0aceb8cc4f63c1322e6"
        "telegram-desktop-tgcalls::git+https://github.com/TDesktop-x64/tgcalls#commit=938ce0c5f83b2fdad3ae4fe62f9d93d3b1aaf00d"
        tgcalls-fix-build.patch
)
b2sums=('SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        'SKIP'
        ce154fd0754e37be0be331012834704dfdc247d0740c3ce7e275250934dc93f4f234121fd270aeb17f4e30e79f9f130fb30bfda69a21b792d9dc6b363f3b434a)

prepare() {
    cd "$srcdir/tdesktop"
    git submodule init
    git config submodule.Telegram/ThirdParty/libtgvoip.url "$srcdir/telegram-desktop-libtgvoip"
    git config submodule.Telegram/ThirdParty/GSL.url "$srcdir/telegram-desktop-GSL"
    git config submodule.Telegram/ThirdParty/Catch.url "$srcdir/telegram-desktop-Catch"
    git config submodule.Telegram/ThirdParty/xxHash.url "$srcdir/telegram-desktop-xxHash"
    git config submodule.Telegram/ThirdParty/rlottie.url "$srcdir/telegram-desktop-rlottie"
    git config submodule.Telegram/ThirdParty/lz4.url "$srcdir/telegram-desktop-lz4"
    git config submodule.Telegram/lib_crl.url "$srcdir/telegram-desktop-lib_crl"
    git config submodule.Telegram/lib_rpl.url "$srcdir/telegram-desktop-lib_rpl"
    git config submodule.Telegram/lib_base.url "$srcdir/telegram-desktop-lib_base"
    git config submodule.Telegram/codegen.url "$srcdir/telegram-desktop-codegen"
    git config submodule.Telegram/lib_ui.url "$srcdir/telegram-desktop-lib_ui"
    git config submodule.Telegram/lib_rlottie.url "$srcdir/telegram-desktop-lib_rlottie"
    git config submodule.Telegram/lib_lottie.url "$srcdir/telegram-desktop-lib_lottie"
    git config submodule.Telegram/lib_tl.url "$srcdir/telegram-desktop-lib_tl"
    git config submodule.Telegram/lib_spellcheck.url "$srcdir/telegram-desktop-lib_spellcheck"
    git config submodule.Telegram/lib_storage.url "$srcdir/telegram-desktop-lib_storage"
    git config submodule.cmake.url "$srcdir/telegram-desktop-cmake_helpers"
    git config submodule.Telegram/ThirdParty/expected.url "$srcdir/telegram-desktop-expected"
    git config submodule.Telegram/ThirdParty/QR.url "$srcdir/telegram-desktop-QR-Code-generator"
    git config submodule.Telegram/lib_qr.url "$srcdir/telegram-desktop-lib_qr"
    git config submodule.Telegram/ThirdParty/libdbusmenu-qt.url "$srcdir/telegram-desktop-libdbusmenu-qt"
    git config sumbodule.Telegram/ThirdParty/hunspell.url "$srcdir/telegram-desktop-hunspell"
    git config sumbodule.Telegram/ThirdParty/range-v3.url "$srcdir/telegram-desktop-range-v3"
    git config sumbodule.Telegram/ThirdParty/fcitx-qt5.url "$srcdir/telegram-desktop-fcitx-qt5"
    git config sumbodule.Telegram/ThirdParty/nimf.url "$srcdir/telegram-desktop-nimf"
    git config sumbodule.Telegram/ThirdParty/hime.url "$srcdir/telegram-desktop-hime"
    git config sumbodule.Telegram/ThirdParty/qt5ct.url "$srcdir/telegram-desktop-qt5ct"
    git config sumbodule.Telegram/ThirdParty/fcitx5-qt.url "$srcdir/telegram-desktop-fcitx5-qt"
    git config sumbodule.Telegram/lib_webrtc.url "$srcdir/telegram-desktop-lib_webrtc"
    git config sumbodule.Telegram/ThirdParty/tgcalls.url "$srcdir/telegram-desktop-tgcalls"
    git submodule update

    cd "$srcdir/tdesktop/cmake"
    # force webrtc link to libjpeg
    echo "target_link_libraries(external_webrtc INTERFACE jpeg)" | tee -a external/webrtc/CMakeLists.txt

    cd "$srcdir/tdesktop/Telegram/ThirdParty/tgcalls"
    git apply -3 ../../../../tgcalls-fix-build.patch
}

build() {
    cd "$srcdir/tdesktop"

    # Turns out we're allowed to use the official API key that telegram uses for their snap builds:
    # https://github.com/telegramdesktop/tdesktop/blob/8fab9167beb2407c1153930ed03a4badd0c2b59f/snap/snapcraft.yaml#L87-L88
    # Thanks @primeos!
    CXXFLAGS="$CXXFLAGS -fpermissive" \
    cmake . \
        -B build \
        -G Ninja \
        -DCMAKE_INSTALL_PREFIX="/usr" \
        -DCMAKE_BUILD_TYPE=Release \
        -DTDESKTOP_API_ID=611335 \
        -DTDESKTOP_API_HASH=d524b414d21f4d37f08684c1df41ac9c \
        -DTDESKTOP_LAUNCHER_BASENAME="telegramdesktop" \
        -DDESKTOP_APP_SPECIAL_TARGET=""
    ninja -C build
}

package() {
    cd "$srcdir/tdesktop"
    DESTDIR=$pkgdir ninja -C build install
}
