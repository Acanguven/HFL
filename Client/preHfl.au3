#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; CUI stub5
#include <String.au3>
#include <Crypt.au3>

ConsoleWrite(_ANSI2UNICODE(_HWID()))

Func _HWID()
    local $drives = DriveGetDrive("FIXED")
    local $space = 0
    local $serial = ""
    local $RAM = MemGetStats()
	if $drives Then
    for $i=1 to $drives[0]
        $space += DriveSpaceTotal ($drives[$i])
        $serial &= StringUpper(DriveGetSerial($drives[$i]))
    Next
	EndIf
    $roms = DriveGetDrive("NETWORK")
	if $roms Then
		for $i=1 to $roms[0]
			$serial &= StringUpper(DriveGetSerial($roms[$i]))
		Next
	EndIf
    local $original = "0"&@CPUArch & @KBLayout & $serial & $space & $RAM[1]
    local $string2 = StringMid($original, Round(StringLen($original)/2), Round(StringLen($original)/2))
    local $string2_mod = _StringToHex(StringReverse($string2))
    $original = _Crypt_EncryptData($original, $string2_mod, $CALG_RC4)
    $original = _Crypt_HashData($original, $CALG_MD5)
    Return $original
EndFunc

Func _ANSI2UNICODE($sString = "")
    ; Extract ANSI and convert to UTF8 to display

    ; http://www.autoitscript.com/forum/index.php?showtopic=85496&view=findpost&p=614497
    ; ProgAndy
    ; convert ANSI-UTF8 representation to ANSI/Unicode

    Local Const $SF_ANSI = 1
    Local Const $SF_UTF8 = 4
    Return BinaryToString(StringToBinary($sString, $SF_ANSI), $SF_UTF8)
EndFunc