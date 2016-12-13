# The original update has been submitted to oe-core as
# https://patchwork.openembedded.org/patch/127215/, but it won't
# make to the first XT release thus update it in XT with the bbappend.
#
# This file is supposed to be dropped as soon as the original commit gets
# merged to Ostro OS.

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LIC_FILES_CHKSUM_remove = "file://WHENCE;md5=d4c5506dce2fe59ec0faa20bbd1a89bb"
LIC_FILES_CHKSUM += "file://WHENCE;md5=fc7f8a9fce11037078e90df415baad71"

SRCREV = "cccb6a0da98372bd66787710249727ad6b0aaf72"

SRC_URI += "\
            file://dfw_sst.bin \
            file://LICENSE.dfw_sst;subdir=git/ \
"

LICENSE += "& Firmware-dfw_sst"
LICENSE_${PN} += "& Firmware-dfw_sst"

NO_GENERIC_LICENSE[Firmware-dfw_sst] = "LICENSE.dfw_sst"

LIC_FILES_CHKSUM += "file://LICENSE.dfw_sst;md5=4e63f629d461663f675e72588128f896"

do_install_append() {
	cp -r ${WORKDIR}/dfw_sst.bin ${D}/lib/firmware/
	cp -r ${S}/LICENSE.dfw_sst ${D}/lib/firmware/
}
