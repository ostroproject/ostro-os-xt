SUMMARY = "va for Ostro OS XT"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = " \
    libva \
    libva-intel-driver \
    va-intel \
"
