Getting started
===============

.. warning:: This batch isn't for compiling! (May change in future.)

KivyInstaller works with ``pip`` and gets Kivy from ``.whl`` files. It supports
32bit and 64bit Python versions, so you can easily download the one you need.

The complete installation of Python with Kivy ``master`` branch takes
approximately 3 minutes (even less!) of automated process. This |installvid|_
will surely convince you.

Of course the installation highly depends on your machine, internet speed and
connection.

Defaults
--------

- Python versions ``2.7.11``, ``3.4.4``
- kivy-master ``1.9.2``

Change them freely inside batch file if you need.

Admin installation catch
------------------------

With MSI installers there's one catch. Each of them has a `Product code` for
various reasons. For KivyInstaller it means you can install Python from the
same installer that requires admin rights only once.

MSI basically creates some stuff in registry for your Python installation
including copy-pasting its `Product code`. With each attempt to install with
the same installer it looks for the `Product code` in registry before
installing, therefore if the same `Product code` is found, it'll behave as
a repair / remove tool for your Python.

.. note:: There's an option to change `Product code` with some free tools and
   install Python manually with modified ``.msi``.

Multiple Pythons
~~~~~~~~~~~~~~~~

`Product code` of MSI installers doesn't affect having Python 2 and Python 3 at
the same time in separate folders.

Using lower / higher version is a workaround for the MSI catch, i.e. if
``2.7.11`` is installed, the another allowed version would be for example
``2.7.10``.

You have to change the version in ``kivy.bat``'s variable directly.

Non-admin installation
----------------------

When installation without admin rights is chosen, there is no limitation for
the same Python version on a single OS, yet a glitch may appear during the
installation such as leaving some Python stuff inside ``kivy`` folder.

If the files / folders left behind are only ``Doc`` or ``tcl``, just copy&paste
them. Otherwise remove everything except ``kivy.bat`` and ``.msi``, then
reinstall.

.. note:: It may occur that MSI installer becames broken for non-admin type
   of installation. In this case the installer needs to be completely removed
   and redownloaded.

.. |installvid| replace:: video
.. _installvid: https://youtu.be/ch_ILDBEaok
