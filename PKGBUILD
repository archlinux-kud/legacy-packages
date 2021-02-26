# shellcheck shell=bash
# shellcheck disable=SC2034,SC2164

# Based on PKGBUILD created for Arch Linux by:
# Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>

# Author: Albert I <kras@raphielgang.org>

pkgbase=linux-moesyndrome
pkgver=5.10.18~ms21
pkgrel=1
pkgdesc='MoeSyndrome Kernel (LTS)'
arch=(x86_64)
url='https://github.com/krasCGQ/moesyndrome-kernel'
license=(GPL2)
clang_deps=('clang>=11.0.0' 'lld>=11.0.0' 'llvm>=11.0.0')
makedepends=(bc cpio git gzip kmod libelf lz4 pahole perl "${clang_deps[@]}")
options=('!buildflags' '!strip')
_srcname=${pkgbase/-*/}
source=(
    "$_srcname::git+$url?signed#tag=${pkgver/\~/-}"
    x509.genkey # preset for generating module signing key
)
validpgpkeys=(4D4209B115B5643C3E753A9317E9D95B6620AF67)
b2sums=(
    SKIP
    835cf07cf8d45e349e6c683306d680b976b8add6c21c6cb0ec4bc380521e8b0f83386ce5dae7942126ef389f72ee6d73c914cc98c167bdb580b46cd838a94f8d
)
_defconfig=arch/x86/configs/archlinux_defconfig

# Use `--strip-all-gnu` for llvm-strip to restore GNU strip behavior
STRIP_BINARIES=--strip-all-gnu

