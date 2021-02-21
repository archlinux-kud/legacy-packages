# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154,SC2164

# Maintainer: Albert I <kras@raphielgang.org>

pkgname=android-firmware-extractor-git
pkgver=r135.f424572
pkgrel=1
pkgdesc='Collection of tools to extract images from stock Android firmware'
arch=(x86_64)
url='https://github.com/AndroidDumps/Firmware_extractor'
license=(GPL3 custom)
depends=(
    # as used by extractor.sh
    brotli lz4 p7zip perl-rename
    # for python scripts, although only oppo_ozip_decrypt says it needs 3.6+
    'python>=3.6.0' python2
    # for multiple python scripts
    python-argparse
    # as used by undz.py
    python-zstandard
    # for extract_android_ota_payload
    'python-protobuf>=3.6.0'
    # for oppo_ozip_decrypt
    python-{docopt,pycryptodome}
    # for update_payload_extractor
    python2-argparse
)
options=('!strip' 'libtool' 'staticlibs' '!zipman' '!purge')
source=(
    git+"$url"
    git+https://github.com/cyxx/extract_android_ota_payload
    git+https://github.com/bkerler/oppo_ozip_decrypt
    git+https://github.com/erfanoabdi/update_payload_extractor
    fw-extractor.sh
)
b2sums=(
    SKIP
    SKIP
    SKIP
    SKIP
    fac57da161e40c621b6698b8e27836e3fcb91a57ca309e4f43c167255889a9aed3b297d2c573394c4fffa11ca5038ee54888df1bd383a88eb14cd51189e35b5f
)

pkgver() {
    cd "$srcdir"/Firmware_extractor

    printf '%s.%s' \
        "$(git rev-list --count HEAD | sed 's/\(^[0-9]*\)/r\1/')" \
        "$(git rev-parse --short HEAD)"
}

prepare() {
    # don't pull external tools everytime we execute the script, we package them here
    sed -i '/\$toolsdir\/extract_android_ota_payload/,+17d' "$srcdir"/Firmware_extractor/extractor.sh
}

package() {
    local FILES i

    # main files
    cd "$srcdir"/Firmware_extractor
    install -Dt "$pkgdir"/opt/fw-extractor extractor.sh
    install -Dt "$pkgdir"/opt/fw-extractor/tools tools/{sdat2img.py,splituapp}
    mapfile -t FILES < <(find tools/Linux/bin -maxdepth 1 -type f)
    install -Dt "$pkgdir"/opt/fw-extractor/tools/Linux/bin "${FILES[@]}"
    cp -r tools/Linux/bin/keyfiles "$pkgdir"/opt/fw-extractor/tools/Linux/bin
    cp -r tools/kdztools "$pkgdir"/opt/fw-extractor/tools

    # extract_android_ota_payload
    cd "$srcdir"/extract_android_ota_payload
    install -Dt "$pkgdir"/opt/fw-extractor/tools/extract_android_ota_payload ./*.py

    # oppo_ozip_decrypt
    cd "$srcdir"/oppo_ozip_decrypt
    install -Dt "$pkgdir"/opt/fw-extractor/tools/oppo_ozip_decrypt ozipdecrypt.py

    # update_payload_extractor
    cd "$srcdir"/update_payload_extractor
    install -Dt "$pkgdir"/opt/fw-extractor/tools/update_payload_extractor extract.py
    for i in tools update_payload; do
        cp -r $i "$pkgdir"/opt/fw-extractor/tools/update_payload_extractor
    done

    # install extractor.sh wrapper
    install -D "$srcdir"/fw-extractor.sh "$pkgdir"/usr/bin/fw-extractor
    # copy license file
    install -Dt "$pkgdir"/usr/share/licenses/$pkgname "$srcdir"/Firmware_extractor/LICENSE
}
