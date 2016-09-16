DESCRIPTION = "Ostro XT iptables and ip6tables settings."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://xt-iptables.rules \
    file://xt-ip6tables.rules \
"

inherit update-alternatives

# If you have a system without IPv6 support, just drop out the
# configuration files for ip6tables.

ALTERNATIVE_${PN} += "iptables.rules ip6tables.rules"
ALTERNATIVE_LINK_NAME[iptables.rules] = "${datadir}/iptables-settings/iptables.rules"
ALTERNATIVE_LINK_NAME[ip6tables.rules] = "${datadir}/iptables-settings/ip6tables.rules"
ALTERNATIVE_TARGET[iptables.rules] = "${datadir}/iptables-settings/xt-iptables.rules"
ALTERNATIVE_TARGET[ip6tables.rules] = "${datadir}/iptables-settings/xt-ip6tables.rules"

FILES_${PN} += "${datadir}/iptables-settings/"

do_install() {
    install -d ${D}${datadir}/iptables-settings
    install -m 0644 ${WORKDIR}/xt-iptables.rules ${D}${datadir}/iptables-settings/xt-iptables.rules
    install -m 0644 ${WORKDIR}/xt-ip6tables.rules ${D}${datadir}/iptables-settings/xt-ip6tables.rules
}
