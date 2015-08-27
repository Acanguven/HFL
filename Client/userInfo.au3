#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; CUI stub5
#include <WinAPIFiles.au3>

Local $sUsername = InputBox("Login","Be sure that you already registed to handsfreeleveler.com" & @CRLF & @CRLF &"Enter your Username", "")
Local $sPasswd = InputBox("Login", "Enter your password", "", "*")

ConsoleWrite(_ANSI2UNICODE($sUsername & "|#|" & $sPasswd))

Func _ANSI2UNICODE($sString = "")
    ; Extract ANSI and convert to UTF8 to display

    ; http://www.autoitscript.com/forum/index.php?showtopic=85496&view=findpost&p=614497
    ; ProgAndy
    ; convert ANSI-UTF8 representation to ANSI/Unicode

    Local Const $SF_ANSI = 1
    Local Const $SF_UTF8 = 4
    Return BinaryToString(StringToBinary($sString, $SF_ANSI), $SF_UTF8)
EndFunc