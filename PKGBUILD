# Based on PKGBUILD created for Arch Linux by:
# Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>
# Tobias Powalowski <tpowa@archlinux.org>
# Thomas Baechler <thomas@archlinux.org>

# Author: Albert I <krascgq@outlook.co.id>

pkgbase=linux-vk
pkgver=4.20.7
pkgrel=1
arch=(x86_64)
url="https://github.com/krasCGQ/linux-vk"
license=(GPL2)
makedepends=(kmod inetutils bc libelf git)
options=('!strip')
_srcname=${pkgbase/-*}
source=(
  "$_srcname::git+$url"
  config          # the main kernel config file
  60-linux.hook   # pacman hook for depmod
  90-linux.hook   # pacman hook for initramfs regeneration
  linux.install   # standard config file for post (un)install
  linux.preset    # standard config file for mkinitcpio ramdisk
  sign_modules.sh # script to sign out-of-tree kernel modules
  x509.genkey     # preset for generating module signing key
)
sha384sums=('SKIP'
            '1ff1b69b296e202b864d4d9a7c4aab930f8db60bb61f7f5ff620893fff62ce7c8356f2b6105e4a63ebc27589e996c325'
            'f7c95513e185393a526043eb0f5ecf1f800840ab3b2ed223532bb9d40ddcce44c5fab5f4b528cfd2a89bf67ad764751d'
            '01a9570c0907fa9a11ee1c384248fdf9b83de4fc2fe65cbc53446d9711aee9b148faa29a2e6449ca1a9d7b7f4cbe6c7c'
            '5b9cfec7a4e1829bd89e32c5ac3aa4f983c77dffbdedde848d305068b70ae2fee51a9d9351c6b4cb917f556db0b0f622'
            'd11ffe6e88adbcf59ca02c9481af7f7897e494eddc2345cb08ae093bf48f32ef48932fcd85224e1bfaa3db42042a6afb'
            'SKIP'
            '4399cc1b697b95bb92e0c10e7dbd5fa6c52612aafeb8d6fb829d20bbc341fc1a6f6ef8a0c57a9509ca9f319eb34c80de')

