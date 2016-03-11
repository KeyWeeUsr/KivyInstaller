# KivyInstaller
### Summary
Everyone can mess things up even with simple installation or update. In version `1.8.0` there was a batch file for making things easier for beginners or regular users, but this file disappeared as the wheel came in. KivyInstaller is inspired by this `kivy.bat` file from old portable package with multiple new functions:
- Install python2/python3 with kivy stable or master.
- Update kivy stable, master or change version (stable<-->master).
- Update itself (in case of new features, bug fixes).
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

##### Update
Batch uses kivy wheels for installation, it means: for stable [pypi](https://pypi.python.org/pypi/Kivy/1.9.1) and for master [google drive](https://drive.google.com/folderview?id=0B1_HB9J8mZepOV81UHpDbmg5SWM&usp=sharing).

###### stable
- `kivy update`

###### master
- `kivy updatemaster`

###### kivy.bat
- `kivy batupdate`

For more details use `kivy help` after successful installation.

##### Install to existing python
- Copy/clone `kivy.bat` to your folder with `python.exe` and run it.
- Choose your installed python architecture version (32bit/64bit).
- Select which python is installed (2.x/3.x).
- Best to ignore registering extensions with `n` option, it won't work anyway because python is already installed.
- Choose kivy version.
- Enjoy!

##### Uninstall
There's an option to remove python with kivy and other packages + cached pip files. However, this option works only if the whole path to folder with python is the same as used during installation - ie it relies on `.msi` python installer partially. You can delete msi after installation. If batch needs the msi, it'll download it.

### Attention KivyInstaller v1.0 users!
- Version 1.0 didn't have an option for self-updating, therefore `update_v1.bat` is available for manual updating to latest version which has this kind of updating implemented. Copy `update_v1.bat` inside `kivy.bat` folder and run it.
- If anything goes wrong, there will be `update_v1.log` file available. After successful update you can remove it.
- For anyone who would clone whole repo - updater will not run if your version isn't `==1.0`. If it annoys you, remove it.

### Problems
If you experience problems, use `issues` in this repo.
- can't download python `.msi` - probably missing [bitsadmin](https://www.microsoft.com/en-us/download/details.aspx?id=18546), run cmd and `bitsadmin`. If available and still not downloading, report issue.
- python installation doesn't work - `msi.log` from your folder is needed.
- [msvcr100.dll](https://www.microsoft.com/en-us/download/details.aspx?id=5555) is missing