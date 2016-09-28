# Base class for all Ostro OS XT images.
# Defines some new (compared to base Ostro OS) image features
# and tweaks the images for the desired target platform
# of Ostro OS XT.

inherit ostro-image

OSTRO_XT_IMAGE_PKG_FEATURES = "\
    librealsense \
    xfce-base \
    x11 \
    benchmark \
    va \
    opencv \
    opencl \
    xdk-daemon \
    backport-iwlwifi \
    multimedia \
    realsense-sdk \
    alsa \
"

IMAGE_FEATURE[validitems] += " \
    ${OSTRO_XT_IMAGE_PKG_FEATURES} \
"

FEATURE_PACKAGES_librealsense = "packagegroup-librealsense"
FEATURE_PACKAGES_xfce-base = "packagegroup-xfce-base"
FEATURE_PACKAGES_x11 = "packagegroup-core-x11 xterm twm"
FEATURE_PACKAGES_opencl = "packagegroup-opencl"
FEATURE_PACKAGES_va = "packagegroup-va"
FEATURE_PACKAGES_benchmark = "packagegroup-benchmark"
FEATURE_PACKAGES_opencv = "opencv"
FEATURE_PACKAGES_xdk-daemon = "xdk-daemon"
FEATURE_PACKAGES_backport-iwlwifi = "backport-iwlwifi"
FEATURE_PACKAGES_multimedia = "packagegroup-multimedia"
FEATURE_PACKAGES_realsense-sdk = "packagegroup-realsense"
FEATURE_PACKAGES_alsa = "alsa-utils alsa-state"

# By default, all Ostro OS XT images include the full set of software
# provided by Ostro OS and Ostro OS XT (except for benchmarks and QA
# tests), plus the corresponding development files for on-device
# development.
#
# This can be overridden for all images by setting the following two
# variables in a local.conf file.
OSTRO_XT_IMAGE_EXTRA_FEATURES ?= " \
    ${@ ' '.join([x for x in '${OSTRO_XT_IMAGE_PKG_FEATURES} ${OSTRO_IMAGE_PKG_FEATURES}'.split() if x not in ('qatests', 'benchmark')]) } \
    dev-pkgs \
"
OSTRO_XT_IMAGE_EXTRA_INSTALL ?= ""
PACKAGE_EXCLUDE_COMPLEMENTARY = "gstreamer|libgst|packagegroup-multimedia"

IMAGE_FEATURES += "${OSTRO_XT_IMAGE_EXTRA_FEATURES}"
IMAGE_INSTALL += "${OSTRO_XT_IMAGE_EXTRA_INSTALL}"

# Add Thermal daemon for intel-corei7-64
IMAGE_INSTALL_THERMAL_DAEMON = ""
IMAGE_INSTALL_THERMAL_DAEMON_intel-corei7-64 = "thermald"
IMAGE_INSTALL += "${IMAGE_INSTALL_THERMAL_DAEMON}"

# in order to make the image build succeed, you'll probably need to disable
# all out-of-tree kernel modules because new kernel breaks the directory
# needed for building out of tree modules
#OSTRO_IMAGE_EXTRA_INSTALL_remove = " \
#    backport-iwlwifi \
#"

# add package of Joule hardware specific udev rules
IMAGE_INSTALL += "joule-udev-rules"