# determines how package will be treated
WITH_NTFS3=$(grep -q NTFS3 "$_srcname/$_defconfig" && echo true || echo false)
WITH_R8168=$(grep -q R8168 "$_srcname/$_defconfig" && echo true || echo false)

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=${pkgbase#linux-}

prepare() {
    local HASH
    cd $_srcname

    HASH=$(grep -q 'MODULE_SIG is not set' "$_defconfig" && echo false || echo true)
    msg2 'Module signing status: %s' "$HASH"
    if $HASH; then
        # parse hash used to sign modules from defconfig
        HASH=$(grep SIG_SHA "$_defconfig" | sed -e s/.*._// -e s/=y//)
        # defaults to SHA1 if not found in defconfig
        [ -z "$HASH" ] && hash=SHA1
        msg2 'Module signature hash algorithm used: %s' "${HASH,,}"

        if [ ! -f certs/signing_key.pem ]; then
            msg2 'Generating an %s public/private key pair...' "$HASH"
            openssl req -new -nodes -utf8 -${HASH,,} -days 3650 -batch -x509 \
                -config ../x509.genkey -outform PEM -out certs/signing_key.pem \
                -keyout certs/signing_key.pem 2>/dev/null
        fi
    fi

    # necessary for both kernel building and DKMS
    # with this, LLVM=1 and LLVM_IAS=1 on make command are no longer required
    msg2 'Patching Makefile...'
    # shellcheck disable=SC2016
    sed -i 's/($(LLVM),)/($(LLVM),0)/g;s/ifneq ($(LLVM_IAS),1)/ifeq ($(LLVM_IAS),0)/g' Makefile
    # shellcheck disable=SC2016
    sed -i 's/($(LLVM),)/($(LLVM),0)/' tools/objtool/Makefile

    msg2 'Setting version...'
    scripts/setlocalversion --save-scmversion

    msg2 'Generating config...'
    make -s "$(basename "$_defconfig")"

    make -s kernelrelease >version
    msg2 'Prepared %s version %s' "$pkgbase" "$(<version)"
}

build() {
    cd $_srcname

    # whether configuration ships NTFS3 and/or r8168 or not at all
    msg2 'Paragon NTFS3 included in build: %s' "$WITH_NTFS3"
    msg2 'Realtek RTL8168 included in build: %s' "$WITH_R8168"

    # export timestamp earlier before build
    KBUILD_BUILD_TIMESTAMP=$(date)
    export KBUILD_BUILD_TIMESTAMP

    msg2 'Building kernel and modules...'
    make -s bzImage modules
}

_package() {
    pkgdesc="$pkgdesc - kernel and modules"
    depends=(coreutils kmod initramfs)
    optdepends=(
        'crda: to set the correct wireless channels of your country'
        'linux-firmware: firmware images needed for some devices'
    )
    provides=("$pkgbase=$pkgver" VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE)
    # make it conflict with dkms version
    $WITH_NTFS3 && conflicts+=(ntfs3-dkms)
    $WITH_R8168 && conflicts+=(r8168-dkms)

    local modulesdir
    cd $_srcname

    # shellcheck disable=SC2154
    modulesdir="$pkgdir"/usr/lib/modules/"$(<version)"

    msg2 'Installing boot image...'
    # systemd expects to find the kernel here to allow hibernation
    # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
    install -Dm644 "$(make -s image_name)" "$modulesdir"/vmlinuz

    # Used by mkinitcpio to name the kernel
    echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir"/pkgbase

    msg2 'Installing modules...'
    make -s INSTALL_MOD_PATH="$pkgdir"/usr INSTALL_MOD_STRIP=1 modules_install

    # remove build and source links
    rm "$modulesdir"/{source,build}
}

_package-headers() {
    pkgdesc="Header and scripts for building modules for $pkgdesc"
    depends=("${clang_deps[@]}")
    provides=("$pkgbase-headers=$pkgver")

    local arch builddir file
    cd $_srcname

    msg2 'Installing build files...'
    builddir="$pkgdir"/usr/lib/modules/"$(<version)"/build
    install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
        localversion version vmlinux
    install -Dt "$builddir"/kernel -m644 kernel/Makefile
    install -Dt "$builddir"/arch/x86 -m644 arch/x86/Makefile
    cp -t "$builddir" -a scripts

    # add objtool for external module building and enabled VALIDATION_STACK option
    install -Dt "$builddir"/tools/objtool tools/objtool/objtool

    # add xfs and shmem for aufs building
    mkdir -p "$builddir"/{fs/xfs,mm}

    msg2 'Installing headers...'
    cp -t "$builddir" -a include
    cp -t "$builddir"/arch/x86 -a arch/x86/include
    install -Dt "$builddir"/arch/x86/kernel -m644 arch/x86/kernel/asm-offsets.s

    install -Dt "$builddir"/drivers/md -m644 drivers/md/*.h
    install -Dt "$builddir"/net/mac80211 -m644 net/mac80211/*.h

    # http://bugs.archlinux.org/task/13146
    install -Dt "$builddir"/drivers/media/i2c -m644 drivers/media/i2c/msp3400-driver.h

    # http://bugs.archlinux.org/task/20402
    install -Dt "$builddir"/drivers/media/usb/dvb-usb -m644 drivers/media/usb/dvb-usb/*.h
    install -Dt "$builddir"/drivers/media/dvb-frontends -m644 drivers/media/dvb-frontends/*.h
    install -Dt "$builddir"/drivers/media/tuners -m644 drivers/media/tuners/*.h

    install -Dt "$builddir"/certs -m644 certs/signing_key.{pem,x509}

    msg2 'Installing KConfig files...'
    find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir"/{} \;

    msg2 'Removing unneeded architectures...'
    for arch in "$builddir"/arch/*/; do
        [[ $arch == */x86/ ]] && continue
        rm -r "$arch"
    done

    msg2 'Removing documentation...'
    rm -r "$builddir"/Documentation

    msg2 'Removing broken symlinks...'
    find -L "$builddir" -type l -delete

    msg2 'Removing loose objects...'
    find "$builddir" -type f -name '*.o' -delete

    msg2 'Stripping build tools...'
    while read -rd '' file; do
        case "$(file -bi "$file")" in
        application/x-sharedlib\;*) # Libraries (.so)
            llvm-strip "$STRIP_SHARED" "$file" ;;
        application/x-archive\;*) # Libraries (.a)
            llvm-strip "$STRIP_STATIC" "$file" ;;
        application/x-executable\;*) # Binaries
            llvm-strip $STRIP_BINARIES "$file" ;;
        application/x-pie-executable\;*) # Relocatable binaries
            llvm-strip "$STRIP_SHARED" "$file" ;;
        esac
    done < <(find "$builddir" -type f -perm -u+x ! -name vmlinux)

    msg2 'Stripping vmlinux...'
    llvm-strip "$STRIP_STATIC" "$builddir/vmlinux"

    msg2 'Adding symlink...'
    mkdir -p "$pkgdir"/usr/src
    ln -sr "$builddir" "$pkgdir"/usr/src/"$pkgbase"
}

pkgname=("$pkgbase" "$pkgbase-headers")
for _p in "${pkgname[@]}"; do
    eval "package_$_p() {
        $(declare -f "_package${_p#$pkgbase}")
        _package${_p#$pkgbase}
    }"
done

# vim:set ts=8 sts=2 sw=2 et:
