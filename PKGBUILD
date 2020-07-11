# Based on PKGBUILD created for Arch Linux by:
# Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>

# Author: Albert I <kras@raphielgang.org>

pkgbase=linux-moesyndrome
pkgver=5.7.8~ms5
pkgrel=1
pkgdesc='MoeSyndrome Kernel'
arch=(x86_64)
url="https://github.com/krasCGQ/moesyndrome-kernel"
license=(GPL2)
makedepends=('bc' 'git' 'kmod' 'libelf' 'pahole'
             'clang>=10.0.0' 'lld>=10.0.0' 'llvm>=10.0.0')
options=('!buildflags' '!strip')
_srcname=${pkgbase/-*}
source=(
  "$_srcname::git+$url?signed#tag=${pkgver/\~/-}"
  x509.genkey # preset for generating module signing key
)
validpgpkeys=('73EC669FD2695442A3568EDA25A6FD691FA2918B'
              '4D4209B115B5643C3E753A9317E9D95B6620AF67')
sha384sums=('SKIP'
            '193dc59cee4e6f660b000ff448b5decc6325a449fa7cba00945849860498db0eca1070928eccc8fd624c427a086f14da')
_defconfig=$_srcname/arch/x86/configs/archlinux_defconfig

# import external properties
source config.external
# determines how package will be treated
with_r8168=$(test -n "$(grep R8168 $_defconfig)" && echo true || echo false)

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=${pkgbase#linux-}

prepare() {
  local hash

  if [ -z "$(grep "MODULE_SIG is not set" $_defconfig)" ]; then
    msg2 "Module signing status: enabled"

    # parse hash used to sign modules from defconfig
    hash=$(grep SIG_SHA $_defconfig | sed -e s/.*._// -e s/=y//)
    # defaults to SHA1 if not found in defconfig
    [ -z "$hash" ] && hash=SHA1
    msg2 "Module signature hash algorithm used: %s" "${hash,,}"

    if [ ! -f "../$pkgbase.pem" ]; then
      msg2 "Generating an %s public/private key pair..." "$hash"
      openssl req -new -nodes -utf8 -${hash,,} -days 3650 -batch -x509 \
        -config x509.genkey -outform PEM -out ../${pkgbase}.pem \
        -keyout ../$pkgbase.pem 2> /dev/null
    fi

    msg2 "Copying key pair into source folder..."
    cp -f ../$pkgbase.pem $_srcname/certs/signing_key.pem
  else
    msg2 "Module signing status: disabled"
  fi

  cd $_srcname

  # necessary for both kernel building and DKMS
  # with this, LLVM=1 on make command is no longer required
  msg2 "Patching Makefile..."
  sed -i 's/($(LLVM),)/($(LLVM),0)/g' Makefile
  sed -i 's/($(LLVM),)/($(LLVM),0)/' tools/objtool/Makefile

  msg2 "Setting version..."
  scripts/setlocalversion --save-scmversion

  msg2 "Generating config..."
  make -s "$(basename $_defconfig)"

  make -s kernelrelease > version
  msg2 "Prepared %s version %s" "$pkgbase" "$(<version)"
}

build() {
  # mark variables as local
  local clang_custom clang_version

  # custom compiler detection
  if [ -n "$compiler_path" ] && find "$compiler_path"/bin/clang &> /dev/null; then
    # clang < 9 doesn't support asm goto
    [ "$(clang -dumpversion | cut -d '.' -f 1)" -lt 10 ] && \
      error "Clang older than version 10 isn't supported!"

    export PATH="$compiler_path/bin:$PATH"
    # required for LTO
    export LD_LIBRARY_PATH="$compiler_path/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    clang_custom=true
    msg2 "Custom compiler detected!"
  fi

  # custom compiler string to be printed out
  # from github.com/nathanchance/scripts, slightly edited
  clang_version="$(clang --version | head -1 | cut -d \( -f 1 | sed 's/[[:space:]]*$//')"
  msg2 "Using %s..." "$clang_version"

  cd $_srcname

  # regenerate config with selected compiler
  msg2 "Regenerating config..."
  make -s "$(basename $_defconfig)"

  # whether configuration ships r8168 or not
  msg2 "Realtek RTL8168 included in build: %s" "$with_r8168"
  # use -O3 for Clang if without Apple SMC
  # Apple SMC doesn't build on -O3 with Clang due to __bad_udelay trap
  msg2 "Apple SMC included in build: %s" "$with_applesmc"
  $with_applesmc && scripts/config -d CC_OPTIMIZE_FOR_PERFORMANCE_O3 \
                                   -e CC_OPTIMIZE_FOR_PERFORMANCE \
                                   -m SENSORS_APPLESMC

  # refresh the config just in case
  make -s oldconfig

  # export timestamp earlier before build
  KBUILD_BUILD_TIMESTAMP="$(date)"
  export KBUILD_BUILD_TIMESTAMP

  msg2 "Building kernel and modules..."
  make -s bzImage modules

  # copy signing_key.x509 to PKGBUILD location
  cp -f certs/signing_key.x509 ../../$pkgbase.x509
}

_package() {
  pkgdesc="$pkgdesc - kernel and modules"
  depends=(coreutils kmod initramfs)
  optdepends=('crda: to set the correct wireless channels of your country'
              'linux-firmware: firmware images needed for some devices')
  provides=('VIRTUALBOX-GUEST-MODULES' 'WIREGUARD-MODULE')
  # make it conflict with dkms version
  $with_r8168 && conflicts+=(r8168-dkms)

  cd $_srcname

  local kernver="$(<version)"
  local modulesdir="$pkgdir/usr/lib/modules/$kernver"

  msg2 "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  msg2 "Installing modules..."
  make -s INSTALL_MOD_PATH="$pkgdir/usr" INSTALL_MOD_STRIP=1 modules_install

  # remove build and source links
  rm "$modulesdir"/{source,build}
}

_package-headers() {
  pkgdesc="Header and scripts for building modules for $pkgdesc"
  depends=('clang>=10.0.0' 'lld>=10.0.0' 'llvm>=10.0.0')

  cd $_srcname

  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  msg2 "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion version vmlinux
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts

  # add objtool for external module building and enabled VALIDATION_STACK option
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # add xfs and shmem for aufs building
  mkdir -p "$builddir"/{fs/xfs,mm}

  msg2 "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/x86" -a arch/x86/include
  install -Dt "$builddir/arch/x86/kernel" -m644 arch/x86/kernel/asm-offsets.s

  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h

  # http://bugs.archlinux.org/task/13146
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h

  # http://bugs.archlinux.org/task/20402
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h

  # until arch Clang has polly support, hardcode this
  sed -i '/LLVM_POLLY/d' "$builddir"/include/config/auto.conf
  sed -i 's/LLVM_POLLY 1/LLVM_POLLY 0/' "$builddir"/include/generated/autoconf.h

  msg2 "Installing KConfig files..."
  find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir/{}" \;

  msg2 "Removing unneeded architectures..."
  local arch
  for arch in "$builddir"/arch/*/; do
    [[ $arch = */x86/ ]] && continue
    rm -r "$arch"
  done

  msg2 "Removing documentation..."
  rm -r "$builddir/Documentation"

  msg2 "Removing broken symlinks..."
  find -L "$builddir" -type l -delete

  msg2 "Removing loose objects..."
  find "$builddir" -type f -name '*.o' -delete

  msg2 "Stripping build tools..."
  local file
  while read -rd '' file; do
    case "$(file -bi "$file")" in
      application/x-sharedlib\;*)      # Libraries (.so)
        llvm-strip $STRIP_SHARED "$file" ;;
      application/x-archive\;*)        # Libraries (.a)
        llvm-strip $STRIP_STATIC "$file" ;;
      application/x-executable\;*)     # Binaries
        llvm-strip $STRIP_BINARIES "$file" ;;
      application/x-pie-executable\;*) # Relocatable binaries
        llvm-strip $STRIP_SHARED "$file" ;;
    esac
  done < <(find "$builddir" -type f -perm -u+x ! -name vmlinux)

  msg2 "Stripping vmlinux..."
  llvm-strip $STRIP_STATIC "$builddir/vmlinux"

  msg2 "Adding symlink..."
  mkdir -p "$pkgdir/usr/src"
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase"
}

pkgname=("$pkgbase" "$pkgbase-headers")
for _p in "${pkgname[@]}"; do
  eval "package_$_p() {
    $(declare -f "_package${_p#$pkgbase}")
    _package${_p#$pkgbase}
  }"
done

# vim:set ts=8 sts=2 sw=2 et:
