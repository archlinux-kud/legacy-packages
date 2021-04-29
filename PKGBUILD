# Maintainer: Albert I <kras@raphielgang.org>
# Contributor: Sven-Hendrik Haase <svenstaro@gmail.com>
# Contributor: hexchain <i@hexchain.org>
pkgname=tdesktop-x64
pkgver=2.7.4.1
pkgrel=1
pkgdesc='Third party Telegram Desktop client with various enhancements'
arch=('x86_64')
url="https://github.com/TDesktop-x64"
license=('GPL3')
depends=('hunspell' 'ffmpeg' 'hicolor-icon-theme' 'lz4' 'minizip' 'openal'
         'qt5-imageformats' 'xxhash' 'libdbusmenu-qt5' 'kwayland' 'gtk3' 'glibmm' 'webkit2gtk')
makedepends=('cmake' 'git' 'ninja' 'python' 'range-v3' 'tl-expected' 'microsoft-gsl' 'libtg_owt')
optdepends=('ttf-opensans: default Open Sans font family')
provides=("telegram-desktop")
conflicts=("telegram-desktop")
# Use stable versions wherever possible
source=("tdesktop::git+https://github.com/TDesktop-x64/tdesktop#tag=v$pkgver"
        "telegram-desktop-libtgvoip::git+https://github.com/telegramdesktop/libtgvoip#commit=13a5fcb16b04472d808ce122abd695dbf5d206cd"
        "telegram-desktop-GSL::git+https://github.com/microsoft/GSL#tag=v3.1.0"
        "telegram-desktop-Catch::git+https://github.com/catchorg/Catch2#tag=v2.13.6"
        "telegram-desktop-xxHash::git+https://github.com/Cyan4973/xxHash#tag=v0.8.0"
        "telegram-desktop-rlottie::git+https://github.com/desktop-app/rlottie.git#commit=cbd43984ebdf783e94c8303c41385bf82aa36d5b"
        "telegram-desktop-lz4::git+https://github.com/lz4/lz4#tag=v1.9.3"
        "telegram-desktop-lib_crl::git+https://github.com/desktop-app/lib_crl.git#commit=16150bf71d79382738114b913f137ec1a1a7630c"
        "telegram-desktop-lib_rpl::git+https://github.com/desktop-app/lib_rpl.git#commit=e1b96399d9031c4ef0354631e6bb375029d29d9f"
        "telegram-desktop-lib_base::git+https://github.com/TDesktop-x64/lib_base#commit=a08ac7635bb80f60c3722e9b32c031aed83e6808"
        "telegram-desktop-codegen::git+https://github.com/desktop-app/codegen.git#commit=a4904e076b1d1bfd00cd26f283a5e9ccd9740ac1"
        "telegram-desktop-lib_ui::git+https://github.com/TDesktop-x64/lib_ui#commit=04d84b1f7233d2d349b6076019de1b0eda9f324e"
        "telegram-desktop-lib_rlottie::git+https://github.com/desktop-app/lib_rlottie.git#commit=0671bf70547381effcf442ec9618e04502a8adbc"
        "telegram-desktop-lib_lottie::git+https://github.com/desktop-app/lib_lottie.git#commit=71fecd909b0d5553153ecb6803f03a91158aeefb"
        "telegram-desktop-lib_tl::git+https://github.com/desktop-app/lib_tl.git#commit=45faed44e7f4d11fec79b7a70e4a35dc91ef3fdb"
        "telegram-desktop-lib_spellcheck::git+https://github.com/desktop-app/lib_spellcheck#commit=d35fe8aa38a26bfcefd32286d48c371e1c7317b0"
        "telegram-desktop-lib_storage::git+https://github.com/desktop-app/lib_storage.git#commit=99d7122ddc9f61b6e910db11692426661525647f"
        "telegram-desktop-cmake_helpers::git+https://github.com/TDesktop-x64/cmake_helpers#commit=d2b17c6d577270f2ececcb44f991f95700a75112"
        "telegram-desktop-expected::git+https://github.com/TartanLlama/expected#tag=v1.0.0"
        "telegram-desktop-QR-Code-generator::git+https://github.com/nayuki/QR-Code-generator#tag=v1.6.0"
        "telegram-desktop-lib_qr::git+https://github.com/desktop-app/lib_qr.git#commit=92ce41a690a463eb462089a4eb1e51e019308018"
        "telegram-desktop-libdbusmenu-qt::git+https://github.com/desktop-app/libdbusmenu-qt.git#commit=75afa1003c1d0f6fdfa3a76ce2db689b49f86968"
        "telegram-desktop-hunspell::git+https://github.com/hunspell/hunspell#tag=v1.7.0"
        "telegram-desktop-range-v3::git+https://github.com/ericniebler/range-v3#tag=0.11.0"
        "telegram-desktop-fcitx-qt5::git+https://github.com/fcitx/fcitx-qt5#tag=1.2.6"
        "telegram-desktop-nimf::git+https://github.com/hamonikr/nimf#tag=1.3.0"
        "telegram-desktop-hime::git+https://github.com/hime-ime/hime#tag=v0.9.11"
        "telegram-desktop-qt5ct::git+https://github.com/desktop-app/qt5ct#commit=9f60cd2352a4dcc55c8ca267f29bd8fff5c6a659" # 1.2
        "telegram-desktop-fcitx5-qt::git+https://github.com/fcitx/fcitx5-qt#tag=5.0.5"
        "telegram-desktop-lib_webrtc::git+https://github.com/desktop-app/lib_webrtc.git#commit=5270a1dbbdbee643e187e175f798595b4bc49996"
        "telegram-desktop-tgcalls::git+https://github.com/TDesktop-x64/tgcalls#commit=2c917fb9e27fd08dbdfc52238801b2c11a92eade"
        "telegram-desktop-lib_webview::git+https://github.com/desktop-app/lib_webview#commit=91c0e6664db4a444d630e3a0101f599a92df1dd9"
        "fix-webview-includes.patch"
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
        'SKIP'
        'b790b51ff99a0f6fbc51e1589da277df5159ac301b49c14577b9b147ef8ec6819a20373f6a89c5f8d1558c3aafab0a9e14f3a5804481c8676fad5a11ae614f95')

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
    git config sumbodule.Telegram/lib_webview.url "$srcdir/telegram-desktop-lib_webview"
    git submodule update

    cd "$srcdir/tdesktop/cmake"
    # force webrtc link to libjpeg
    echo "target_link_libraries(external_webrtc INTERFACE jpeg)" | tee -a external/webrtc/CMakeLists.txt

    cd ../Telegram/lib_webview
    patch -Np1 -i "$srcdir"/fix-webview-includes.patch
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
