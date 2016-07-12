#
# https://ostroproject.org/jenkins CI configuration:
# This file applied via conf/auto.conf for every build
# happening in Ostro Project CI
#

#
# Static section
# Items that are always present in any CI build:
#

# Generate summary statistics
INHERIT += "buildstats-summary"

# Enable CVE and other secutiry checks
INHERIT += "isafw"

# Enable extended buildhistory:
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"
INHERIT += "buildhistory-extra"

# Test data generation:
INHERIT += "test-iot"
TEST_EXPORT_DIR = "iottest"
TEST_TARGET = "simpleremote"

# SDK defaults:
SDKMACHINE ?= "x86_64"

# Generate source mirror tarballs:
BB_GENERATE_MIRROR_TARBALLS = "1"

# Configure images in "development mode".
require conf/distro/include/ostro-os-development.inc

OSTRO_VM_IMAGE_TYPES = "dsk.xz dsk.ova dsk.bmap dsk.xz.sha256sum"

# Automated build targets
# These targets must be space-separated lists of items.
# Valid symbols are: alphanumeric ones,'-' and '_'.
# The parser will skip everything else.
#
# Target(s) for the default build:
OSTROPROJECT_CI_BUILD_TARGETS=" \
  ostro-xt-image-noswupd \
  ostro-xt-image-noswupd-benchmark-qa \
  ostro-xt-image-swupd \
"

# Following targets will be executed with do_populate_sdk
# resp. do_populate_sdk_ext task. In Ostro OS XT, all images
# full-featured, so it does not matter whether we pick swupd
# or noswupd here.
OSTROPROJECT_CI_SDK_TARGETS="ostro-xt-image-noswupd"
OSTROPROJECT_CI_ESDK_TARGETS="${OSTROPROJECT_CI_SDK_TARGETS}"

# Including debug packages increases the size of the
# ostroxt-x86_64-corei7-64-toolchain-1.0+snapshot.sh by more than 2x.
# Therefore we don't use them.
SDKIMAGE_FEATURES_remove = "dbg-pkgs"

# Target(s) for the task "do_test_iot_export":
OSTROPROJECT_CI_TEST_EXPORT_TARGETS="ostro-xt-image-swupd"

# Automatic tests. Entries are separated by spaces.
# Each entry is a tuple, in the format:
# <image_name>,<testsuite_name>,<testfiles_name>,$MACHINE

OSTROPROJECT_CI_TEST_RUNS=" \
  ostro-xt-image-swupd,iot-testsuite.tar.gz,iot-testfiles.${MACHINE}.tar.gz,${MACHINE} \
"

# In the CI system, the integer OS version used for swupd is
# derived from the Jenkins build number part of the BUILD_ID.
# The conversion to int and back to string acts as sanity
# check that we really get a number out of the BUILD_ID.

#
# BUILD_ID is expected to have this format:
# BUILD_ID = "<parent-build-timestamp (of Jenkins top job)>" + "-build-" + "<jenkins-top-job-build-number>"
#
# We multiply it by ten, to ensure that the version space has
# some gap for minor updates. How to actually build minor updates
# with Jenkins still needs to be determined.
OS_VERSION ?= "${@ str(int('${BUILD_ID}'.split('-')[-1]) * 10) }"

#
# Dymamic section.
# The values are applied dynamically based either on runtime config or on
# builder host parameters. It is present exclusively as reference.
#

# Explicit machine declaration by build job:
# MACHINE = "$TARGET_MACHINE"

# Shared download directory between builders:
# DL_DIR = "/srv/bb-cache/ostro-os/sources"

# Limit CPU utilization, based on amount of slots/CPU cores
# on builder hosts:
# BB_NUMBER_PARSE_THREADS = "X"
# BB_NUMBER_THREADS = "X"
# PARALLEL_MAKE = "-j X"

# Local optimizations on SSTATE directories, shared between builder hosts:
# SSTATE_MIRRORS ?= "file://.* http://$IP/bb-cache/ostro-os/sstate/PATH"
# SSTATE_DIR ?= "/var/tmp/sstate-$slot"

# Local directory, where builder puts local copy of buildhistory
# BUILDHISTORY_DIR ?="$WORKSPACE/buildhistory"

# PRserv host dynamically allocated by master:
# PRSERV_HOST = "$IP:$PORT"

# Enabled for master release builds:
# INHERIT += "archiver"
# ARCHIVER_MODE[src] = "original"
# ARCHIVER_MODE[diff] = "1"
# ARCHIVER_MODE[recipe] = "1"
