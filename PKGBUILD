# Maintainer: Gaetan Bisson <bisson@archlinux.org>
# Contributor: Mateusz Herych <heniekk@gmail.com>
# Contributor: sysrq

pkgname=picard
pkgver=2.3.0b1
_commit=66a1b7822bc0bfa397ea49281a3e3fbc766df3fa
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
source=("git+https://github.com/metabrainz/picard.git#commit=$_commit")
sha384sums=('SKIP')

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
