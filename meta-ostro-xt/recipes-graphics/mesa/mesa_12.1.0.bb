require ${BPN}.inc

SRC_URI = "git://anongit.freedesktop.org/git/mesa/mesa;branch=master"
SRCREV = "b9e639589d2e06f3a7ecfebd811cacb9655fab5a"
PV = "12.1.0+git${SRCPV}"

S= "${WORKDIR}/git"

#because we cannot rely on the fact that all apps will use pkgconfig,
#make eglplatform.h independent of MESA_EGL_NO_X11_HEADER
do_install_append() {
    if ${@bb.utils.contains('PACKAGECONFIG', 'egl', 'true', 'false', d)}; then
        sed -i -e 's/^#if defined(MESA_EGL_NO_X11_HEADERS)$/#if defined(MESA_EGL_NO_X11_HEADERS) || ${@bb.utils.contains('PACKAGECONFIG', 'x11', '0', '1', d)}/' ${D}${includedir}/EGL/eglplatform.h
    fi
}
