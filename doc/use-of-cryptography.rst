.. _use-of-cryptography:

Use of Cryptography in Ostro |trade| OS XT
##########################################

This document explains how cryptography is used in Ostro |trade| OS XT.
Everything described in the `Ostro OS certificate handling`_
document also applies to Ostro OS XT.

.. _Ostro OS certificate handling: https://ostroproject.org/documentation/howtos/certificate-handling.html

Secure Boot
-----------

Secure Boot is not enabled, i.e., the BIOS will not control which OS it
boots and the pre-compiled images do not need to be signed. In addition,
unlike regular `Ostro OS development images`_, Ostro OS XT disables `IMA/EVM`_.

.. _Ostro OS development images: https://ostroproject.org/documentation/architecture/system-and-security-architecture.html#production-and-development-images
.. _IMA/EVM: https://ostroproject.org/documentation/howtos/certificate-handling.html#imaevm-and-image-signing
