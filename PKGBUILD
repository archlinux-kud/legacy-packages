# Maintainer: 

# AUR dependencies
# ----------------
# libilbc chromaprint-fftw libbs2b shine vo-amrwbenc
# nut-multimedia-git xavs libmfx-git libopenmpt-svn zimg-git

# AUR make dependencies
# ---------------------
# flite1

pkgname=ffmpeg-semifull-git
pkgver=N.94905.g8efc9fcc56
pkgrel=1
pkgdesc="Record, convert and stream audio and video (Git version with all possible libs)"
arch=('i686' 'x86_64')
url="http://www.ffmpeg.org/"
license=('GPL3')
depends=(
    'alsa-lib' 'zlib' 'bzip2' 'xz' 'libpng' 'chromaprint-fftw' 'fontconfig' 'frei0r-plugins'
    'libgcrypt' 'gmp' 'glibc' 'ladspa' 'libass' 'libbluray' 'libbs2b' 'libcaca' 'celt'
    'libcdio-paranoia' 'libdc1394' 'libfdk-aac' 'freetype2' 'fribidi' 'libgme' 'gsm'
    'libiec61883' 'libilbc' 'libmodplug' 'lame' 'nut-multimedia-git'
    'opencore-amr' 'opencv2' 'openjpeg2' 'libopenmpt-svn' 'opus' 'pulseaudio'
    'rubberband' 'rtmpdump' 'shine' 'libavc1394' 'snappy' 'libsoxr'
    'speex' 'libssh' 'tesseract' 'libtheora' 'twolame' 'v4l-utils' 'vid.stab' 'vo-amrwbenc'
    'libvorbis' 'libvpx' 'wavpack' 'libwebp' 'libx264.so' 'x265' 'libxcb' 'xvidcore' 'zimg-git'
    'zeromq' 'zvbi' 'openal' 'libva' 'libdrm' 'libva-intel-driver' 'opencl-icd-loader'
    'libvdpau' 'mesa' 'openssl' 'xavs' 'sdl2' 'libmfx-git'
    'libomxil-bellagio' 'davs2'
)
makedepends=('git' 'yasm' 'opencl-headers' 'flite')
provides=(
    'ffmpeg' 'qt-faststart' 'ffmpeg-git' 'ffmpeg-full' 'ffmpeg-semifull' 'ffmpeg-full-extra' 'ffmpeg-full-nvenc'
    'ffmpeg-libfdk_aac' 'libavutil.so' 'libavcodec.so' 'libavformat.so' 'libavdevice.so'
    'libavfilter.so' 'libavresample.so' 'libswscale.so' 'libswresample.so' 'libpostproc.so'
)
conflicts=(
    'ffmpeg' 'ffmpeg-git' 'ffmpeg-full' 'ffmpeg-full-extra' 'ffmpeg-full-nvenc'
    'ffmpeg-libfdk_aac')
source=("$pkgname"::'git://source.ffmpeg.org/ffmpeg.git')
sha256sums=('SKIP')

pkgver() {
	cd "${srcdir}/${pkgname}"
	
	# Method showing version based on FFmpeg Git versioning system
	printf "%s" "$(git describe --tags --match N | tr '-' '.')"
}

build() {
	cd "${srcdir}/${pkgname}"
	
	msg2 "Running ffmpeg configure script. Please wait..."
	
	./configure \
	        --prefix=/usr \
	        --enable-rpath \
	        --enable-gpl \
	        --enable-version3 \
	        --enable-nonfree \
	        --enable-shared \
	        --disable-static \
	        --enable-gray \
	        --enable-avresample \
	        --enable-avisynth \
	        --enable-bzlib \
	        --enable-chromaprint \
	        --enable-frei0r \
	        --enable-gcrypt \
	        --enable-gmp \
	        --enable-iconv \
	        --enable-ladspa \
	        --enable-libass \
	        --enable-libbluray \
	        --enable-libbs2b \
	        --enable-libcaca \
	        --enable-libcelt \
	        --enable-libcdio \
	        --enable-libdavs2 \
	        --enable-libdc1394 \
	        --enable-libfdk-aac \
	        --enable-fontconfig \
	        --enable-libfreetype \
	        --enable-libfribidi \
	        --enable-libgme \
	        --enable-libgsm \
	        --enable-libiec61883 \
	        --enable-libilbc \
	        --enable-libmodplug \
	        --enable-libmp3lame \
	        --enable-libopencore-amrnb \
	        --enable-libopencore-amrwb \
	        --enable-libopencv \
	        --enable-libopenjpeg \
	        --enable-libopenmpt \
	        --enable-libopus \
	        --enable-libpulse \
	        --enable-librubberband \
	        --enable-librtmp  \
	        --enable-libshine \
	        --enable-libsnappy \
	        --enable-libsoxr \
	        --enable-libspeex \
	        --enable-libssh \
	        --enable-libtesseract \
	        --enable-libtheora \
	        --enable-libtwolame \
	        --enable-libv4l2 \
	        --enable-libvidstab \
	        --enable-libvo-amrwbenc \
	        --enable-libvorbis \
	        --enable-libvpx \
	        --enable-libwavpack \
	        --enable-libwebp \
	        --enable-libx264 \
	        --enable-libx265 \
	        --enable-libxavs \
	        --enable-libxcb \
	        --enable-libxcb-shm \
	        --enable-libxcb-xfixes \
	        --enable-libxcb-shape \
	        --enable-libxvid \
	        --enable-libzimg \
	        --enable-libzmq \
	        --enable-libzvbi \
	        --enable-lzma \
	        --enable-openal \
	        --enable-opencl \
	        --enable-opengl \
	        --enable-openssl \
	        --enable-sdl2 \
	        --enable-xlib \
	        --enable-zlib \
	        --enable-libmfx \
	        --enable-omx \
	        --enable-vaapi \
	        --enable-vdpau 
	
	make
	
	make tools/qt-faststart
}

package() {
	cd "${srcdir}/${pkgname}"
	
	make DESTDIR="$pkgdir/" install
	
	install -D -m755 tools/qt-faststart "${pkgdir}/usr/bin/qt-faststart"
}
