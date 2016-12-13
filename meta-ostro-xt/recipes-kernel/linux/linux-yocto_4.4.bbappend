FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_prepend_intel-corei7-64 = "file://fix_branch.scc "
SRC_URI_append_intel-corei7-64 = " file://disable-iwlwifi-upstream.cfg"
SRC_URI_append_intel-corei7-64 = " file://debug-kernel.cfg"
SRC_URI_append_intel-corei7-64 = " file://0001-x86-early_printk-Allow-for-skipping-PCI-class-check.patch"
#SRC_URI_append_intel-corei7-64 = " file://0001-DO-NOT-MERGE-intel_pmc_ipc-Debug-messages-to-see-whe.patch"
#SRC_URI_append_intel-corei7-64 = " file://0001-DBG-remove-ttyS2-for-BXT.patch"

LINUX_VERSION_INTEL_COMMON_forcevariable = "4.4.32"
KBRANCH_corei7-64-intel-common_forcevariable = "standard/intel/bxt-rebase;rebaseable=1"
# http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-4.4/log/?h=standard/intel/bxt-rebase
SRCREV_machine_corei7-64-intel-common = "14ed59a239de7c119592c29503b82efc56ad0697"
# http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-cache/log/?h=yocto-4.4
SRCREV_meta_corei7-64-intel-common = "24ea5324fc90c7cb15ce1a08cdd294f22c6e6382"

# This feature was already removed from KERNEL_FEATURES_INTEL_COMMON
# in meta-intel master (a4c1cfb53d192, linux-yocto*: remove mei from
# KERNEL_FEATURES) and continuing to use it breaks the build because
# the yocto-kernel-cache specified above no longer has the feature.
#
# But we are on an older meta-intel revision and updating would have
# to be done with some care because of a gstreamer-vaapi change
# (3f51f61efe9, "care should be taken to keep the gstreamer-vaapi build
# configuration in sync with the gstreamer build configuration"). That
# change has to wait, so for now just apply the same removal here:
KERNEL_FEATURES_remove_corei7-64-intel-common = "features/amt/mei/mei.scc"

# Non-standard feature which should only be enabled on platforms which need it.
KERNEL_FEATURES_append_corei7-64-intel-common = " features/mei/mei-spd.scc"

# deploy vmlinux
KERNEL_ALT_IMAGETYPE = "vmlinux"

# Removal will also happen in meta-ostro-bsp
# (https://github.com/ostroproject/meta-ostro-bsp/pull/57) but for now
# remove them directly here because otherwise the new upstream code
# won't compile.
SRC_URI_remove = " \
    file://0001-iio-tmp006-Set-correct-iio-name.patch \
    file://0001-iio-si7020-Set-correct-iio-name.patch \
"

# Explicitly enable TPM support
SRC_URI_append = " file://security-tpm.cfg"
