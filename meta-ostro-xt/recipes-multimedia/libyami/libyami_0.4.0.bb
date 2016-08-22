SUMMARY = "Yet Another Media Infrastructure"
DESCRIPTION = "Yami is core building block for media solution. it parses video stream \
and decodes them leverage hardware acceleration."
HOMEPAGE="https://github.com/01org/libyami"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://COPYING.LIB;md5=3b83ef96387f14655fc854ddc3c6bd57"

inherit autotools pkgconfig

SRC_URI = "https://github.com/01org/${PN}/archive/${PN}-${PV}.tar.gz"
SRC_URI[md5sum] = "610b52d40dfe5ce8844450ed39aa916d"
SRC_URI[sha256sum] = "b4a139fac81b6644828e8c9c377fe251128d2b4440ffd656f973c0bee14a2821"

S = "${WORKDIR}/${PN}-${PN}-${PV}"

EXTRA_OECONF = "--enable-vp9dec --enable-vp8enc"

DEPENDS = "libva"
PACKAGECONFIG ??= "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'x11', '', d)}"
PACKAGECONFIG[x11] = "--enable-x11,--disable-x11,libx11"
