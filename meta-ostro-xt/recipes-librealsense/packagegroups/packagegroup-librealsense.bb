SUMMARY = "librealsense for Ostro OS XT"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = " \
    librealsense \
    librealsense-examples \
    librealsense-graphical-examples \
"
