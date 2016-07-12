Features
========

This section shows all available packages after successful installation
together with features the KivyInstaller provides.

Packages
--------

- docutils
- Kivy-Garden
- pip
- Pygments
- PyInstaller
- pypiwin32
- requests
- setuptools
- wget
- wheel

Extra PATH
----------

Since ``1.4`` there is a new empty file ``extrapath.kivyinstaller`` available
that provides a user an easy way to extend ``PATH`` without using ``set``
command manually on each run of ``cmd.exe`` or edit environment variables.

The PATH from ``extrapath`` file will be also available in every shortcut i.e.
`Quick Launch`, `Send To`, even `Taskbar` if you create shortcut for it
manually.

Usage
~~~~~

Just paste a new path as it is, without quotes or any other extra characters
into the file. The path separator for Windows is a `backslash` (``\``).

Example::

    C:\Users\John

For more paths, separate them with semicolon as in casual ``PATH`` setting::

    C:\Users\John;C:\Users\Guest

**Do not** end the line with a semicolon or write `multiple` lines. The file
works in a *single* line mode.

Shortcuts
---------

There's an option to allow creating shortcuts for your installation. Those will
be placed into two locations: ``Send to`` and ``Quick Launch``.

Running ``.py`` file with ``Send to`` option works on WinXP and higher, however
taskbar shortcut works only on WinXP and WinVista. The taskbar item runs either
as a console, or uses a file that can be drag&dropped to it. The shortcut will
run the file directly as if ``python.exe`` was called.

Useful for running snippets of code from your desktop. Shortcuts are removed
together with all other data after ``kivy uninstall``.

Win7+
~~~~~

On Windows 7 and higher the taskbar has a different functionality than original
``Quick Launch``, therefore a bad workaround is to drag&drop a manually created
shortcut for ``kivy.bat`` to the taskbar, however script drag&dropping won't
work this way.

To make drag&dropping work, |QLenable|_ in your system.

.. |QLenable| replace:: re-enable ``Quick Launch``
.. _QLenable: http://www.howtogeek.com/howto/windows-7/\
   add-the-quick-launch-bar-to-the-taskbar-in-windows-7/
