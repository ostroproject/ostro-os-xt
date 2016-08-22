SUMMARY = "Multimedia packages for Ostro OS XT"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = " \
    gstreamer1.0-plugins-good \
    gstreamer-vaapi-1.0 \
    libyami \
    libyami-utils \
"
