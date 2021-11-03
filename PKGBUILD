# Maintainer: Albert I <kras@raphielgang.org>
# Contributor: Sven-Hendrik Haase <svenstaro@gmail.com>
# Contributor: hexchain <i@hexchain.org>
pkgname=64gram-desktop
pkgver=3.1.11.2
pkgrel=1
pkgdesc='Third party Telegram Desktop client with various enhancements'
arch=('x86_64')
url="https://github.com/TDesktop-x64"
license=('GPL3')
depends=('hunspell' 'ffmpeg' 'hicolor-icon-theme' 'lz4' 'minizip' 'openal' 'ttf-opensans'
         'qt5-imageformats' 'qt5-svg' 'xxhash' 'libdbusmenu-qt5' 'kwayland' 'glibmm'
         'rnnoise' 'pipewire' 'libxtst' 'libxrandr' 'jemalloc' 'libtg_owt')
makedepends=('cmake' 'git' 'ninja' 'python' 'range-v3' 'tl-expected' 'microsoft-gsl'
             'extra-cmake-modules' 'gtk3' 'webkit2gtk')
optdepends=('gtk3: GTK environment integration'
            'webkit2gtk: embedded browser features'
            'xdg-desktop-portal: desktop integration')
provides=("telegram-desktop")
conflicts=("telegram-desktop")
replaces=("tdesktop-x64")
source=("tdesktop::git+https://github.com/TDesktop-x64/tdesktop.git#tag=v$pkgver"
        "telegram-desktop-libtgvoip::git+https://github.com/telegramdesktop/libtgvoip.git#commit=373e41668b265864f8976b83bb66dd6e9a583915"
        "telegram-desktop-GSL::git+https://github.com/microsoft/GSL.git#commit=1999b48a519196711f0d03af3b7eedd49fcc6db3"
        "telegram-desktop-Catch::git+https://github.com/catchorg/Catch2.git#commit=5ca44b68721833ae3731802ed99af67c6f38a53a"
        "telegram-desktop-xxHash::git+https://github.com/Cyan4973/xxHash.git#commit=7cc9639699f64b750c0b82333dced9ea77e8436e"
        "telegram-desktop-rlottie::git+https://github.com/desktop-app/rlottie.git#commit=cbd43984ebdf783e94c8303c41385bf82aa36d5b"
        "telegram-desktop-lz4::git+https://github.com/lz4/lz4.git#commit=9a2a9f2d0f38a39c5ec9b329042ca5f060b058e0"
        "telegram-desktop-lib_crl::git+https://github.com/desktop-app/lib_crl.git#commit=ec103d6bccaa59b56537c8658c9e41415bb9ccaf"
        "telegram-desktop-lib_rpl::git+https://github.com/desktop-app/lib_rpl.git#commit=df721be3fa14a27dfc230d2e3c42bb1a7c9d0617"
        "telegram-desktop-lib_base::git+https://github.com/TDesktop-x64/lib_base.git#commit=6ff79285ffbac11cd4e1ee9b3cef569ab4ca2137"
        "telegram-desktop-codegen::git+https://github.com/desktop-app/codegen.git#commit=a60edf917419407cfe5c6095a56ccf363417ebd8"
        "telegram-desktop-lib_ui::git+https://github.com/TDesktop-x64/lib_ui.git#commit=a82cb64271cd0bd3f92ce04b6b7dfba16c60289e"
        "telegram-desktop-lib_rlottie::git+https://github.com/desktop-app/lib_rlottie.git#commit=0671bf70547381effcf442ec9618e04502a8adbc"
        "telegram-desktop-lib_lottie::git+https://github.com/desktop-app/lib_lottie.git#commit=c75d91f75ef87077f07ea6f7087343274b3eb5ff"
        "telegram-desktop-lib_tl::git+https://github.com/desktop-app/lib_tl.git#commit=45faed44e7f4d11fec79b7a70e4a35dc91ef3fdb"
        "telegram-desktop-lib_spellcheck::git+https://github.com/desktop-app/lib_spellcheck.git#commit=7eb030da7e681c56ce2619c13840b9f8f4adae0d"
        "telegram-desktop-lib_storage::git+https://github.com/desktop-app/lib_storage.git#commit=73d57840ac603107381e0e6b22d5b3bdcae492c6"
        "telegram-desktop-cmake::git+https://github.com/TDesktop-x64/cmake_helpers.git#commit=3b6d298c0fa0b50afe507886c0c0bba4d045030d"
        "telegram-desktop-expected::git+https://github.com/TartanLlama/expected.git#commit=1d9c5d8c0da84b8ddc54bd3d90d632eec95c1f13"
        "telegram-desktop-QR::git+https://github.com/nayuki/QR-Code-generator.git#commit=67c62461d380352500fc39557fd9f046b7fe1d18"
        "telegram-desktop-lib_qr::git+https://github.com/desktop-app/lib_qr.git#commit=2b08c71c6edcfc3e31f7d7f518cc963493b6e189"
        "telegram-desktop-libdbusmenu-qt::git+https://github.com/desktop-app/libdbusmenu-qt.git#commit=af9fa001dac49eedc76e15613b67abfd097105f3"
        "telegram-desktop-hunspell::git+https://github.com/hunspell/hunspell.git#commit=d6a5ae5986c0f0d6e280aa177c017b0cb0fc7fda"
        "telegram-desktop-range-v3::git+https://github.com/ericniebler/range-v3.git#commit=413c8f9aacb269f6440fe180b587fd70c7ba16df"
        "telegram-desktop-fcitx-qt5::git+https://github.com/fcitx/fcitx-qt5.git#commit=c2feea444ab79e6a8d6d205d4c7b13ab1db353c9"
        "telegram-desktop-nimf::git+https://github.com/hamonikr/nimf.git#commit=7234ac6724f4b7870aebed4dae95a4b9edbccd70"
        "telegram-desktop-hime::git+https://github.com/hime-ime/hime.git#commit=9b3e6f9ab59d1fe4d9de73d3bf0fed7789f921c5"
        "telegram-desktop-fcitx5-qt::git+https://github.com/fcitx/fcitx5-qt.git#commit=8543204b9a3792e0dbd4163ee9420e896f4f49d8"
        "telegram-desktop-lib_webrtc::git+https://github.com/desktop-app/lib_webrtc.git#commit=9d617f17463d07ff45515800c8fd865939144413"
        "telegram-desktop-tgcalls::git+https://github.com/TDesktop-x64/tgcalls.git#commit=949496f8a866fccbe2e21dae7c1277adacc08ddc"
        "telegram-desktop-lib_webview::git+https://github.com/desktop-app/lib_webview.git#commit=0a3584b8d8e37f9745a0cb0fae725e8e8ea0d989"
        "telegram-desktop-lib_waylandshells::git+https://github.com/desktop-app/lib_waylandshells.git#commit=928501605f02fd7ddc4ab267fdbfa40f65ddd6d8"
        "telegram-desktop-jemalloc::git+https://github.com/jemalloc/jemalloc.git#commit=ea6b3e973b477b8061e0076bb257dbd7f3faa756"
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
        'SKIP')

