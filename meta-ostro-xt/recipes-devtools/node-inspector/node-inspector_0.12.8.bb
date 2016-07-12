SRC_URI = "npm://registry.npmjs.org;name=${PN};version=${PV}"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=480ea7e44791280d20fa258a33030275"

DEPENDS = "bash"

do_compile_prepend() {
    export HOME="${WORKDIR}"

    if [ "${TARGET_ARCH}" == "i586" ]; then
        npm config set target_arch ia32
        export TARGET_ARCH=ia32
    fi
}


inherit npm
