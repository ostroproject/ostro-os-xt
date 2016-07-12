SUMMARY = "Ostro OS XT image with swupd enabled."

# Image configuration changes cannot be done using the
# _pn-ostro-image-swupd notation, because then the configuration of
# this base image and the virtual images created from it would be
# different.
#
# Instead extend these variables to extend the common base OS
# (aka os-core in swupd terminology) that must be present at
# all times. Most of the base OS is already defined in
# ostro-xt-image.bbclass and thus the same as in the images
# without swupd.
OSTRO_XT_IMAGE_SWUPD_EXTRA_FEATURES ?= ""
OSTRO_XT_IMAGE_SWUPD_EXTRA_INSTALL ?= ""

IMAGE_FEATURES += "${OSTRO_XT_IMAGE_SWUPD_EXTRA_FEATURES}"
IMAGE_INSTALL += "${OSTRO_XT_IMAGE_SWUPD_EXTRA_INSTALL}"

# Enable swupd.
IMAGE_FEATURES += "swupd"

# os-core content and the additional bundle for benchmarking and qa
SWUPD_BUNDLES ?= " \
  benchmark-qa \
"

# BUNDLE_CONTENTS currently cannot be empty although that would be valid
# when BUNDLE_FEATURES is set. Work around that for now by adding something
# which is already in the os-core.
BUNDLE_CONTENTS[benchmark-qa] = "base-files"
BUNDLE_FEATURES[benchmark-qa] = " \
  benchmark \
  qatests \
"

# Inherit the base class after changing relevant settings like
# the image features, because the class looks at them at the time
# when it gets inherited.
inherit ostro-xt-image
