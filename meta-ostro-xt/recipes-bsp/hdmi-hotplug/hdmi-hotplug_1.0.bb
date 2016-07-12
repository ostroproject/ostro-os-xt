# This recipe adds udev rule to handle HDMI display hotplug events
LICENSE = "GPL-2.0+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI += " \
    file://hdmi-hotplug.rules \
"

do_install_append () {
    install -d ${D}/${base_libdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/hdmi-hotplug.rules ${D}/${base_libdir}/udev/rules.d/79-hdmi-hotplug.rules
}

