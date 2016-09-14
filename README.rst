Building Ostro (TM) OS XT
#########################

Introduction
============

Ostro (TM) OS XT is an "eXTended" Linux* distribution derived from Ostro OS.
It differs from Ostro OS in several ways. Ostro OS XT:

* targets a specific device based on a Broxton SOC
* enables X11 and the XFCE desktop environment
* adds support for certain hardware features (`RealSense`_, `OpenCV`_, `OpenCL`_)
* adds extra tools and libraries (for example, `clang`_)

.. _RealSense: http://www.intel.com/content/www/us/en/architecture-and-technology/realsense-overview.html
.. _OpenCV: http://opencv.org/
.. _OpenCL: https://www.khronos.org/opencl/
.. _clang: http://clang.llvm.org/

This document gives instructions on how to use this repository and build an Ostro (TM) OS XT
image.

Installing Docker on Linux
==========================

You’ll need Docker installed to build locally. Using Docker provides
a packaged and controlled environment for building an Ostro OS XT
image, eliminating development environment issues that
can occur with differing Linux OS distros and versions, different host
compilers, and such. (There are instructions later below for building
without Docker.)

Instructions for installing Docker for common Linux distros on your
development machine (including Fedora and Ubuntu) are available at:
https://docs.docker.com/engine/installation/linux

.. _Optional Docker Configuration: https://docs.docker.com/engine/installation/linux/ubuntulinux/#Optional%20Configurations
.. _configure the DNS server for Docker: https://docs.docker.com/engine/installation/linux/ubuntulinux/#configure-a-dns-server-for-use-by-docker

Follow the instructions for your particular distro. You should also
perform some of listed `Optional Docker Configuration`_ settings:

-   Add your Linux user account into the Docker system group with::

    $ sudo gpasswd -a ${USER} docker
    
    You’ll need to log out and back in for this change to take effect.

-   Inside company firewalls, you’ll need to configure proxies. Follow the
    instructions for Docker at
    https://docs.docker.com/engine/admin/systemd/#http-proxy
    and also set the usual environment variables::
 
    $ export http_proxy=http://proxy.example.com:<port>
    $ export https_proxy=https://proxy.example.com:<port>
    $ export ALL_PROXY=socks://proxy.example.com:<port>

-   Some distributions such as Ubuntu require you to manually
    `configure the DNS server for Docker`_.
    This can be done by adding ``--dns <dns-server-ip-address>``
    to the Docker daemon startup parameters in ``/etc/default/docker``.
    (Check your ``/etc/resolv.conf`` file for system’s specific
    DNS settings.) More information is available here (note that
    Ubuntu 15.10 and later use ``systemd``):
    
    -   https://docs.docker.com/engine/admin/configuring/
    -   https://docs.docker.com/engine/userguide/networking/configure-dns/

Building with Docker
====================

These instructions assume you’ll be working with the sources in a
`~/work/ostro-os-xt` directory that you’ll be creating.

Start by cloning the GitHub repos. If you have a previous copy of this
repository without all the submodules, it would be best to remove all
the content of workspace directory and clone it again::

$ export WORKSPACE=$HOME/work/ostro-os-xt
$ mkdir -p $WORKSPACE
$ cd $WORKSPACE
$ git clone --recursive https://github.com/ostroproject/ostro-os-xt .
$ source ostro-init-build-env


When Docker is configured properly and all project code is cloned and
available locally, it's time to trigger a build. To do this run the
command from within the ``~/work/ostro-os-xt`` directory::

$ docker/local-build.sh

Building without Docker
=======================

While not recommended, you can also use Yocto Project bitbake directly.
(Any issues you encounter building this way might not be easily
reproducible and debuggable by other developers using a different
distribution.)

Here are the basic steps::

$ export WORKSPACE=$HOME/work/ostro-os-xt
$ mkdir -p $WORKSPACE
$ cd $WORKSPACE
$ git clone --recursive https://github.com/ostroproject/ostro-os-xt .
$ source ostro-init-build-env
$ bitbake ostro-xt-image-noswupd

Updating Repositories
=====================

You may need to pull new content from the GitHub repo as it’s updated.
Use the following commands::

$ git pull
$ git submodule update

For more information about Git submodule commands, check this link: 
https://git-scm.com/docs/git-submodule

Installation onto platform's internal storage
=============================================

By default, the generated images contain an installer script that lets you
(optionally) flash internal storage or continue to boot a live system from
the USB stick. 

The installer
waits for user's input from the serial console. If there's no input for
15 seconds, the installer skips and the boot process continues with a live
system boot on the USB stick.

**Warning**: Once booted as a live system, the USB stick's installer
functionality is disabled.

Customizing installation media
==============================

You can configure an installation USB stick by placing special-named
files onto its first FAT partition, for example by using the File Explorer
on a computer running Windows* or Linux*.

- You can **make the installer non-interactive** by creating an empty
  file on the first FAT partition named either ``non-interactive-install``
  or ``non-interactive-install.txt``.  This will eliminate the installer check
  delay and proceed directly to a live boot from the USB stick.

- You can **enable remote ssh access** to the device by placing a file named
  ``authorized_keys`` on the first FAT partition of the
  USB stick with the public keys of users that may have remote root ssh access.
  Multiple authorized keys are permitted, one per line. (You can read more about
  authorized keys in the Ostro OS documentation at
  https://ostroproject.org/documentation/howtos/authorized-keys.html.)

After you've made changes to the USB stick, eject the USB stick gracefully before
unplugging to avoid image corruption.
