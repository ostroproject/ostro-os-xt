FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
        file://0001-Avoid-dowinloading-nose-in-build-time.patch \
        "
