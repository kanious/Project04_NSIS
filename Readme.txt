< Installation files >
install_Yoon_Jihye.exe		: Install File
valid email address.txt		: x10 valid emails
				  Use this when you need to enter email
verification.txt		: x10 hashed strings to verify email

* You can find all files to make install file in the InstallFiles folder.


< Installed files >
-- in the installation folder
3DScene.exe			: Application execution file
*.dll				: DLL files needed to run the application
Assets Folder			: Data folder needed to run the application
uninstaller.exe			: Uninstall file
bg.bmp				: An image installed when user check extra section

-- in the Desktop
Yoon_Jihye_3DScene.exe.lnk	: a shortcut file to run 3DScene.exe
Yoon_Jihye_uninstaller.exe.lnk	: a shortcut file to uninstall


< Uninstall Process >
The list of files to be installed was collected first through the "BrowsingDirectory" function of the UninstallLog.nsh file.
  (This "BrowsingDirectory" function is not run during real install process)
The list is saved to the "filelog.txt" file located in install folder.
When user runs uninstaller, it will erase only the files listed in the "filelog.txt"
If user added some personal files in the install directory, they will not be deleted and directories as well.



GitHub Link:
https://github.com/kanious/Project04_NSIS

