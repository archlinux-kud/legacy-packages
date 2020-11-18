# Maintainer: Albert I <kras@raphielgang.org>

# NOTE:
# Due to potential license incompatibilities between CDDL and GPL-2.0,
# ZFS on Linux couldn't be implemented into kernel directly.

pkgname=zfs-moesyndrome
_zfsver=2.0.0-rc6
pkgver=${_zfsver/-/_}
pkgrel=1
pkgdesc='Kernel modules for the Zettabyte File System for linux-moesyndrome'
arch=(x86_64)
url='https://www.zfsonlinux.org'
license=(CDDL)
_kernver=5.8.18~ms13-2
depends=("linux-moesyndrome=$_kernver" zfs-utils)
makedepends=("linux-moesyndrome-headers=$_kernver")
provides=(spl zfs)
conflicts=(spl-dkms{,-git} zfs-dkms{,-{git,rc}})
options=('!buildflags' '!strip')
source=("https://github.com/openzfs/zfs/releases/download/zfs-$_zfsver/zfs-$_zfsver.tar.gz"{,.asc})
b2sums=(e7a91d980940998a7312d48a43c07561e3b1aa72cc6f88eb534cb39b5e18de4280964ba7f690b63f5e2dd3cfdeb57d718d7389f8ab2062ff7bb6e8bb4174801a
        SKIP)
validpgpkeys=(C33DF142657ED1F7C328A2960AB9E991C6AF658B)

_moever=${_kernver/-*/+arch}
_kernsrc=/usr/lib/modules/$_moever/build

prepare() {
    cd "$srcdir/zfs-${_zfsver/-rc*/}"
    # FIXME: Configure fails without explicit CC declaration to Clang
    CC=clang \
    ./configure \
        --prefix=/usr \
        --with-config=kernel \
        --with-linux="$_kernsrc" \
        --with-linux-obj="$_kernsrc"
}

build() {
    cd "$srcdir/zfs-${_zfsver/-rc*/}"
    make -C "$_kernsrc" M="$PWD"/module CONFIG_ZFS=m modules
}

package() {
    cd "$srcdir/zfs-${_zfsver/-rc*/}"
    make -C "$_kernsrc" M="$PWD"/module INSTALL_MOD_PATH="$pkgdir"/usr INSTALL_MOD_STRIP=1 modules_install
    find "$pkgdir"/usr -name modules.* -delete;
}
