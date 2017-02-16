Usage
=====

This section explains how to install Kivy on any Windows from scratch and how
to use existing python installation as a base for KivyInstaller.

For more details use ``kivy help`` after successful installation.

Installation
------------

#. Create a folder for your Python and place ``kivy.bat`` inside.

    - Alternatively, clone whole KivyInstaller repo and Python will be
      installed there. ``git clone
      https://github.com/KeyWeeUsr/KivyInstaller``

    - Or use command line instructions::

       mkdir python
       bitsadmin /transfer "GetBatch" "https://git.io/vDDjn" "%cd%\kivy.bat"
       cd python

#. Run ``kivy.bat`` and select your Python and Kivy versions.

    - To select y/n you have to type and press ``enter`` (``return``).

#. Enjoy!

``kivy.bat`` after successful installation behaves as a normal ``cmd.exe``
console with all important stuff set.
   
If cloned from repo and installed as non-admin, ``git clean -dxf`` returns the
clone to its original state (removes installation).

.. note:: You can delete ``.msi`` after installation. KivyInstaller will
   download the ``.msi`` file if there's no available when needed.

Install to existing Python
--------------------------

#. Copy/clone ``kivy.bat`` to your folder with ``python.exe`` and run it.
#. Choose your installed Python architecture version (32bit / 64bit).
#. Select which Python is installed (2.x / 3.x).
#. Best to ignore registering extensions with ``n`` answer. It won't work
   anyway because Python is already installed.
#. Choose Kivy version.
#. Enjoy!

.. note:: If you plan to use all features of KivyInstaller(``kivy uninstall``
   mainly), you need to change Python version(`py2`/`py3`) in `config` file to
   the same version you use. Otherwise it may cripple your Python with the
   ``uninstall`` option.

Update
------

KivyInstaller uses Kivy wheels for installation:

- ``stable`` on `pypi <https://pypi.python.org/pypi/Kivy/1.9.1>`_
- ``master`` on |master_drive|_

To update already installed Kivy use one of these commands::

    kivy update
    kivy updatemaster

To update KivyInstaller to the latest version use ``kivy batupdate``. The batch
will automatically download the new version and back up the current one to
``backup_kivy.bat`` file. If the update fails, replace ``kivy.bat`` with the
backup file.

Pack
----

Since version ``1.3`` KivyInstaller provides a quick way to create a package
for Windows with ``--debug`` option on to test if packaging Kivy works.

::

    kivy pack "<path>"

This way doesn't support other options such as ``--name`` or ``--icon`` and it
is only for debugging. The name of ``.exe`` file is taken from the parent
folder of ``.py`` file.

.. note:: For more options use ``pyinstaller`` directly.

Uninstall
---------

There's an option to remove Python with Kivy and other installed packages +
cached pip files. However, this option works only if the whole path to folder
with Python is the same as used during installation - i.e. it partially relies
on MSI Python installer.

Another option is using ``kivy remove`` command to remove Kivy installation
only. The conditions are the same as for previous option.

.. |master_drive| replace:: google drive
.. _master_drive: https://drive.google.com/folderview?\
   id=0B1_HB9J8mZepOV81UHpDbmg5SWM&usp=sharing
