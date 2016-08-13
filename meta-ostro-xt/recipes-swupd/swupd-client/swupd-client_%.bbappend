FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://ostroprojectorg.key \
"

do_install_append () {
    install -d ${D}${datadir}/clear/update-ca
    rm -f ${D}${datadir}/clear/update-ca/425b0f6b.key
    install -m 0644 ${WORKDIR}/ostroprojectorg.key ${D}${datadir}/clear/update-ca/425b0f6b.key
}
