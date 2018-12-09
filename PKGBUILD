# Based on PKGBUILD created for Arch Linux by:
# Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>
# Tobias Powalowski <tpowa@archlinux.org>
# Thomas Baechler <thomas@archlinux.org>

# Author: Albert I <krascgq@outlook.co.id>

pkgbase=linux-vk
pkgver=4.19.8
pkgrel=1
arch=(x86_64)
url="https://github.com/krasCGQ/linux-vk"
license=(GPL2)
makedepends=(kmod inetutils bc libelf git)
options=('!strip')
_srcname=${pkgbase/-*}
source=(
  "$_srcname::git+$url"
  config         # the main kernel config file
  60-linux.hook  # pacman hook for depmod
  90-linux.hook  # pacman hook for initramfs regeneration
  linux.install  # standard config file for post (un)install
  linux.preset   # standard config file for mkinitcpio ramdisk
)
sha512sums=('SKIP'
            '4f9609e499ab2fbdec9bbcf316d7aaac85f0b1d98e00a8759b5834fd36f5b6c1de0647f585c5ca498f1c1066b6928f9a1bd0b9b5248233038f44eadda64d8a12'
            '7ad5be75ee422dda3b80edd2eb614d8a9181e2c8228cd68b3881e2fb95953bf2dea6cbe7900ce1013c9de89b2802574b7b24869fc5d7a95d3cc3112c4d27063a'
            '2718b58dbbb15063bacb2bde6489e5b3c59afac4c0e0435b97fe720d42c711b6bcba926f67a8687878bd51373c9cf3adb1915a11666d79ccb220bf36e0788ab7'
            'b2a4d48144cd8585a90397b5d99e6d062c627fb0d752db7e599b8aa16cec3e7a1f2c4804db1ba806ac5d122fa71d533f302abc2f57fdf76cc7218cfb53ae1d79'
            '0a52a7352490de9d0202c777a45ab33e85e98d5c5ef9e5edf2dd6461f410a6232313d4239bdad8dd769c585b815d8f7c9941ead81b88928ec6e2cc4c849673c8')

_kernelname=${pkgbase#linux}
_codename=SophieTwilight

prepare() {
  cd $_srcname

  msg2 "Setting version..."
  scripts/setlocalversion --save-scmversion
  echo "-$pkgrel" > localversion.10-pkgrel
  echo "${_kernelname^^}.$_codename" > localversion.20-pkgname

  msg2 "Setting config..."
  cp ../config .config
  make olddefconfig > /dev/null

  make -s kernelrelease > ../version
  msg2 "Prepared %s version %s" "$pkgbase" "$(<../version)"
}

build() {
  cd $_srcname

  if [ "$(which ccache > /dev/null 2>&1; echo $?)" == "0" ] && [ "$(find /opt/kud/x86_64-linux-gnu/bin/x86_64-linux-gnu-gcc > /dev/null 2>&1; echo $?)" == "0" ]; then
     local compiler=( "CROSS_COMPILE=ccache /opt/kud/x86_64-linux-gnu/bin/x86_64-linux-gnu-" )
  fi

  make "${compiler[@]}" bzImage modules -j$(nproc --all) > /dev/null
}

_package() {
  pkgdesc="The ${pkgbase/linux/Linux} kernel and modules"
  depends=(coreutils linux-firmware kmod mkinitcpio)
  optdepends=('crda: to set the correct wireless channels of your country')
  replaces=(linux-vanadium)
  conflicts=(linux-vanadium)
  backup=("etc/mkinitcpio.d/$pkgbase.preset")
  install=linux.install

  local kernver="$(<version)"
  local modulesdir="$pkgdir/usr/lib/modules/$kernver"

  cd $_srcname

  msg2 "Installing boot image..."
  # FIXME: install: cannot stat '*'$'\n''* Restart config...'$'\n''*'$'\n''*'$'\n''* GCC plugins'$'\n''*'$'\n''GCC plugins (GCC_PLUGINS) [N/y/?] (NEW) ': No such file or directory
  echo "# CONFIG_GCC_PLUGINS is not set" >> .config
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
  pkgdesc="Header files and scripts for building modules for ${pkgbase/linux/Linux} kernel"
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
