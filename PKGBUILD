# Maintainer: Diab Neiroukh <officiallazerl0rd@gmail.com>
# Contributor: Albert I (krasCGQ) <kras@raphielgang.org>

_reponame=kdrag0n/proton-clang
_version=$(curl -s "https://api.github.com/repos/$_reponame/releases/latest" | grep -w tag_name | cut -d ':' -f 2 | sed -e 's/[[:space:]]//' -e 's/"//g' -e 's/,//')
pkgname=llvm-proton-bin
pkgver=${_version:-20200831}
epoch=1
pkgrel=1
arch=(x86_64)
pkgdesc='A LLVM and Clang compiler toolchain built for kernel development'
url="https://github.com/$_reponame"
license=('custom:Apache 2.0 with LLVM Exception' 'GPL')
provides=('proton-clang=12.0.0')
options=(!strip)
source=("${_reponame/kdrag0n\//}-$pkgver.tar.gz::$url/archive/$pkgver.tar.gz"
        'license-llvm.txt::https://raw.githubusercontent.com/llvm/llvm-project/4a1b95bda0c444798a5240fe924dd127b776d12d/llvm/LICENSE.TXT'
        'license-binutils.txt::https://www.gnu.org/licenses/gpl-3.0.txt')
b2sums=('SKIP'
        '74efe5f21dd0f11cf12ba23a94f7e1f3032512e9e10f2d35cc3dc9cfc67277112d152af1e05363b56280cd7437f41f093200a5aef7b7e52f9f3325c9be9d20ca'
        '74915e048cf8b5207abf603136e7d5fcf5b8ad512cce78a2ebe3c88fc3150155893bf9824e6ed6a86414bbe4511a6bd4a42e8ec643c63353dc8eea4a44a021cd')

package() {
    install -d "$pkgdir/opt"
    cp -r "proton-clang-$pkgver" "$pkgdir/opt/proton-clang"
    install -Dm644 -t "$pkgdir/usr/share/licenses/$pkgname" license-{llvm,binutils}.txt
}
