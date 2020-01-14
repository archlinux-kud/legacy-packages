# Maintainer: Gaetan Bisson <bisson@archlinux.org>
# Contributor: Mateusz Herych <heniekk@gmail.com>
# Contributor: sysrq

pkgname=picard
pkgver=2.3.0a1
_commit=aa372fbe4cc27e0a05705f4d0ae530c78f11c551
pkgrel=1
pkgdesc='Official MusicBrainz tagger'
url='https://picard.musicbrainz.org/'
license=('GPL')
arch=('x86_64')
depends=('python-pyqt5' 'python-mutagen')
optdepends=('chromaprint: fingerprinting'
            'python-discid: cd lookup'
            'qt5-multimedia: media player toolbar'
            'qt5-translations: full UI translation')
makedepends=('git' 'python-setuptools')
source=("git+https://github.com/metabrainz/picard.git#commit=$_commit"
        'pyqt-5.14.patch::https://github.com/metabrainz/picard/commit/32e05058e0ac5772d7a480287ee428642fbbc9b9.patch')
sha256sums=('SKIP'
            '08ec55a9b35c8f68374bfff548e63eec7c1afea44626e749c096957cc96fbb66')

prepare() {
	cd "${srcdir}/${pkgname}"
	patch -Np1 < ../pyqt-5.14.patch
}

build() {
	cd "${srcdir}/${pkgname}"
	sed "s/‘/'/g" -i setup.cfg
	python setup.py config
}

package() {
	cd "${srcdir}/${pkgname}"
	python setup.py install \
		--root="${pkgdir}" \
		--disable-autoupdate \

	rm -fr "${pkgdir}"/usr/lib/python*/site-packages/picard-*.egg-info
}
