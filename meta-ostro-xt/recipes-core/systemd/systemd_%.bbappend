FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
                  file://sleep.conf \
                 "

do_install_append() {

    # Configure logind to suspend upon Power Key press. The desired (and
    # the only possible on this platform) suspend state is 'freeze'. Be
    # explicit about that setting by adding it in sleep.conf.
    if ${@bb.utils.contains('PACKAGECONFIG', 'logind', 'true', 'false', d)}; then
        install -m 0644 ${WORKDIR}/sleep.conf ${D}${sysconfdir}/systemd/
        sed -i -e 's/.*\(HandlePowerKey=\).*/\1suspend/g' ${D}${sysconfdir}/systemd/logind.conf
    fi

    # systemd-logind checks whether /sys/power/state is writable but
    # gets 'no' because the SMACK label it runs (System) is not allowed
    # to write to floor label the file has. The process runs with a
    # reduced capability set but we additionally need CAP_MAC_OVERRIDE to
    # bypass SMACK MAC enforment to get suspend working.
    #
    # The actual write to /sys/power/state happens in systemd-sleep
    # (from systemd-suspend.service) that runs unlimited capabilities.
    if ${@bb.utils.contains('DISTRO_FEATURES', 'smack', 'true', 'false', d)}; then
        sed -i -e 's/^CapabilityBoundingSet=/CapabilityBoundingSet=CAP_MAC_OVERRIDE /' ${D}${systemd_unitdir}/system/systemd-logind.service
    fi
}

CONFFILES_${PN}_append = " \
                         ${sysconfdir}/systemd/sleep.conf \
                         "
