;NSIS script for Osdag (Open Steel Design and Graphics) installer
;-----------------------------------------------------------------------
!include EnvVarUpdate.nsh
!include RefreshEnvironment.nsh
!include MUI2.nsh
!include x64.nsh

;Unicode true
Name "Osdag"
OutFile "Osdag-Windows-x86.exe"
InstallDirRegKey HKLM "Software\Osdag" ""
BrandingText "Osdag Test Installer"
InstallDir $DESKTOP\Osdag
RequestExecutionLevel admin

Var Start_menu_folder

!define MUI_ABORTWARNING
!define MUI_LANGDLL_ALLLANGUAGES
!define MUI_LANGDLL_REGISTRY_ROOT "HKLM"   
!define MUI_LANGDLL_REGISTRY_KEY "Software\Osdag" 
!define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"
!define INSTALLSIZE 2315093

;Start Menu Registry
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM" 
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\Osdag" 
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
!define MUI_ICON "Files\osdag_logo.ico"
!define MUI_UNICON "Files\osdag_logo.ico"
!define MUI_WELCOMEPAGE_TEXT "This Setup will guide you through the installation of Osdag.$\r$\n$\r$\nIt is recommended that you close all other applications before starting the Setup. This will make it possible to update relevant system files without restarting your computer. $\r$\n $\r$\nThe Setup also installs some dependencies that are required to run Osdag. $\r$\n $\r$\n Click Next to continue." 
!insertmacro MUI_PAGE_WELCOME  
!insertmacro MUI_PAGE_LICENSE "Files\License.txt"	
;!insertmacro MUI_PAGE_COMPONENTS # Uncomment when Miniconda setup is embedded
!insertmacro MUI_PAGE_DIRECTORY

;Following lines of code are for selecting default Osdag_workspace location
;!define $Osdag_workspace "$DESKTOP\Osdag_workspace"
;!define MUI_PAGE_HEADER_SUBTEXT "Select the default location for Osdag workspace"
;!define MUI_DIRECTORYPAGE_TEXT_TOP "Osdag workspace is the directory where all the design files will be saved. To select a different location, click Browse and specify a different lcoation. Click Next to continue."
;!define MUI_DIRECTORYPAGE_VARIABLE $Osdag_workspace
;!insertmacro MUI_PAGE_DIRECTORY
;!define $Osdag_workspace MUI_DIRECTORYPAGE_VARIABLE

!insertmacro MUI_PAGE_STARTMENU Application $Start_menu_folder
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;Uninstaller Design (/Layout)
!define MUI_WELCOMEPAGE_TEXT "This Setup will guide you through the uninstallation of Osdag. $\r$\n$\r$\nBefore starting the uninstallation, please make sure that Osdag is not running.$\r$\n$\r$\nClick Next to continue."
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;-----------------------------------------------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"
;!insertmacro MUI_LANGUAGE "German"   
!insertmacro REFRESH_ENVIRONMENT

Function update_path_miniconda
	${EnvVarUpdate} $0 "PATH" "P" "HKLM" "$PROGRAMFILES32\Miniconda2\Library\bin"
	${EnvVarUpdate} $0 "PATH" "P" "HKLM" "$PROGRAMFILES32\Miniconda2\Scripts"
	${EnvVarUpdate} $0 "PATH" "P" "HKLM" "$PROGRAMFILES32\Miniconda2"
FunctionEnd

