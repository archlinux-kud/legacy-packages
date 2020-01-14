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
sha384sums=('SKIP'
            'efeb1f33db6b7c4473a26a8fef2b99e651a5f8a125d497017950d26aaf70129c381cd1e1a7e3dced19547d217b33be42')

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
