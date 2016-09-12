# This recipe adds udev rule to handle HDMI display hotplug events
LICENSE = "GPL-2.0+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI += " \
    file://sysfs-control.sh \
    file://pci-power.rules \
    file://hdmi-hotplug.rules \
"

do_install_append () {
    install -m 0755 -d ${D}/${base_sbindir}
    install -m 0755 ${WORKDIR}/sysfs-control.sh ${D}/${base_sbindir}
    install -m 0755 -d ${D}/${base_libdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/hdmi-hotplug.rules ${D}/${base_libdir}/udev/rules.d/79-hdmi-hotplug.rules
    install -m 0644 ${WORKDIR}/pci-power.rules ${D}/${base_libdir}/udev/rules.d/80-pci-power.rules
}