prepare() {
    cd "$srcdir/tdesktop"
    ## git config generated by
    # python -c 'import configparser, os.path; c=configparser.ConfigParser();c.read(".gitmodules"); print("\n".join(f"    git config submodule.{path}.url \"$srcdir/telegram-desktop-{p}\"" for s in c.sections() if (url:=c[s]["url"], path:=c[s]["path"], p:=os.path.basename(path))))'
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
    git config submodule.cmake.url "$srcdir/telegram-desktop-cmake"
    git config submodule.Telegram/ThirdParty/expected.url "$srcdir/telegram-desktop-expected"
    git config submodule.Telegram/ThirdParty/QR.url "$srcdir/telegram-desktop-QR"
    git config submodule.Telegram/lib_qr.url "$srcdir/telegram-desktop-lib_qr"
    git config submodule.Telegram/ThirdParty/libdbusmenu-qt.url "$srcdir/telegram-desktop-libdbusmenu-qt"
    git config submodule.Telegram/ThirdParty/hunspell.url "$srcdir/telegram-desktop-hunspell"
    git config submodule.Telegram/ThirdParty/range-v3.url "$srcdir/telegram-desktop-range-v3"
    git config submodule.Telegram/ThirdParty/fcitx-qt5.url "$srcdir/telegram-desktop-fcitx-qt5"
    git config submodule.Telegram/ThirdParty/nimf.url "$srcdir/telegram-desktop-nimf"
    git config submodule.Telegram/ThirdParty/hime.url "$srcdir/telegram-desktop-hime"
    git config submodule.Telegram/ThirdParty/fcitx5-qt.url "$srcdir/telegram-desktop-fcitx5-qt"
    git config submodule.Telegram/lib_webrtc.url "$srcdir/telegram-desktop-lib_webrtc"
    git config submodule.Telegram/ThirdParty/tgcalls.url "$srcdir/telegram-desktop-tgcalls"
    git config submodule.Telegram/lib_webview.url "$srcdir/telegram-desktop-lib_webview"
    git config submodule.Telegram/lib_waylandshells.url "$srcdir/telegram-desktop-lib_waylandshells"
    git config submodule.Telegram/ThirdParty/jemalloc.url "$srcdir/telegram-desktop-jemalloc"
    git submodule update
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
        -DDESKTOP_APP_QT6=OFF \
        -DTDESKTOP_API_ID=611335 \
        -DTDESKTOP_API_HASH=d524b414d21f4d37f08684c1df41ac9c
    ninja -C build
}

package() {
    cd "$srcdir/tdesktop"
    DESTDIR=$pkgdir ninja -C build install
}
