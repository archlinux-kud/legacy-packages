# Based on spirv-cross PKGBUILD by:
# Daniel Bermond < gmail-com: danielbermond >

# Maintainer: Albert I <kras@raphielgang.org>

pkgname=spirv-cross-git
pkgver=r2144.4ce04480
pkgrel=1
pkgdesc='A tool and library for parsing and converting SPIR-V to other shader languages (git version)'
arch=('x86_64')
url='https://github.com/KhronosGroup/SPIRV-Cross/'
license=('Apache')
depends=('gcc-libs')
makedepends=('git' 'cmake' 'python' 'python-nose')
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

    for i in glslang SPIRV-Tools; do
        ln -sf "${srcdir}/${i}"       external/
    done
    ln -sf "${srcdir}/SPIRV-Headers" "${srcdir}/SPIRV-Tools/external/spirv-headers"
}

build() {
    # NOTE (1): test suite fails when using 'None' build type
    # NOTE (2): test suite fails when using glslang and spirv-tools from the repos
    #           (probably because spirv-tools is outdated at the time of writing)

    # glslang (required for tests)
    printf '%s\n' '  -> Building glslang...'
    cd "SPIRV-Cross/external/glslang-build"
    cmake \
        -DCMAKE_BUILD_TYPE:STRING='Release' \
        -DCMAKE_INSTALL_PREFIX:PATH='output' \
        -Wno-dev \
        ../glslang
    cmake --build . --config Release --target install
    
    # spirv-tools (required for tests)
    printf '%s\n' '  -> Building SPIRV-Tools...'
    cd "${srcdir}/SPIRV-Cross/external/spirv-tools-build"
    cmake \
        -DCMAKE_BUILD_TYPE:STRING='Release' \
        -DSPIRV_WERROR:BOOL='OFF' \
        -DCMAKE_INSTALL_PREFIX:PATH='output' \
        -Wno-dev \
        ../spirv-tools
    cmake --build . --config Release --target install
    
    # spirv-cross
    printf '%s\n' '  -> Building SPIRV-Cross...'
    cd "${srcdir}/SPIRV-Cross/build"
    cmake \
        -DCMAKE_BUILD_TYPE:STRING='Release' \
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
