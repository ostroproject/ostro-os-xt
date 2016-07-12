.. _security-threat-analysis:

Ostro |trade| OS XT Security Threat Analysis
############################################

Introduction
============

Ostro |trade| OS XT is an "extended" Linux* distribution derived from Ostro OS.
It differs from Ostro OS in several ways. Ostro OS XT:

* targets a specific device based on a Broxton SOC
* enables X11 and the XFCE desktop environment
* adds support for certain hardware features (`RealSense`_, `OpenCV`_, `OpenCL`_)
* adds tools and libraries (for example, `clang`_)

.. _RealSense: http://www.intel.com/content/www/us/en/architecture-and-technology/realsense-overview.html
.. _OpenCV: http://opencv.org/
.. _OpenCL: https://www.khronos.org/opencl/
.. _clang: http://clang.llvm.org/

Ostro OS XT supports two primary use cases:

* Using the provided images as prototyping and development platforms,
  with the "hacker community" as the initial target audience and
  a single user per device.
* Building custom images with a configuration and content that is chosen
  by a third-party product developer.

All provided Ostro OS XT images are explicitly produced in "development
mode", with remote access enabled as explained in the `Ostro OS system
and security architecture`_ document.

It is the responsibility of the product developers to choose
configuration and content of their custom image so that it meets their
needs.

.. _Ostro OS system and security architecture: https://ostroproject.org/documentation/architecture/system-and-security-architecture.html#production-and-development-images

Document Scope
--------------

This document describes the security threats that are specific to the
pre-compiled images provided by Ostro OS XT, focusing on the software
aspects. The threats listed in the `Ostro OS security threat
analysis`_ also apply, and are not repeated here again.

.. _Ostro OS security threat analysis: https://ostroproject.org/documentation/architecture/security-threat-analysis.html

We can only speculate about potential threats that may or may not be relevant 
in specific products built
from Ostro OS XT and so are therefore not
within the scope of this document.

Glossary
--------

See the `Ostro OS security threat analysis`_ glossary.

Security Principles
===================

The main principle is that the user of the device fully controls the
device and is allowed to do whatever he or she wants to do with
it. There are no security measures implemented specifically for Ostro
OS XT, not even for the new components.

The single user of the device is expected to log in as root and then
might (or might not) create a less privileged user account to work on the
device. This is not required, so the assumption is that all software
started by the user runs with full root privileges.

Top-Level Security Challenges
=============================

Adversaries
-----------

Same as described in `Ostro OS security threat analysis`_.

Assets
------

Same as described in `Ostro OS security threat analysis`_.

Attack surfaces
---------------

In general the same as described in `Ostro OS security threat analysis`_, but
it is possible to be more specific about some attack surfaces. In particular,
"connectivity services" supported by the hardware and the OS are:

* Bluetooth
* WLAN
* USB
* Serial port
* RealSense camera

The main new Ostro OS XT service running on the device, which increases the attack
surface, is X11 with XFCE (the user interface started as part of the
X11 session). Using X11 breaks away from the traditional Ostro OS
production model where there are no real users logged in to the
system, and all interaction happens through applications.

Ostro OS XT is more like the Ostro OS development images, where a
developer also has full interactive access as root. Ostro OS XT
adds X11 with xterm and a desktop and user interface for running programs.
The X11 session also runs as root user. In addition, Ostro OS XT completely
disables IMA/EVM.

Threats
-------

===== ================== ===================== ======================================================================
Name  Adversary          Asset                 Attack method and pre-conditions
===== ================== ===================== ======================================================================
Net-1 Network attacker   System data,          An attacker on the local network could attempt to connect to X11
                         application data      and if successful, access data shared between X11 applications
                                               (clipboard, keyboard input) or control applications from remote
                                               (simulate input).
App-1 Network attacker   Actuators             An attacker could run robotics code to seriously affect the physical
                                               environment in which the Ostro OS XT device resides.
App-2 Malicious          System data,          A malicious local user can use the X11 desktop to use the device.
      unauthorized       application data
      device user
App-3 Malicious          Sensor data,          A malicious local user can access the local network.
      unauthorized       local network
      device user
App-4 Malicious          System data,          A malicious local user can use the RealSense camera to trigger
      unauthorized       application data      unauthorized actions.
      device user
App-5 Network attacker   System data,          An attacker could compromise applications running inside the X11
                         application data      session.
App-6 Network attacker   System data,          A malicious network user can run malicious code from Intel XDK.
                         application data
Lib-1 Malicious          System data,          An attacker sends malformed data via the input ports of the device.
      unauthorized       application data
      device user




Threat details and mitigation
=============================

Net-1
-----

*Threat*:

Attacker on the local network connects to X11 server and accesses data
from applications or controls input.

*Solution*:

Do not expose X11 to the network. Ostro OS XT devices are single-user and
do not generally expect the graphical use to happen directly over
network. Use tunneling over ssh if network access to X11 is required.

App-1
-----

*Threat*:

There's a lot of robotics code included in Ostro OS XT. If a robotics
device runs Ostro OS XT, any serious vulnerabilities exploited by an
attacker can lead to attacker controlling the robot interfaces. This may
lead to serious physical harm to the Ostro OS XT device or its environment.

*Solution*:

This is in principle not different from any other actuator access. The
access needs to be limited so that only authorized services can access
the hardware interfaces, and for most applications, the
robotics libraries would be inoperable.

App-2
-----

*Threat*:

As Ostro OS doesn't support user management for real users (different from
running applications with separate UIDs), and there isn't a login screen for
X11. An attacker sitting in front of the Ostro OS XT device can access the device via
X11.

*Solution*:

Devices running Ostro OS XT images must be used only in secure environments
where attackers do not have physical access.

App-3
-----

*Threat*:

A device running the Ostro OS XT development image is intentionally
configured to be very open, for example no explicit login is needed to
use the X11 user interface.

That means that an attacker can use the device and from there, access
the local network. It's possible that the attacker can probe network
topology, connect to other services residing on the network, and
impersonate the authorized device use because from outside there is
no noticable difference.

*Solution*:

Limit the access the device has to the network and/or other
devices, for example, by only connecting it to a (W)LAN with outgoing
connections limited by a firewall.

App-4
-----

*Threat*:

One use case of the RealSense camera is to make it perform actions based
on the data that the camera captures. A malicious attacker could use this
in various ways to affect the way the system behaves. The exact
possiblities depend on the way the camera image processing is set up.

*Solution*:

Capture and process the RealSense camera data only in the application
context. Make sure the application accessing the camera doesn't have more
privileges than it needs to in order to perform its intended tasks.

*Extensions*:

If heavy image processing is required, consider setting resource
constraints to the container in which the RealSense camera application
runs to prevent making the system unusable due to CPU or memory load.

App-5
-----

*Threat*:

An attacker could compromise applications running inside the X11
application data session and then execute a similar attack as in
Net-1.

*Solution*:

Typical desktop applications are not provided and should never be
added and run on the device.

When adding and running applications, users need to take
the same care as on a desktop system: be careful about which
documents are opened with applications, do not expose applications
to outside input, etc.

App-6
-----

*Threat*:

An attacker executes a malicious Node.js script from Intel XDK via
xdk-daemon running in the system.

*Solution*:

Intel XDK uses sftp to transfer files to the system. Everything that
xdk-daemon executes is treated as if the code was executed
directly as root from an ssh shell. The authentication security is the
same.

Lib-1
-----

*Threat*:

An attacker with physical access to or in the proximity of a device
can connect to the device with or without cables and try to
trigger bugs in the input handling on the device to gain access
or obtain information.

*Solution*:

The entire software stack starting with the Linux kernel and up to
the services handling the attacker's data must be resilient
against malformed data and reject it. The software stack must also reject
unauthorized access.

Threats and Attack Vectors Out of Scope for Ostro OS XT
=======================================================

* OpenCL-based DoS of X11
* Preventing an Ostro OS XT-based robot from damaging itself
* Filesystem integrity protection
