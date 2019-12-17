# Based on PKGBUILD created for Arch Linux by:
# Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>

# Author: Albert I <kras@raphielgang.org>

pkgbase=linux-vk
pkgver=5.2.1
pkgrel=1
pkgdesc='Linux-VK'
arch=(x86_64)
url="https://github.com/krasCGQ/linux-vk"
license=(GPL2)
makedepends=(bc kmod libelf git)
options=('!strip')
_srcname=${pkgbase/-*}
source=(
  "$_srcname::git+$url"
  config.compilers # configuration for custom compiler paths
  sign_modules.sh  # script to sign out-of-tree kernel modules
  x509.genkey      # preset for generating module signing key
)
sha384sums=('SKIP'
            'SKIP'
            'd5dcc15254f4ff2ac545aabf6971bd19389f89d18130bed08177721fc799ebc7d39d395366743e0d93202fc29afe7a6d'
            '4399cc1b697b95bb92e0c10e7dbd5fa6c52612aafeb8d6fb829d20bbc341fc1a6f6ef8a0c57a9509ca9f319eb34c80de'
)

_kernelname=${pkgbase#linux-}
_codename=TheElegant
_defconfig=$_srcname/arch/x86/configs/${_kernelname}_defconfig

# custom binutils, clang and gcc paths
binutils_path="$(grep binutils config.compilers 2> /dev/null | cut -d '=' -f 2)"
clang_path="$(grep clang config.compilers 2> /dev/null | cut -d '=' -f 2)"
gcc_path="$(grep gcc config.compilers 2> /dev/null | cut -d '=' -f 2)"

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase

prepare() {
  local hash

  if [ -n "$(grep MODULE_SIG=y $_defconfig)" ]; then
    msg2 "Module signing status: enabled"

    # parse hash used to sign modules from defconfig
    hash=$(grep SIG_SHA $_defconfig | sed -e s/.*._// -e s/=y//)
    # defaults to SHA1 if not found in defconfig
    [ -z "$hash" ] && hash=SHA1
    msg2 "Module signature hash algorithm used: ${hash,,}"

    if [ ! -f "../${pkgbase}.pem" ]; then
      msg2 "Generating an $hash public/private key pair..."
      openssl req -new -nodes -utf8 -${hash,,} -days 3650 -batch -x509 \
        -config x509.genkey -outform PEM -out ../${pkgbase}.pem \
        -keyout ../${pkgbase}.pem 2> /dev/null
    fi

    msg2 "Copying key pair into source folder..."
    cp -f ../${pkgbase}.pem $_srcname/${pkgbase}.pem
  else
    msg2 "Module signing status: disabled"
  fi

  cd $_srcname

  msg2 "Setting version..."
  scripts/setlocalversion --save-scmversion
  echo "-$pkgrel" > localversion.10-pkgrel
  echo "-${_kernelname^^}.$_codename" > localversion.20-pkgname

  msg2 "Generating defconfig..."
  make -s ${_kernelname}_defconfig

  make -s kernelrelease > version
  msg2 "Prepared %s version %s" "$pkgbase" "$(<version)"
}

build() {
  # mark variables as local
  local amdgpu_dc_enabled CC cc_temp compiler CROSS_COMPILE

  # enabled features determine how kernel and package will be treated
  # DRM_AMD_DC defaults to true in Kconfig
  amdgpu_dc_enabled=$(test -n "$(grep DRM_AMD_DC $_defconfig)" && echo false || echo true)
  msg2 "AMDGPU DC enabled: $amdgpu_dc_enabled"
  export r8168_enabled=$(test -n "$(grep R8168 $_defconfig)" && echo true || echo false)
  msg2 "R8168 enabled: $r8168_enabled"

  if $amdgpu_dc_enabled; then
    warning "Incompatible configuration detected! NOT using Clang."
  else
    # custom clang
    if find "$clang_path/bin/clang" &> /dev/null; then
      msg2 "Custom Clang detected! Building with Clang..."
      export PATH="$clang_path/bin:$PATH"
      export LD_LIBRARY_PATH="$clang_path/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
      clang_exist=true
      clang_custom=true
    # clang installed on system
    elif which clang &> /dev/null; then
      msg2 "Clang detected! Building with Clang..."
      clang_exist=true
    fi
    if [ -n "$clang_exist" ]; then
      # clang < 9 doesn't support asm goto
      [ "$(clang -dumpversion | cut -d '.' -f 1)" -lt 9 ] && \
        error "Detected Clang doesn't support asm goto."

      CC=clang
    fi
  fi

  # custom gcc if exist
  gcc_path="$(find "$gcc_path/bin" -name '*gcc' 2> /dev/null | sort -n | head -1)"
  if [ -n "$gcc_path" ]; then
    msg2 "Custom GCC detected!"
    export PATH="$(dirname "$gcc_path"):$PATH"
    # the custom gcc has prefix
    cc_temp="$(basename "$gcc_path" | sed -e s/gcc//)"
    [ -n "$cc_temp" ] && CROSS_COMPILE="$cc_temp"
  fi

  if [ -n "$clang_exist" ]; then
    if [ -n "$clang_custom" ] && find "$binutils_path/bin/ld" &> /dev/null; then
      export PATH="$binutils_path/bin:$PATH"
      # required for LTO
      export LD_LIBRARY_PATH="$binutils_path/lib:${LD_LIBRARY_PATH:+:LD_LIBRARY_PATH}"
      binutils_exist=true
    fi
    # custom compiler string for clang
    # todo: gcc?
    # from github.com/nathanchance/scripts, slightly edited
    clang_version="$($CC --version | head -1 | cut -d \( -f 1 | sed 's/[[:space:]]*$//')"
    binutils_version="$(${cc_temp}ld --version | head -1 | cut -d ' ' -f 3-5 | sed -e 's/[\(|\)]//g')"
    msg2 "Using $clang_version, $binutils_version..."
  fi

  # set CROSS_COMPILE and CC if declared via compiler array
  if [ -n "$CROSS_COMPILE" ] && [ -z "$binutils_exist" ]; then
    compiler+=( "CROSS_COMPILE=$CROSS_COMPILE" "LD=${CROSS_COMPILE}ld.gold" )
  else
    compiler+=( "LD=ld.gold" )
  fi
  [ -n "$CC" ] && compiler+=( "CC=$CC" )
  # this is harmless on unaffected compilers
  [ -n "$clang_exist" ] && compiler+=( "CLANG_TRIPLE=$($CC -dumpmachine)" )

  cd $_srcname

  msg2 "Applying compiler sanitization features..."
  if [ -n "$clang_exist" ]; then
    # apply init stack sanitizer
    scripts/config -e INIT_STACK_ALL
  else
    # apply certain sanitizer features
    scripts/config -e GCC_PLUGIN_STRUCTLEAK_BYREF_ALL \
                   -d GCC_PLUGIN_STRUCTLEAK_VERBOSE \
                   -e GCC_PLUGIN_STACKLEAK \
                   --set-val STACKLEAK_TRACK_MIN_SIZE 100 \
                   -d STACKLEAK_METRICS \
                   -d STACKLEAK_RUNTIME_DISABLE
  fi
  # enable JUMP_LABEL for supported toolchains
  # we need to keep it disabled for Clang as asm goto support is in early stage
  [ -z "$clang_exist" ] && scripts/config -e JUMP_LABEL -d STATIC_KEYS_SELFTEST
  # refresh the config just in case
  make "${compiler[@]}" oldconfig

  msg2 "Building kernel and modules..."
  make "${compiler[@]}" bzImage modules > /dev/null
  export image_name=$(make "${compiler[@]}" -s image_name)
}

_package() {
  pkgdesc="The $pkgdesc kernel and modules"
  depends=(coreutils kmod initramfs)
  optdepends=('crda: to set the correct wireless channels of your country'
              'linux-firmware: firmware images needed for some devices')
  # conflicts with r8168-dkms
  $r8168_enabled && conflicts+=(r8168-dkms)

  # copy signing_key.x509 to PKGBUILD location
  cp -f ${_srcname}/certs/signing_key.x509 ../linux-vk.x509

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
  make INSTALL_MOD_PATH="$pkgdir/usr" modules_install > /dev/null

  # remove build and source links
  rm "$modulesdir"/{source,build}

  msg2 "Fixing permissions..."
  chmod -Rc u=rwX,go=rX "$pkgdir"
}

_package-headers() {
  pkgdesc="Header and scripts for building modules for the $pkgdesc kernel"

  cd $_srcname

  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  msg2 "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux
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
