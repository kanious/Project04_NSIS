!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "UninstallLog.nsh"

!addplugindir "plugin"

var Dialog
var Text

!define MY_NAME "Yoon_Jihye"
!define PROGRAM_NAME "INFO6025_NSIS"

OutFile "install_Yoon_Jihye.exe"
InstallDir $DESKTOP\cnd
Name ${PROGRAM_NAME}

!define MUI_WELCOMEPAGE_TITLE  "Welcome To the ${PROGRAM_NAME}"
!define MUI_WELCOMEPAGE_TEXT "The force may be with you!$\r$\n$\r$\n$\r$\n\
	These pumpkins will guide you through the installation UI for ${PROGRAM_NAME}.$\r$\n$\r$\n\
	It is recommended that you close all other applications before starting Setup. \
	This will make it possible to update relevant system files without having to reboot your computer.$\r$\n$\r$\n\
	Click Next to continue."
	
!define MUI_WELCOMEFINISHPAGE_BITMAP "bg.bmp"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_LICENSEPAGE_CHECKBOX
!define MUI_ABORTWARNING
!define MUI_ABORTWARNING_TEXT "Would you like to quit the installation?"
!define MUI_UNABORTWARNING
!define MUI_UNABORTWARNING_TEXT "Would you like to quit the uninstallation?"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "License.txt"

Page custom EmailInfoGet EmailVerifying

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Function EmailInfoGet

	!insertmacro MUI_HEADER_TEXT "Email Verification" ""

	nsDialogs::Create 1018
	Pop $Dialog
	
	${If} $Dialog == error
		Abort
	${EndIf}
	
	${NSD_CreateLabel} 0 0 100% 28u "You can find the valid email address \
		in the text file. Activation will register the email address to this computer."
	${NSD_CreateLabel} 0 30u 100% 12u "Email address:"
	
	${NSD_CreateText} 0 43u 100% 12u "$5"
	Pop $Text

	nsDialogs::Show
	
FunctionEnd

Function EmailVerifying

	${NSD_GetText} $Text $4
	StrCpy $5 $4
	md5dll::GetMD5String $4
	Pop $4
	
	IfFileExists "verification.txt" +3
		MessageBox MB_OK "Missing verification file..."
		Abort
		
	SetFileAttributes "verification.txt" NORMAL
	FileOpen $3 "verification.txt" r
	StrCpy $1 -1
	
	GetLineCount:
		ClearErrors
		FileRead $3 $0
		IntOp $1 $1 + 1
		StrCpy $0 $0 -2
		Push $0
		IfErrors 0 GetLineCount
	
	Pop $0
	
	LoopRead:
		StrCmp $1 0 LoopDone
		Pop $0

		${If} $0 == $4
			Goto ValidInfo
		${Endif}
		
		IntOp $1 $1 - 1
		Goto LoopRead
	
	LoopDone:
		FileClose $3
		MessageBox MB_OK "This email is not a valid address. Terminate the installation."
		Quit

	ValidInfo:
		FileClose $3
		MessageBox MB_OK "Email verification success!"
	
FunctionEnd


Function WriteRegistry
	SetRegView 64
	WriteRegStr HKLM "Software\CND\${MY_NAME}" "Version" "1.0"
	WriteRegStr HKLM "Software\CND\${MY_NAME}" "Name" "INFO-6025"
	WriteRegStr HKLM "Software\CND\${MY_NAME}" "InstallPath" "$INSTDIR"
	WriteRegStr HKLM "Software\CND\${MY_NAME}" "EmailKey" "$5"
FunctionEnd


Function un.DeleteRegistry
	SetRegView 64
	DeleteRegValue HKLM "Software\CND\${MY_NAME}" "Version"
	DeleteRegValue HKLM "Software\CND\${MY_NAME}" "Name"
	DeleteRegValue HKLM "Software\CND\${MY_NAME}" "InstallPath"
	DeleteRegValue HKLM "Software\CND\${MY_NAME}" "EmailKey"
	DeleteRegKey HKLM "Software\CND\${MY_NAME}"
FunctionEnd


Section "Core Program" SecCore

	IfFileExists $INSTDIR\uninstaller.exe fileFound fileNotFound
	fileFound:
	MessageBox MB_OK "${PROGRAM_NAME} is already installed."
	Abort
	fileNotFound:
	
	MessageBox MB_OK "Please close ${PROGRAM_NAME} if it is running."

	##### Copy files
	SetOutPath $INSTDIR
	File /nonfatal /a /r "SrcFiles\"
	WriteUninstaller $INSTDIR\uninstaller.exe
	File "filelog.txt"
	#Push "SrcFiles"
	#call BrowsingDirectory
	
	##### Create shortcuts
	CreateShortcut "$DESKTOP\${MY_NAME}_3DScene.exe.lnk" "$INSTDIR\3DScene.exe"
	CreateShortcut "$DESKTOP\${MY_NAME}_uninstaller.exe.lnk" "$INSTDIR\uninstaller.exe"
	
	call WriteRegistry

SectionEnd


Section "Background Image" SecExtra

	SetOutPath $INSTDIR
	File bg.bmp
	
SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecCore ${LANG_ENGLISH} "Core files. All needed files to execute this application."
  LangString DESC_SecExtra ${LANG_ENGLISH} "A cute pumpkin image!"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} $(DESC_SecCore)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecExtra} $(DESC_SecExtra)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------


# uninstall section
Section "Uninstall"

	call un.DeleteFiles
	
	Delete $INSTDIR\Readme.txt
	Delete $INSTDIR\uninstaller.exe
	
	RMDir $INSTDIR\Assets\Mesh\Scene3DSound\Buildings
	RMDir $INSTDIR\Assets\Mesh\Scene3DSound\Props
	RMDir $INSTDIR\Assets\Mesh\Scene3DSound
	RMDir $INSTDIR\Assets\Mesh
	RMDir $INSTDIR\Assets\Shader
	RMDir $INSTDIR\Assets\Sounds
	RMDir $INSTDIR\Assets\textures\Scene3DSound
	RMDir $INSTDIR\Assets\textures
	RMDir $INSTDIR\Assets\xmlData
	RMDir $INSTDIR\Assets
	RMDir $INSTDIR
	
	Delete $DESKTOP\${MY_NAME}_3DScene.exe.lnk
	Delete $DESKTOP\${MY_NAME}_uninstaller.exe.lnk
	
	call un.DeleteRegistry

SectionEnd