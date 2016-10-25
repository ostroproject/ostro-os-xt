FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_prepend_intel-corei7-64 = "file://fix_branch.scc "
SRC_URI_append_intel-corei7-64 = " file://disable-iwlwifi-upstream.cfg"

LINUX_VERSION_INTEL_COMMON_forcevariable = "4.4.26"
KBRANCH_corei7-64-intel-common_forcevariable = "standard/intel/bxt-rebase;rebaseable=1"
# http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-4.4/log/?h=standard/intel/bxt-rebase
SRCREV_machine_corei7-64-intel-common = "b7ddcae5f0f374ab7ffd49b0f8636328f5e3386f"
# http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-cache/log/?h=yocto-4.4
SRCREV_meta_corei7-64-intel-common = "3030330b066a33ce21164a8b30d0503cf9f68e5b"

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

# Removal will also happen in meta-ostro-bsp
# (https://github.com/ostroproject/meta-ostro-bsp/pull/57) but for now
# remove them directly here because otherwise the new upstream code
# won't compile.
SRC_URI_remove = " \
    file://0001-iio-tmp006-Set-correct-iio-name.patch \
    file://0001-iio-si7020-Set-correct-iio-name.patch \
"

do_patch_prepend() {
  export GIT_COMMITTER_NAME="${GIT_COMMITTER_NAME}"
  export GIT_COMMITTER_EMAIL="${GIT_COMMITTER_EMAIL}"
}
