; the windows setup wizard. tools/build.sh compiles it with -DVERSION, -DSOURCE
; (the folder to install), -DOUTFILE, -DICON and -DFILES (what the uninstaller removes).

Unicode true
!include "MUI2.nsh"

Name "Flight"
OutFile "${OUTFILE}"
; per user: no administrator prompt, and an update needs none either
RequestExecutionLevel user
InstallDir "$LOCALAPPDATA\Programs\Flight"
InstallDirRegKey HKCU "Software\Burrow" "InstallDir"
SetCompressor /SOLID lzma
BrandingText "Flight ${VERSION}"

VIProductVersion "${VERSION}.0"
VIAddVersionKey "ProductName" "Flight"
VIAddVersionKey "FileDescription" "Flight Setup"
VIAddVersionKey "FileVersion" "${VERSION}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIAddVersionKey "LegalCopyright" ""

!define MUI_ICON "${ICON}"
!define MUI_UNICON "${ICON}"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\Flight.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Start Flight"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\Burrow"

Section "Flight"
  SetOutPath "$INSTDIR"
  File /r "${SOURCE}\*.*"
  WriteUninstaller "$INSTDIR\Uninstall Flight.exe"

  CreateShortcut "$SMPROGRAMS\Flight.lnk" "$INSTDIR\Flight.exe"
  CreateShortcut "$DESKTOP\Flight.lnk" "$INSTDIR\Flight.exe"

  WriteRegStr HKCU "Software\Burrow" "InstallDir" "$INSTDIR"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "DisplayName" "Flight"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "Publisher" "Flight"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "DisplayIcon" "$INSTDIR\Flight.exe"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${UNINSTALL_KEY}" "UninstallString" '"$INSTDIR\Uninstall Flight.exe"'
  WriteRegDWORD HKCU "${UNINSTALL_KEY}" "NoModify" 1
  WriteRegDWORD HKCU "${UNINSTALL_KEY}" "NoRepair" 1

  ; burrow:// links, from the account page's "Sign in with the Flight client"
  ; (app/main.js writes the same when it starts)
  WriteRegStr HKCU "Software\Classes\burrow" "" "URL:burrow"
  WriteRegStr HKCU "Software\Classes\burrow" "URL Protocol" ""
  WriteRegStr HKCU "Software\Classes\burrow\shell\open\command" "" '"$INSTDIR\Flight.exe" "%1"'
SectionEnd

; only what was installed goes: the folder may be one the player chose, with
; other things in it. remembered accounts and settings live elsewhere and stay.
Section "Uninstall"
  !include "${FILES}"
  Delete "$INSTDIR\Uninstall Flight.exe"
  RMDir "$INSTDIR"

  Delete "$SMPROGRAMS\Flight.lnk"
  Delete "$DESKTOP\Flight.lnk"
  DeleteRegKey HKCU "${UNINSTALL_KEY}"
  DeleteRegKey HKCU "Software\Burrow"
  DeleteRegKey HKCU "Software\Classes\burrow"
SectionEnd
