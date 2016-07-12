.. _privacy-design:

Ostro |trade| OS XT Privacy Design
##################################

The Ostro |trade| OS XT privacy design is the same as in Ostro OS itself, as
described in the `privacy design`_ section of the general architecture
document.

.. _privacy design: https://ostroproject.org/documentation/architecture/system-and-security-architecture.html#privacy-design

From the perspective of that design, everything running inside an X11
session is considered a single application, using the same Unix
user ID. There is no separation between individual applications once
they get access to a shared interactive X11 session.

What personal information gets stored inside such an interactive
session is entirely up to the user of the device. But it is not
expected to be used as a replacement for a personal compute device, so
there are no mechanisms in place that force the user to enable
protection mechanisms. For example, there is no first-boot password or
user setup dialog.
