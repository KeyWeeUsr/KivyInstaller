# KivyInstaller
### Summary
Everyone can mess things up even with simple installation or update. In version `1.8.0` there was a batch file for making things easier for beginners or regular users, but this file disappeared as the wheel came in. KivyInstaller is inspired by this `kivy.bat` file from old portable package with multiple new functions:
- Install python2/python3 with kivy stable or master.
- Update kivy stable, master or change version (stable<-->master).
- Update itself (in case of new features, bug fixes).
- Create Kivy applications package for Windows
- Uninstall kivy and python.
- All needed versions for debugging at one place.

###### This batch isn't for compiling!
Batch works with `pip` and builds from `.whl` files. KivyInstaller supports Windows 32bit and 64bit, you can easily download version you need. However, there's one catch. MSI Installers have a `Product code` for various reasons, for us it means you can install only one python with same build version x.x.B(the third number).

You can change `Product code` with some free tools and install python manually with modified `.msi` however. Workaround also seems to be using lower/higher build version, i.e. if you installed `2.7.11`, the another version would be `2.7.10` or `2.7.12`. You have to change build version in `kivy.bat`

`Product code` of msi doesn't affect having python2 and python3 at the same time in separate folders.

Defaults: python versions `2.7.11` `3.4.4`, kivy-master `1.9.2`. Change them freely inside batch file if you need.
### How to use
##### Installation
- Create a folder for your python and place `kivy.bat` inside.
    - Alternatively, clone whole KivyInstaller repo with `git clone https://github.com/KeyWeeUsr/KivyInstaller`, python will be installed there.
- Run `kivy.bat`, select your python and kivy versions, wait.
    - To select y/n you have to type and press `enter`(`return`).
- Enjoy!

##### Install to existing python
- Copy/clone `kivy.bat` to your folder with `python.exe` and run it.
- Choose your installed python architecture version (32bit/64bit).
- Select which python is installed (2.x/3.x).
- Best to ignore registering extensions with `n` option, it won't work anyway because python is already installed.
- Choose kivy version.
- Enjoy!
+ If you plan to use all features of KivyInstaller(`uninstall` mainly), you need to change python version(`py2`/`py3`) in `config` file to the same version you use. Otherwise it may cripple your python with `uninstall` option.

##### Update
Batch uses kivy wheels for installation, it means: for stable [pypi](https://pypi.python.org/pypi/Kivy/1.9.1) and for master [google drive](https://drive.google.com/folderview?id=0B1_HB9J8mZepOV81UHpDbmg5SWM&usp=sharing).

###### stable
- `kivy update`

###### master
- `kivy updatemaster`

###### kivy.bat
- `kivy batupdate`

For more details use `kivy help` after successful installation.

##### Pack
Since version `1.3` KivyInstaller provides a quick way to create a package for Windows with `--debug` option on.
- `kivy pack "<path>"`

This way doesn't support other options such as `--name` or `--icon` and is only for debugging. Name of `.exe` is taken from parent folder of `.py`. For more options use `pyinstaller` directly.

##### Uninstall
There's an option to remove python with kivy and other packages + cached pip files. However, this option works only if the whole path to folder with python is the same as used during installation - i.e. it relies on `.msi` python installer partially. You can delete msi after installation. If batch needs the msi, it'll download it.

Another option is using `kivy remove` command to remove kivy installation only. The conditions are the same as for previous option.

##### Packages & Features
###### Python packages
- docutils
- kivy-garden
- pip
- pygments
- pyinstaller
- pypiwin32
- requests
- setuptools
- wget
- wheel

###### Shortcuts
Running `.py` file with `Send to` option works on WinXP+, however taskbar shortcut works only on WinXP and WinVista. The taskbar item runs either as a console, or a file can be drag&dropped to it and it'll run the file directly. Useful for running snippets of code from your desktop. Shortcuts are created automatically after installation and removed together with all other data after `kivy uninstall`.

Win7+ taskbar has a different functionality than original `Quick Launch`, therefore a bad workaround is to drag&drop a manually created shortcut for `kivy.bat` to the taskbar, however script drag&dropping doesn't seem to work anyway. The better one is [re-enabling](http://www.howtogeek.com/howto/windows-7/add-the-quick-launch-bar-to-the-taskbar-in-windows-7/) `Quick Launch` in your system, then the script drag&drop works.

### Attention KivyInstaller v1.0 users!
- Version 1.0 didn't have an option for self-updating, therefore `update_v1.bat` is available for manual updating to the latest version which has this kind of updating implemented. Copy `update_v1.bat` inside `kivy.bat` folder and run it.
- If anything goes wrong, there will be `update_v1.log` file available. After successful update you can remove it.
- For anyone who would clone whole repo - updater will not run if your version isn't `==1.0`. If it annoys you, remove it.

### Problems
If you experience problems, use `issues` in this repo.
- can't download python `.msi` - probably missing [bitsadmin](https://www.microsoft.com/en-us/download/details.aspx?id=18546), run cmd and `bitsadmin`. If available and still not downloading, report issue.
- python installation doesn't work - `msi.log` from your folder is needed.
- [msvcr100.dll](https://www.microsoft.com/en-us/download/details.aspx?id=5555) is missing