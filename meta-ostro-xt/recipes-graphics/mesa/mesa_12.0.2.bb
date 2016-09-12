require ${BPN}.inc

SRC_URI = "ftp://ftp.freedesktop.org/pub/mesa/${PV}/mesa-${PV}.tar.xz \
           file://${COREBASE}/meta/recipes-graphics/mesa/files/replace_glibc_check_with_linux.patch \
           file://disable-asm-on-non-gcc.patch \
"

SRC_URI[md5sum] = "f19032b5cb5e362745f0c2accc28a641"
SRC_URI[sha256sum] = "d957a5cc371dcd7ff2aa0d87492f263aece46f79352f4520039b58b1f32552cb"

#because we cannot rely on the fact that all apps will use pkgconfig,
#make eglplatform.h independent of MESA_EGL_NO_X11_HEADER
do_install_append() {
    if ${@bb.utils.contains('PACKAGECONFIG', 'egl', 'true', 'false', d)}; then
        sed -i -e 's/^#if defined(MESA_EGL_NO_X11_HEADERS)$/#if defined(MESA_EGL_NO_X11_HEADERS) || ${@bb.utils.contains('PACKAGECONFIG', 'x11', '0', '1', d)}/' ${D}${includedir}/EGL/eglplatform.h
    fi
}
