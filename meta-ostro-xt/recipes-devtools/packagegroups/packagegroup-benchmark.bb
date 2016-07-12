SUMMARY = "Benchmarking components for Ostro OS XT"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS_${PN} = " \
    ltp \
    glmark2 \
    lmbench \
    memtester \
    fwts \
    tinymembench \
    perf \
"