_kernelname=${pkgbase#linux}
_codename=AtomicPeacock

prepare() {
  if [ ! -f "../${pkgbase}.pem" ]; then
    # We're using SHA-384 since it's invulnerable to length extension attacks
    msg2 "Generating an SHA-384 public/private key pair..."
    openssl req -new -nodes -utf8 -sha384 -days 3650 -batch -x509 \
      -config x509.genkey -outform PEM -out ../${pkgbase}.pem \
      -keyout ../${pkgbase}.pem 2> /dev/null
  fi

  msg2 "Copying key pair into source folder..."
  cp -f ../${pkgbase}.pem $_srcname/${pkgbase}.pem

  cd $_srcname

  msg2 "Setting version..."
  scripts/setlocalversion --save-scmversion
  echo "-$pkgrel" > localversion.10-pkgrel
  echo "${_kernelname^^}.$_codename" > localversion.20-pkgname

  msg2 "Setting config..."
  cp ../config .config
  make olddefconfig > /dev/null

  make -s kernelrelease > ../version
  sed -i "4s/.*/KERNVER=\"$(<../version)\"/" ../../sign_modules.sh
  msg2 "Prepared %s version %s" "$pkgbase" "$(<../version)"
}

build() {
  # mark variables as local
  local CC ccache_exist clang_exist clang_path compiler CROSS_COMPILE gcc_path

  # is ccache exist?
  ccache_exist="$(which ccache &> /dev/null && echo 1 || echo 0)"

  # custom clang and gcc paths
  clang_path="/opt/kud/clang-9.x/bin/clang"
  gcc_path="/opt/kud/x86_64-linux-gnu/bin/x86_64-linux-gnu-"

  # assuming clang doesn't exist
  clang_exist=0

  msg2 "NOT using Clang for now due to floating point issues with AMDGPU."
  if false; then
  # custom clang
  if [ "$(find ${clang_path} &> /dev/null; echo ${?})" == "0" ]; then
    msg2 "Custom built Clang detected! Building with Clang..."
    # use ccache if exist
    [ "${ccache_exist}" == "1" ] && CC+="ccache "
    CC+="${clang_path}"
    clang_exist=1
  # clang installed on system
  elif [ "$(which clang &> /dev/null; echo ${?})" == "0" ]; then
    msg2 "Clang detected! Building with Clang..."
    CC=clang
    clang_exist=1
  fi
  fi

  # custom gcc if exist
  if [ "$(find ${gcc_path}gcc &> /dev/null; echo ${?})" == "0" ]; then
    msg2 "Custom built GCC detected!"
    # use ccache if exist and clang is absent
    if [ "${clang_exist}" == "0" ] && [ "${ccache_exist}" == "1" ]; then
      CROSS_COMPILE+="ccache "
    fi
    CROSS_COMPILE+="${gcc_path}"
  fi

  # custom compiler string for clang
  # todo: gcc?
  if [ "${clang_exist}" == "1" ]; then
    # from github.com/nathanchance/scripts, slightly edited
    KBUILD_COMPILER_STRING="$(${CC} --version | head -n 1 | cut -d \( -f 1 | sed 's/[[:space:]]*$//')"
    export KBUILD_COMPILER_STRING
    msg2 "Using ${KBUILD_COMPILER_STRING}..."
  fi

  # set CROSS_COMPILE and CC if declared via compiler array
  [ -n "${CROSS_COMPILE}" ] && compiler+=( "CROSS_COMPILE=${CROSS_COMPILE}" )
  [ -n "${CC}" ] && compiler+=( "CC=${CC}" )

  cd $_srcname

  make "${compiler[@]}" bzImage modules -j$(nproc --all) > /dev/null
}

_package() {
  pkgdesc="The Linux-VK kernel and modules"
  depends=(coreutils linux-firmware kmod mkinitcpio)
  optdepends=('crda: to set the correct wireless channels of your country')
  replaces=(linux-vanadium)
  conflicts=(linux-vanadium)
  backup=("etc/mkinitcpio.d/$pkgbase.preset")
  install=linux.install

  local kernver="$(<version)"
  local modulesdir="$pkgdir/usr/lib/modules/$kernver"

  # Copy signing_key.x509 to PKGBUILD location
  cp -f ${_srcname}/certs/signing_key.x509 ../linux-vk.x509

  cd $_srcname

  msg2 "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"
  install -Dm644 "$modulesdir/vmlinuz" "$pkgdir/boot/vmlinuz-$pkgbase"

  msg2 "Installing modules..."
  make INSTALL_MOD_PATH="$pkgdir/usr" modules_install > /dev/null

  # a place for external modules,
  # with version file for building modules and running depmod from hook
  local extramodules="extramodules$_kernelname"
  local extradir="$pkgdir/usr/lib/modules/$extramodules"
  install -Dt "$extradir" -m644 ../version
  ln -sr "$extradir" "$modulesdir/extramodules"

  # remove build and source links
  rm "$modulesdir"/{source,build}

  msg2 "Installing hooks..."
  # sed expression for following substitutions
  local subst="
    s|%PKGBASE%|$pkgbase|g
    s|%KERNVER%|$kernver|g
    s|%EXTRAMODULES%|$extramodules|g
  "

  # hack to allow specifying an initially nonexisting install file
  sed "$subst" "$startdir/$install" > "$startdir/$install.pkg"
  true && install=$install.pkg

  # fill in mkinitcpio preset and pacman hooks
  sed "$subst" ../linux.preset | install -Dm644 /dev/stdin \
    "$pkgdir/etc/mkinitcpio.d/$pkgbase.preset"
  sed "$subst" ../60-linux.hook | install -Dm644 /dev/stdin \
    "$pkgdir/usr/share/libalpm/hooks/60-$pkgbase.hook"
  sed "$subst" ../90-linux.hook | install -Dm644 /dev/stdin \
    "$pkgdir/usr/share/libalpm/hooks/90-$pkgbase.hook"

  msg2 "Fixing permissions..."
  chmod -Rc u=rwX,go=rX "$pkgdir"
}

_package-headers() {
  pkgdesc="Header files and scripts for building modules for Linux-VK kernel"
  replaces=(linux-vanadium-headers)
  conflicts=(linux-vanadium-headers)

  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  cd $_srcname

  msg2 "Installing build files..."
  install -Dt "$builddir" -m644 Makefile .config Module.symvers System.map vmlinux
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts

  # add objtool for external module building and enabled VALIDATION_STACK option
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # add xfs and shmem for aufs building
  mkdir -p "$builddir"/{fs/xfs,mm}

  # ???
  mkdir "$builddir/.tmp_versions"

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
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase-$pkgver"

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
