#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; CUI stub5
#include <FileConstants.au3>
#include <WinAPIFiles.au3>

Local $filePath = $CmdLine[1]
while Not FileExists($filePath)
	$filePath = FileOpenDialog("Select lol.launcher.admin.exe in your game directory", @WindowsDir & "\", "Lol Launcher(lol.launcher.admin.exe)", $FD_FILEMUSTEXIST)
WEnd
ConsoleWrite(_ANSI2UNICODE($filePath))

Func _ANSI2UNICODE($sString = "")
    ; Extract ANSI and convert to UTF8 to display

    ; http://www.autoitscript.com/forum/index.php?showtopic=85496&view=findpost&p=614497
    ; ProgAndy
    ; convert ANSI-UTF8 representation to ANSI/Unicode

    Local Const $SF_ANSI = 1
    Local Const $SF_UTF8 = 4
    Return BinaryToString(StringToBinary($sString, $SF_ANSI), $SF_UTF8)
EndFunc