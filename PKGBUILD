# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154,SC2164

# Maintainer: Albert I <kras@raphielgang.org>

_pkgname=android-firmware-extractor
pkgname=$_pkgname-git
pkgver=r146.0b82502
pkgrel=1
pkgdesc='Collection of tools to extract images from stock Android firmware (git version)'
arch=('x86_64')
url='https://dumps.tadiphone.dev/dumps'
## License concerns
# GPL3: main firmware extractor repository
# MIT: oppo_ozip_decrypt script
# Apache: update_payload tools from AOSP
# custom: any other, unlicensed files
license=('GPL3' 'MIT' 'Apache' 'custom')
depends=(
    # as used by extractor.sh
    'brotli' 'lz4' 'p7zip' 'tar' 'util-linux'
    # for python scripts, although only oppo_ozip_decrypt says it needs 3.6+
    # twrpdtgen is listed as deps in readme, needs 3.9+, but nowhere in script uses it currently
    'python>=3.6.0' 'python2>=2.7' 'python-argparse'
    # for extract_android_ota_payload
    'python-protobuf>=3.6.0'
    # for oppo_ozip_decrypt
    'python-pycryptodome'
    # for undz.py script within main repository
    'python-zstandard'
)
optdepends=(
    # should be on depends and not optdepends, but Arch Linux is sunsetting python2
    'python2-argparse: for update_payload_extractor and unkdz scripts'
)
provides=("$_pkgname")
conflicts=("$_pkgname")
options=('!strip' 'libtool' 'staticlibs' '!zipman' '!purge')
source=(
    'git+https://github.com/AndroidDumps/Firmware_extractor.git'
    'git+https://github.com/cyxx/extract_android_ota_payload.git'
    'git+https://github.com/bkerler/oppo_ozip_decrypt.git'
    'git+https://github.com/erfanoabdi/update_payload_extractor.git'
    'fw-extractor.sh' # wraps around extractor.sh
    'fw-patcher.sh'   # wraps around patcher.sh
)
b2sums=(
    'SKIP'
    'SKIP'
    'SKIP'
    'SKIP'
    'fac57da161e40c621b6698b8e27836e3fcb91a57ca309e4f43c167255889a9aed3b297d2c573394c4fffa11ca5038ee54888df1bd383a88eb14cd51189e35b5f'
    'd60a3219c83438fca464d294e8a5a3f807e825fd41019aefde9e515ca79550ec295d3669f1ffc4cdad45c1b3932d3c8dfc646d6217531efeb767967d0b666a2a'
)

pkgver() {
    cd "$srcdir/Firmware_extractor"
    printf '%s.%s' \
        "$(git rev-list --count HEAD | sed 's/\(^[0-9]*\)/r\1/')" \
        "$(git rev-parse --short HEAD)"
}

prepare() {
    cd "$srcdir/Firmware_extractor"
    # don't pull external tools everytime we execute the script, we package them here
    sed -i '/\$toolsdir\/extract_android_ota_payload/,+15d' extractor.sh
    sed -i '/\"\$TOOLSDIR\/update_payload_extractor\"/,+4d' patcher.sh
}

package() {
    local FILES i

    # main files
    cd "$srcdir/Firmware_extractor"
    install -Dt "$pkgdir/opt/fw-extractor" {extractor,patcher}.sh
    install -Dt "$pkgdir/opt/fw-extractor/tools" tools/{sdat2img.py,splituapp}
    mapfile -t FILES < <(find tools/Linux/bin -maxdepth 1 -type f)
    install -Dt "$pkgdir/opt/fw-extractor/tools/Linux/bin" "${FILES[@]}"
    cp -r tools/Linux/bin/keyfiles "$pkgdir/opt/fw-extractor/tools/Linux/bin"
    cp -r tools/kdztools "$pkgdir/opt/fw-extractor/tools"

    # extract_android_ota_payload
    cd "$srcdir/extract_android_ota_payload"
    install -Dt "$pkgdir/opt/fw-extractor/tools/extract_android_ota_payload" ./*.py

    # oppo_ozip_decrypt
    cd "$srcdir/oppo_ozip_decrypt"
    install -Dt "$pkgdir/opt/fw-extractor/tools/oppo_ozip_decrypt" ozipdecrypt.py

    # update_payload_extractor
    cd "$srcdir/update_payload_extractor"
    install -Dt "$pkgdir/opt/fw-extractor/tools/update_payload_extractor" extract.py
    for i in tools update_payload; do
        cp -r "$i" "$pkgdir/opt/fw-extractor/tools/update_payload_extractor"
    done

    # install script wrappers
    install -D "$srcdir/fw-extractor.sh" "$pkgdir/usr/bin/fw-extractor"
    install -D "$srcdir/fw-patcher.sh" "$pkgdir/usr/bin/fw-patcher"

    # copy license file
    cd "$srcdir/Firmware_extractor"
    install -Dt "$pkgdir/usr/share/licenses/$pkgname" LICENSE
}