Function update_path_wkhtmltopdf
	${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$PROGRAMFILES32\wkhtmltopdf\bin"
FunctionEnd

Function create_config_file
	
	;Create osdag.config and osdag-installation.log files
	;Set the location to copy files temporarily, if required
	;StrCpy $TEMP_Osdag "$TEMP\Osdag"

	;Create config file (with default path values)
	
	FileOpen $0 "$INSTDIR\Osdag.config" w
	FileWrite $0 "[desktop_path]"
	FileWrite $0 "$\r$\npath1 = $DESKTOP\"
	FileWrite $0 "$\r$\n$\r$\n[installation_dir]"
	FileWrite $0 "$\r$\npath1 = $INSTDIR\"
	FileWrite $0 "$\r$\n$\r$\n[wkhtml_path]"
	FileWrite $0 "$\r$\npath1 = $PROGRAMFILES32\wkhtmltopdf\bin\wkhtmltopdf.exe"	
	FileClose $0

FunctionEnd

Function create_osdag_launcher

	;Create Osdag.bat (This batch file, when invoked, will start Osdag.)
	FileOpen $0 "$INSTDIR\Osdag.bat" w
	FileWrite $0 "@setlocal enableextensions"
	FileWrite $0 "$\r$\n@cd /d $\"%~dp0$\""
	FileWrite $0 "$\r$\n@prompt Osdag:"
	FileWrite $0 "$\r$\n@cd /d $\"$INSTDIR$\""
	FileWrite $0 "$\r$\n@REM Please do not close this window."
	FileWrite $0 "$\r$\n@REM Please wait while Osdag is being initialized..."
	FileWrite $0 "$\r$\n@REM Osdag will display python console output in this window."
	FileWrite $0 "$\r$\n@echo off"
	FileWrite $0 "$\r$\nstart pythonw osdagMainPage.py"
	FileWrite $0 "$\r$\n@REM Osdag was closed."
	FileClose $0

	;Create shortcut for Osdag.bat
	CreateShortCut "$INSTDIR\Osdag.lnk" "$INSTDIR\Osdag.bat" "" "$INSTDIR\ResourceFiles\images\Osdag Icon.ico" "" SW_SHOWMINIMIZED

FunctionEnd

Section "Dependencies" SEC01
	SetDetailsPrint both
	DetailPrint "Installing: Miniconda2"
	SetDetailsPrint listonly
		SetOutPath $TEMP
		File "Files\Miniconda2-latest-Windows-x86.exe"
		ExecWait "$TEMP\Miniconda2-latest-Windows-x86.exe /InstallationType=AllUsers /AddToPath=0 /RegisterPython=1 /S /D=$PROGRAMFILES32\Miniconda2" $0
		Call update_path_miniconda	
	SetDetailsPrint both
	
	SetDetailsPrint both
	DetailPrint "Installing: wkhtmltopdf"
	SetDetailsPrint listonly
		SetOutPath $TEMP
		File "Files\wkhtmltox-0.12.4_msvc2015-win32.exe"
		nsExec::ExecToLog "$TEMP\wkhtmltox-0.12.4_msvc2015-win32.exe /S /D=$PROGRAMFILES32\wkhtmltopdf"
		Call update_path_wkhtmltopdf
	SetDetailsPrint both
	
	Call RefreshProcessEnvironmentPath
	
	SetDetailsPrint both
	DetailPrint "Installing: Python dependencies (Please be patient as this might take a few minutes)"
	SetDetailsPrint listonly
		SetOutPath $TEMP\dependencies
		File /r "Files\dependencies\*.*"
		nsExec::ExecToLog "$TEMP\dependencies\install_osdag_dependencies.bat"
		
		SetOutPath "$PROGRAMFILES32\Miniconda2\Lib\site-packages\"
		File /r "Files\cairo\*.*"
	SetDetailsPrint both
SectionEnd

Section "Osdag" SEC02
	SetDetailsPrint both
	DetailPrint "Installing: Osdag"
	SetDetailsPrint listonly
		SetOutPath $INSTDIR
		File /r "Files\Osdag\*.*"
		
		WriteRegStr HKLM "Software\Osdag" "" $INSTDIR
		WriteUninstaller "$INSTDIR\Uninstall Osdag.exe"
		
		Call create_config_file
		Call create_osdag_launcher
		
		!insertmacro MUI_STARTMENU_WRITE_BEGIN Application	
		CreateDirectory "$SMPROGRAMS\$Start_menu_folder"	
		CreateShortCut "$SMPROGRAMS\$Start_menu_folder\Osdag.lnk" "$INSTDIR\Osdag.bat" "" "$INSTDIR\ResourceFiles\images\Osdag Icon.ico" "" SW_SHOWMINIMIZED
		CreateShortCut "$SMPROGRAMS\$Start_menu_folder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
		!insertmacro MUI_STARTMENU_WRITE_END
		
		;Create Desktop shortcut	
		CreateShortCut "$DESKTOP\Osdag.lnk" "$INSTDIR\Osdag.bat" "" "$INSTDIR\ResourceFiles\images\Osdag Icon.ico" "" SW_SHOWMINIMIZED
	SetDetailsPrint both
SectionEnd

Section "DeletingTempFiles" SEC03
	SetDetailsPrint both
	DetailPrint "Deleting: temporary files"
	SetDetailsPrint listonly
		Delete "$TEMP\Miniconda2-latest-Windows-x86.exe"
		Delete "$TEMP\wkhtmltox-0.12.4_msvc2015-win32.exe"
		RMDir /r "$TEMP\dependencies\"	
	SetDetailsPrint both
SectionEnd

Section "Uninstall" 

	;Uninstaller Section
	
	;Remove Start Menu shortcuts
	!insertmacro MUI_STARTMENU_GETFOLDER Application $Start_menu_folder    
	Delete "$SMPROGRAMS\$Start_menu_folder\Uninstall.lnk"
	RMDir /r "$SMPROGRAMS\$Start_menu_folder\"
	
	;Remove Desktop shortcut (if it exists)
	Delete "$DESKTOP\Osdag.lnk"
  
	;Remove installed files
	Delete "$INSTDIR\Uninstall Osdag.exe" ;Explicitly delete the Uninstaller
	RMDir /r "$INSTDIR\*"
	RMDir $INSTDIR
	
	;Remove Miniconda and wkhtmltopdf
	ExecWait "$PROGRAMFILES32\Miniconda2\Uninstall-Anaconda.exe /S /wait" $0
	ExecWait "$PROGRAMFILES32\wkhtmltopdf\uninstall.exe /S /wait" $0
	/*
	RMDir /r "$PROGRAMFILES32\Miniconda2\*"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$PROGRAMFILES32\Miniconda2\Library\bin"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$PROGRAMFILES32\Miniconda2\Scripts"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$PROGRAMFILES32\Miniconda2"
	
	RMDir /r "$PROGRAMFILES32\wkhtmltopdf\*"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$PROGRAMFILES32\wkhtmltopdf\bin"
	*/ 
	 
	;Remove Registry Entry 
	;Add /isempty parameter if the Osdag registry entry needs to be kept for future installation
	;Ideally, a clean uninstall also removes the registry entries.
	DeleteRegKey HKLM "Software\Osdag"
  
SectionEnd

Function .onInstSuccess

	;Function that calls a messagebox when installation finished correctly
	MessageBox MB_OK "You have successfully installed Osdag. Use the desktop or Start Menu shortcut to start the program."
	
FunctionEnd
 
Function un.onUninstSuccess

	;Function that calls a messagebox when uninstallation finished correctly
	MessageBox MB_OK "You have successfully uninstalled Osdag."
	
FunctionEnd