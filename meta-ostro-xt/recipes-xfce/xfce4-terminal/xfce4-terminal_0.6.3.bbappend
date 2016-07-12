# xfce4-terminal requires termcap file installed.
# The fix has been submitted upstream in https://patchwork.openembedded.org/patch/127695/
RDEPENDS_${PN} += "vte9-termcap"
