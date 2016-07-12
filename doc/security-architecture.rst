.. _security-architecture:

Ostro |trade| OS XT Security Architecture
#########################################

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

Ostro OS XT follows the security architecture described in the `Ostro
OS system and security architecture`_ document. The security
architecture for the additional features added to Ostro OS XT are described below.

Ostro OS XT supports two primary use cases:

* Using the provided images as prototyping and development platforms,
  with the "hacker community" as the initial target audience and
  a single user per device.
* Building custom images with a configuration and content that is chosen
  by a third-party product developer.

All provided Ostro OS XT images are explicitly produced in "development
mode", with remote access enabled as explained in the `Ostro OS system
and security architecture`_ document. It should be noted that the IMA/EVM
feature enabled in Ostro OS is disabled in Ostro OS XT images.

It is the responsibility of the product developers to choose
configuration and content of their custom image so that it meets their
needs.

.. _Ostro OS system and security architecture: https://ostroproject.org/documentation/architecture/system-and-security-architecture.html#production-and-development-images

Graphical User Interface
========================

By default, Ostro OS XT supports a GUI based on the XFCE4 Desktop
Environment on top of X Window System (X11). Normally Ostro OS devices
boot to ``multi-user.target``, but Ostro OS XT can boot to ``graphical.target``,
which then starts the GUI. There will not be a login screen; 
the desktop environment is presented directly on the screen.

The system is designed as a development platform and therefore the
graphical interface runs directly as the root user. Conceptually it is
like remote root access via ssh, except that it supports an xterm, a
windowing system, and can run graphic applications directly on the
local hardware.

Intel XDK
=========

Ostro OS XT supports Intel XDK. On the device, a component called
``xdk-daemon`` advertises the device over multicast DNS so that the XDK IDE
running on a development computer in the same network can find the device. The
XDK IDE then sends Node.js code to ``xdk-daemon``, which executes it on the
device.

The connection between Intel XDK and ``xdk-daemon`` is made over sftp (see
https://software.intel.com/en-us/connecting-to-your-iot-device-securely
for details). Using Intel XDK means that ssh must be enabled and the
authentication key must be set to Intel XDK. The code executed on the
device is run with root privileges, behaving the same way as if the code
was transferred to the device with scp and then executed from ssh shell.
