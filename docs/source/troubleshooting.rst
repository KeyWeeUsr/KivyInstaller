Troubleshooting
===============

This section provides solutions to the known problems a user could encounter
while using the KivyInstaller.

Update from v1.0
----------------

KivyInstaller 1.0 didn't have an option for self-updating, therefore
``update_v1.bat`` is available for manual updating to the latest version which
has this kind of updating implemented. Copy ``update_v1.bat`` inside folder
with ``kivy.bat`` and run it.

If anything goes wrong, there will be ``update_v1.log`` file available. After
successful update you can remove the updating file(s).

For anyone who would clone whole repo - updater will not run if your version
isn't ``1.0``. If it annoys you, remove it.

Known problems
--------------

- Can't download Python ``.msi`` - probably missing ``bitsadmin``_, run ``cmd``
  and ``bitsadmin``. If available and still not downloading, |iss|_.

- Python installation doesn't work - |iss|_ with ``msi.log`` from your folder.

- ``w9xpopen.exe`` error - Python ``.msi`` installer is broken. Delete it,
  KivyInstaller will download a fresh one.

- Whatever "Internet security" error for ``nul`` and ``extrapath`` displayed in the
  details **is not an error**. The statement only makes an empty file for an
  extra path, ignore it.

- |msvcr|_ is missing. You need to download it.

Report an issue
---------------

If you experience any problems, |iss|_ in the github repo.

.. |iss| replace:: report an issue
.. |msvcr| replace:: msvcr100.dll
.. _iss: https://github.com/KeyWeeUsr/KivyInstaller/issues
.. _msvcr: https://www.microsoft.com/en-us/download/details.aspx?id=5555
.. _bitsadmin: https://www.microsoft.com/en-us/download/details.aspx?id=18546
