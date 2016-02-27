# KivyInstaller
A short batch to simplify installing and updating kivy on Windows. When installed, `kivy.bat` provides info about python, kivy, kivy wheel versions.
Defaults: python versions `2.7.11` `3.4.4`, kivy-master `1.9.2`. Change them freely inside batch file if you need.
### How to use
##### Installation
- Create a folder for your python and place `kivy.bat` inside.
- Run `kivy.bat`, select your python and kivy versions, wait.
- Enjoy!

##### Update
Batch uses kivy wheels for installation, it means: for stable pypi and for master google drive

###### stable
- `kivy update`

###### master
- `kivy updatemaster`

##### Uninstall
There's an option to remove python with kivy and other packages + cached pip files. However, this option works only if the whole path to folder with python is the same as used during installation - ie it relies on `.msi` python installer partially. You can delete msi after installation. If batch needs the msi, it'll download it.

### Tip
- Close `Touchtracer` example after installation with `Escape`, not with the "red X". X seems to prevent changing `first` in `kivy.bat`

### Problems
If you experience problems, use `issues` in this repo.
- can't download python `.msi` - probably missing [bitsadmin](https://www.microsoft.com/en-us/download/details.aspx?id=18546), run cmd and `bitsadmin`. If available and still not downloading, report issue.
- python installation doesn't work - `msi.log` from your folder is needed.
- [msvcr100.dll](https://www.microsoft.com/en-us/download/details.aspx?id=5555) is missing
