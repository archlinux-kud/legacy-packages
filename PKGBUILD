# Based on PKGBUILD created for Arch Linux by:
# Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>

# Author: Albert I <kras@raphielgang.org>

pkgbase=linux-moesyndrome
pkgver=5.5.13
pkgrel=1
pkgdesc='MoeSyndrome'
arch=(x86_64)
url="https://github.com/krasCGQ/moesyndrome-kernel"
license=(GPL2)
makedepends=(bc kmod libelf git)
options=('!buildflags' '!strip')
_srcname=${pkgbase/-*}
source=(
  "$_srcname::git+$url#tag=$pkgver-$pkgrel"
  config.compilers # configuration for custom compiler paths
  sign_modules.sh  # script to sign out-of-tree kernel modules
  x509.genkey      # preset for generating module signing key
)
sha384sums=('SKIP'
            'SKIP' # we modify this, just don't
            'ff8a65f1b504d2754152ec8f69e497607c463da311001d040b5453e02d6f6f2312678ff5edc100481839e7ac2d74c4d3'
            '193dc59cee4e6f660b000ff448b5decc6325a449fa7cba00945849860498db0eca1070928eccc8fd624c427a086f14da'
)

# import custom clang and gcc properties
source config.compilers
# add clang, lld and llvm 9+ into build dependencies if requested
$use_clang && makedepends+=( 'clang>=9.0.0' 'lld>=9.0.0' 'llvm>=9.0.0' )

_defconfig=$_srcname/arch/x86/configs/archlinux_defconfig

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
    msg2 "Module signature hash algorithm used: ${hash,,}"

    if [ ! -f "../$pkgbase.pem" ]; then
      msg2 "Generating an $hash public/private key pair..."
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

  msg2 "Setting version..."
  scripts/setlocalversion --save-scmversion
  echo "-$pkgrel" > localversion.98-pkgrel

  msg2 "Generating config..."
  make -s "$(basename $_defconfig)"

  make -s kernelrelease > version
  msg2 "Prepared %s version %s" "$pkgbase" "$(<version)"
}

build() {
  # mark variables as local
  local CC cc_temp clang_custom clang_version compiler CROSS_COMPILE gcc_version

  # custom clang
  if [ -n "$clang_path" ] && find "$clang_path"/bin/clang &> /dev/null; then
    export PATH="$clang_path/bin:$PATH"
    # required for LTO
    export LD_LIBRARY_PATH="$clang_path/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export clang_exist=true
    clang_custom=true

  # clang installed on system
  elif $use_clang && which clang &> /dev/null; then
    export clang_exist=true

  # custom gcc if exist, otherwise fallback
  elif [ -n "$gcc_path" ]; then
    export PATH="$gcc_path/bin:$PATH"
    # required for LTO
    export LD_LIBRARY_PATH="$gcc_path/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    # check whether the custom gcc has prefix
    cc_temp="$(basename "$(find "$gcc_path/bin/*gcc" 2> /dev/null)" | sed -e 's/gcc//')"
    # bail out if prefix is x86_64-pc-linux-gnu-; it's for host
    if [ -n "$cc_temp" ] && [ "$cc_temp" != "x86_64-pc-linux-gnu-" ]; then
      CROSS_COMPILE="$cc_temp"
    fi
    msg2 "Custom GCC detected!"
  fi

  if [ -n "$clang_exist" ]; then
    # clang < 9 doesn't support asm goto
    [ "$(clang -dumpversion | cut -d '.' -f 1)" -lt 9 ] && \
      error "Detected Clang doesn't support asm goto."

    msg2 "${clang_custom:+Custom }Clang detected!"
    CC=clang

    # custom compiler string
    # from github.com/nathanchance/scripts, slightly edited
    clang_version="$($CC --version | head -1 | cut -d \( -f 1 | sed 's/[[:space:]]*$//')"
    msg2 "Using $clang_version..."

    # go full LLVM!
    compiler=( "AS=llvm-as" "LD=ld.lld" "CC=$CC" "AR=llvm-ar" "NM=llvm-nm"
                "STRIP=llvm-strip" "OBJCOPY=llvm-objcopy" "OBJDUMP=llvm-objdump"
                "OBJSIZE=llvm-objsize" READELF="llvm-readelf" )
  else
    # custom compiler string
    gcc_version="$(${CROSS_COMPILE}gcc --version | head -1 | sed -e 's/(.*.)[[:space:]]//')"
    msg2 "Using $gcc_version..."

    # set cross compile prefix
    [ -n "$CROSS_COMPILE" ] && compiler=( "CROSS_COMPILE=$CROSS_COMPILE" )
  fi

  cd $_srcname

  # regenerate config with selected compiler
  msg2 "Regenerating config..."
  make -s "${compiler[@]}" "$(basename $_defconfig)"

  msg2 "Applying compiler-specific features..."
  # INIT_STACK_NONE is common for both compilers
  scripts/config -d INIT_STACK_NONE
  if [ -n "$clang_exist" ]; then
    # unconditionally apply polly optimizations
    # (requires compiler to have the feature enabled explicitly)
    scripts/config -e LLVM_POLLY
    # apply init stack sanitizer
    scripts/config -e INIT_STACK_ALL
  else
    scripts/config -e GCC_PLUGINS
    # apply recommended KSPP settings for GCC plugins
    # https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings#GCC_plugins
    scripts/config -d GCC_PLUGIN_CYC_COMPLEXITY \
                   -e GCC_PLUGIN_LATENT_ENTROPY \
                   -e GCC_PLUGIN_RANDSTRUCT \
                   --enable-after GCC_PLUGIN_RANDSTRUCT GCC_PLUGIN_RANDSTRUCT_PERFORMANCE \
                   -e GCC_PLUGIN_STRUCTLEAK_BYREF_ALL \
                   --disable-after GCC_PLUGIN_STRUCTLEAK_BYREF_ALL GCC_PLUGIN_STRUCTLEAK_VERBOSE
    # apply sanitizer features enabled by Arch Linux
    scripts/config -e GCC_PLUGIN_STACKLEAK \
                   --set-val STACKLEAK_TRACK_MIN_SIZE 100 \
                   --disable-after STACKLEAK_TRACK_MIN_SIZE STACKLEAK_METRICS \
                   --disable-after STACKLEAK_METRICS STACKLEAK_RUNTIME_DISABLE
  fi

  # https://git.kernel.org/torvalds/c/0077aaaeeb69b5dcfe15a398e38d71bf28c9505d
  [ -z "$clang_exist" ] && scripts/config -m REGULATOR_DA903X
  # use -O3 for Clang if without Apple SMC
  # Apple SMC doesn't build on -O3 with Clang due to __bad_udelay trap
  msg2 "Apple SMC included in build: $with_applesmc"
  if [ -n "$clang_exist" ] && ! $with_applesmc; then
    scripts/config -d CC_OPTIMIZE_FOR_PERFORMANCE \
                   -e CC_OPTIMIZE_FOR_PERFORMANCE_O3
  else
    scripts/config -m SENSORS_APPLESMC
  fi
  # refresh the config just in case
  make -s "${compiler[@]}" oldconfig

  # export timestamp earlier before build
  KBUILD_BUILD_TIMESTAMP="$(date)"
  export KBUILD_BUILD_TIMESTAMP

  msg2 "Building kernel and modules..."
  make -s "${compiler[@]}" bzImage modules
  export image_name=$(make -s "${compiler[@]}" image_name)

  # copy signing_key.x509 to PKGBUILD location
  cp -f certs/signing_key.x509 ../../$pkgbase.x509
}

