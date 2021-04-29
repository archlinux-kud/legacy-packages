# Maintainer: Albert I <kras@raphielgang.org>

# NOTE:
# Due to potential license incompatibilities between CDDL and GPL-2.0,
# ZFS on Linux couldn't be implemented into kernel directly.

pkgname=zfs-moesyndrome
_zfsver=2.1.0-rc4
pkgver=${_zfsver/-/_}
pkgrel=1
pkgdesc='Kernel modules for the Zettabyte File System for linux-moesyndrome'
arch=(x86_64)
url='https://www.zfsonlinux.org'
license=(CDDL)
_kernver=5.10.33~ms23
depends=("linux-moesyndrome=$_kernver" zfs-utils)
makedepends=("linux-moesyndrome-headers=$_kernver")
provides=(spl zfs)
conflicts=(spl-dkms{,-git} zfs-dkms{,-{git,rc}})
options=('!buildflags' '!strip')
source=("https://github.com/openzfs/zfs/releases/download/zfs-$_zfsver/zfs-$_zfsver.tar.gz"{,.asc})
b2sums=(b15b641ad322b7a50a5942500ef7c26f85074ef2672747f7391fcc785c3564c23fa5d49d51a146d284309905b4f1e1f96bb1e48f5cd1aeaebe6c55bc74a1f46f
        SKIP)
validpgpkeys=(
    4F3BA9AB6D1F8D683DC2DFB56AD860EED4598027 # Tony Hutter (GPG key for signing ZFS releases) <hutter2@llnl.gov>
    C33DF142657ED1F7C328A2960AB9E991C6AF658B # Brian Behlendorf <behlendorf1@llnl.gov>
)
_kernsrc=/usr/lib/modules/$_kernver+arch/build

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
