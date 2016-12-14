FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://efi_combo_updater.sh \
    file://efi-combo-trigger.service.new \
    file://ostroprojectorg.key \
"
SWUPD_VERSION_URL ?= "https://download.ostroproject.org/updates/ostro-os-xt/milestone/intel-corei7-64/ostro-xt-image-swupd"
SWUPD_CONTENT_URL ?= "https://download.ostroproject.org/updates/ostro-os-xt/milestone/intel-corei7-64/ostro-xt-image-swupd"

do_install_append () {
    rm -rf ${D}/usr/bin/efi_combo_updater
    install -m 0744 ${WORKDIR}/efi_combo_updater.sh ${D}/usr/bin/

    rm -rf ${D}/${systemd_system_unitdir}/efi-combo-trigger.service
    install -m 0644 ${WORKDIR}/efi-combo-trigger.service.new ${D}/${systemd_system_unitdir}/efi-combo-trigger.service

    install -d ${D}${localstatedir}/lib/swupd
    install -d ${D}${datadir}/clear/update-ca
    rm -f ${D}${datadir}/clear/update-ca/425b0f6b.key
    install -m 0644 ${WORKDIR}/ostroprojectorg.key ${D}${datadir}/clear/update-ca/425b0f6b.key
}