_package() {
  pkgdesc="$pkgdesc kernel and modules"
  depends=(coreutils kmod initramfs)
  optdepends=('crda: to set the correct wireless channels of your country'
              'linux-firmware: firmware images needed for some devices')
  provides=('WIREGUARD-MODULE')

  cd $_srcname

  local kernver="$(<version)"
  local modulesdir="$pkgdir/usr/lib/modules/$kernver"

  msg2 "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$image_name" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  msg2 "Installing modules..."
  make -s INSTALL_MOD_PATH="$pkgdir/usr" modules_install

  # remove build and source links
  rm "$modulesdir"/{source,build}

  msg2 "Fixing permissions..."
  chmod -Rc u=rwX,go=rX "$pkgdir"
}

_package-headers() {
  pkgdesc="Header and scripts for building modules for $pkgdesc kernel"
  [ -n "$clang_exist" ] && depends=( "clang>=9.0.0" "lld>=9.0.0" "llvm>=9.0.0" )

  cd $_srcname

  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  msg2 "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts

  # conditionally patch Makefile to build external modules with Clang
  if [ -n "$clang_exist" ]; then
    for i in as ar nm strip objcopy objdump size; do
      sed -i s/'$(CROSS_COMPILE)'$i/llvm-$i/ "$builddir"/Makefile
    done
    sed -i 's/$(CROSS_COMPILE)ld/ld.lld/' "$builddir"/Makefile
    sed -i 's/$(CROSS_COMPILE)gcc/clang/' "$builddir"/Makefile
    # until arch clang has polly support, hardcode this
    sed -i 's/CONFIG_LLVM_POLLY/0/' "$builddir"/Makefile
  fi

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
        strip -v $STRIP_SHARED "$file" ;;
      application/x-archive\;*)        # Libraries (.a)
        strip -v $STRIP_STATIC "$file" ;;
      application/x-executable\;*)     # Binaries
        strip -v $STRIP_BINARIES "$file" ;;
      application/x-pie-executable\;*) # Relocatable binaries
        strip -v $STRIP_SHARED "$file" ;;
    esac
  done < <(find "$builddir" -type f -perm -u+x ! -name vmlinux)

  msg2 "Adding symlink..."
  mkdir -p "$pkgdir/usr/src"
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase"

  msg2 "Fixing permissions..."
  chmod -Rc u=rwX,go=rX "$pkgdir"
}

pkgname=("$pkgbase" "$pkgbase-headers")
for _p in "${pkgname[@]}"; do
  eval "package_$_p() {
    $(declare -f "_package${_p#$pkgbase}")
    _package${_p#$pkgbase}
  }"
done

# vim:set ts=8 sts=2 sw=2 et:
