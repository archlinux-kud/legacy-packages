# Based on spirv-cross PKGBUILD by:
# Daniel Bermond < gmail-com: danielbermond >

# Maintainer: Albert I <kras@raphielgang.org>

pkgname=spirv-cross-git
pkgver=r1985.4c20c941
pkgrel=1
pkgdesc='A tool and library for parsing and converting SPIR-V to other shader languages (git version)'
arch=('x86_64')
url='https://github.com/KhronosGroup/SPIRV-Cross/'
license=('Apache')
depends=('gcc-libs')
makedepends=('git' 'cmake' 'python')
provides=("${pkgname/-git}")
conflicts=("${pkgname/-git}")
source=("git+https://github.com/KhronosGroup/SPIRV-Cross.git"
        "git+https://github.com/KhronosGroup/glslang.git"
        "git+https://github.com/KhronosGroup/SPIRV-Tools.git"
        "git+https://github.com/KhronosGroup/SPIRV-Headers.git")
sha256sums=('SKIP'
            'SKIP'
            'SKIP'
            'SKIP')

pkgver() {
    cd "SPIRV-Cross"

    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

prepare() {
    cd "SPIRV-Cross"
    
    mkdir -p build external/{glslang,spirv-tools}-build
    
    ln -s "${srcdir}/glslang"       external/glslang
    ln -s "${srcdir}/SPIRV-Tools"   external/spirv-tools
    ln -s "${srcdir}/SPIRV-Headers" "${srcdir}/SPIRV-Tools/external/spirv-headers"
}

build() {
    # glslang (required for tests)
    printf '%s\n' '  -> Building glslang...'
    cd "SPIRV-Cross/external/glslang-build"
    cmake \
        -DCMAKE_BUILD_TYPE:STRING='None' \
        -DCMAKE_INSTALL_PREFIX:PATH='output' \
        -Wno-dev \
        ../glslang
    cmake --build . --config None --target install
    
    # spirv-tools (required for tests)
    printf '%s\n' '  -> Building SPIRV-Tools...'
    cd "${srcdir}/SPIRV-Cross/external/spirv-tools-build"
    cmake \
        -DCMAKE_BUILD_TYPE:STRING='None' \
        -DSPIRV_WERROR:BOOL='OFF' \
        -DCMAKE_INSTALL_PREFIX:PATH='output' \
        -Wno-dev \
        ../spirv-tools
    cmake --build . --config None --target install
    
    # spirv-cross
    printf '%s\n' '  -> Building SPIRV-Cross...'
    cd "${srcdir}/SPIRV-Cross/build"
    cmake \
        -DCMAKE_BUILD_TYPE:STRING='None' \
        -DCMAKE_INSTALL_PREFIX:PATH='/usr' \
        -DSPIRV_CROSS_SHARED:BOOL='ON' \
        -Wno-dev \
        ..
    make
}

package() {
    cd "SPIRV-Cross/build"
    
    make DESTDIR="$pkgdir" install
}
