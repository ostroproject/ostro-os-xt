# NOTE: SECURITY_NO_PIE_CFLAGS and SECURITY_PIC_CFLAGS are defined in
#       meta-ostro/conf/distro/include/ostro_security_flags.inc
SECURITY_CFLAGS_pn-log4cxx = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-cppunit = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-sphinxbase = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-python-lxml = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-pocketsphinx = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-tbb = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-yaml-cpp = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-python-netifaces = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-protobuf = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-wxwidgets = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-clang = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"
SECURITY_CFLAGS_pn-python-pyyaml = "${SECURITY_NO_PIE_CFLAGS} ${SECURITY_PIC_CFLAGS}"

SECURITY_STRINGFORMAT_pn-qhull = ""
SECURITY_STRINGFORMAT_pn-libgphoto2 = ""
SECURITY_STRINGFORMAT_pn-wxpython = ""

# Those are outdated packages, we'll need to update them anyway and don't
# care about the fact they use host's compiler.
SECURITY_CFLAGS_remove_pn-mozjs = "-fstack-protector-strong"
SECURITY_CFLAGS_append_pn-mozjs = " -fstack-protector-all"
SECURITY_LDFLAGS_remove_pn-mozjs = "-fstack-protector-strong"
SECURITY_LDFLAGS_append_pn-mozjs = " -fstack-protector-all"

SECURITY_CFLAGS_remove_pn-libatasmart = "-fstack-protector-strong"
SECURITY_CFLAGS_append_pn-libatasmart = " -fstack-protector-all"
SECURITY_LDFLAGS_remove_pn-libatasmart = "-fstack-protector-strong"
SECURITY_LDFLAGS_append_pn-libatasmart = " -fstack-protector-all"
