SUMMARY = "OpenCL for Ostro OS XT"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = " \
    beignet \
    ocl-icd \
"
