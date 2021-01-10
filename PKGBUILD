# Maintainer: Kyle De'Vir (QuartzDragon) <kyle.devir.mykolab.com>
# Contributor: Albert I <kras@raphielgang.org>

_reponame=bcachefs-tools
pkgname=$_reponame-git
pkgver=0.1.r253.gf39f0bd
pkgrel=1
pkgdesc='BCacheFS filesystem utilities'
url="https://github.com/koverstreet/$_reponame"
arch=(x86_64)
license=(GPL2)
provides=(bcachefs-tools)
depends=(glibc keyutils libaio libscrypt libsodium liburcu libutil-linux lz4 zlib zstd)
makedepends=(git pkgconf valgrind)
checkdepends=(python-pytest)
install=$pkgname.install
source=(
    git+"$url"
    add-mkinitcpio-hook-for-Arch.patch
    # Clang fixes to kernel driver from MoeSyndrome Kernel; also updates kernel driver itself
    moesyndrome-fixes.patch
)
b2sums=(
    SKIP
    9b62011738b412d579852ee95dc15eda5b462bd9f8858e7acd144101f64c9f58bf4f928da792d675443e2d0904ed9d6f71e444abc827314d6a5d5273f5021339
    eaea27c3972d8ae225163dadb92030c7180047efd82aad8c53867b95bbf30f0b77bfa36df7b46ee4bea14d89ca082f8bb33b002502806c672a217d38e5ac7443
)

prepare() {
    cd "$srcdir/$_reponame"
    
    patch -Np1 < ../add-mkinitcpio-hook-for-Arch.patch
    patch -Np1 < ../moesyndrome-fixes.patch
}

pkgver() {
    git -C "$srcdir/$_reponame" describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g'
}

build() {
    make -C "$srcdir/$_reponame" bcachefs
}

check() {
    make -C "$srcdir/$_reponame" PYTEST=pytest check
}

package() {
    cd "$srcdir/$_reponame"

    make DESTDIR="$pkgdir" PREFIX=/usr ROOT_SBINDIR=/usr/bin INITRAMFS_DIR=/etc/initcpio install
    install -Dm644 arch/etc/initcpio/hooks/bcachefs "$pkgdir"/etc/initcpio/hooks/bcachefs
    install -Dm644 arch/etc/initcpio/install/bcachefs "$pkgdir"/etc/initcpio/install/bcachefs
}
