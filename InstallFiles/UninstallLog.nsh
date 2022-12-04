Function BrowsingDirectory

	Exch $0 ;path
	Push $1
	Push $2
	Push $3
	Push $4
	
	FindFirst $1 $2 "$0\*.*"
	
	Loop:
		IfErrors Done
		StrCmp $2 "." Next
		StrCmp $2 ".." Next
		
		IfFileExists "$0\$2\*.*" 0 IsFile
		
		Push "$0\$2"
		call ${__FUNCTION__}
		
		FileOpen $4 "$INSTDIR\dirlog.txt" a
		FileSeek $4 0 END
		FileWrite $4 "$0\$2$\r$\n"
		FileClose $4
		
		Goto Next
		
		IsFile:
		FileOpen $3 "$INSTDIR\filelog.txt" a
		FileSeek $3 0 END
		FileWrite $3 "$0\$2$\r$\n"
		FileClose $3
		Goto Next
		
	Next:
		FindNext $1 $2
		Goto Loop
		
	Done:
	
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Pop $0

FunctionEnd

Function un.DeleteFiles

	IfFileExists "$INSTDIR\filelog.txt" +3
		MessageBox MB_OK "Missing log files! Cannot uninstall!"
		Abort
		
	Push $R0
	Push $R1
	Push $R2
	Push $R3
	SetFileAttributes "$INSTDIR\filelog.txt" NORMAL
	FileOpen $R3 "$INSTDIR\filelog.txt" r
	StrCpy $R1 -1
	
	GetLineCount:
		ClearErrors
		FileRead $R3 $R0
		IntOp $R1 $R1 + 1
		StrCpy $R0 $R0 -2
		Push $R0
		IfErrors 0 GetLineCount
	
	Pop $R0
	
	LoopRead:
		StrCmp $R1 0 LoopDone
		Pop $R0

		IfFileExists "$INSTDIR\$R0" 0 +3
			Delete "$INSTDIR\$R0"
		
		IntOp $R1 $R1 - 1
		Goto LoopRead
	
	LoopDone:
		FileClose $R3
		Delete "$INSTDIR\filelog.txt"
		Delete "$INSTDIR\dirlog.txt"
		
	Pop $R2
	Pop $R1
	Pop $R0
	
FunctionEnd
