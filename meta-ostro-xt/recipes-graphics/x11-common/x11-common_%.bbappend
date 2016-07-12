# Both xtscal (current OE) and xinput-calibrator (the designated successor,
# see "[OE-core] [PATCH 2/4] x11-common: replace xtscal with xinput-calibrator")
# are of uncertain code quality. As we don't have a need for them in Ostro OS XT,
# we simply install neither.
RDEPENDS_${PN}_remove = "xtscal xinput-calibrator"
