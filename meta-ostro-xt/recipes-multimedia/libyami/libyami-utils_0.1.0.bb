SUMMARY = "Applications and Scripts for libyami."
DESCRIPTION = "Yami is core building block for media solution. it parses video stream \
and decodes them leverage hardware acceleration."
HOMEPAGE="https://github.com/01org/libyami"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit autotools-brokensep pkgconfig

SRC_URI = "https://github.com/01org/${PN}/archive/${PV}.tar.gz"
SRC_URI[md5sum] = "67f6ed897476d025460d6c57884b2ad7"
SRC_URI[sha256sum] = "45de376a3f744f01c720ab0f0f33efde6dee75fcdfb8c1c1bdd434673ac1c565"

S = "${WORKDIR}/${PN}-${PV}"

DEPENDS = "libyami libbsd"
