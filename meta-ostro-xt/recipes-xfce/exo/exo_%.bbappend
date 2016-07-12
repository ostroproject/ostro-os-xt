do_install_append() {
   if [ -f ${D}${datadir}/applications/exo-web-browser.desktop ]; then
     rm ${D}${datadir}/applications/exo-web-browser.desktop
   fi
   if [ -f ${D}${datadir}/applications/exo-mail-reader.desktop ]; then
     rm ${D}${datadir}/applications/exo-mail-reader.desktop
   fi
}
