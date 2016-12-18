Troubleshooting
===============

This section provides solutions to the known problems a user could encounter
while using the KivyInstaller.

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
