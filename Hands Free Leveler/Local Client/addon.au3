#RequireAdmin
;#NoTrayIcon
#include <GUICONSTANTS.AU3>
#include <WINDOWSCONSTANTS.AU3>
#include <STATICCONSTANTS.AU3>
#include <EDITCONSTANTS.AU3>
#include <MISC.AU3>
#Include <GuiEdit.au3>
#Include <WinAPI.au3>
#include <Array.au3>
#include <String.au3>
#Include <DATE.au3>
Opt ('GUIoneventmode', 1)

;name nw to gui.exe
;name this file to Hands Free Leveler.exe

if ProcessExists("") Then
	MsgBox(16,"Error","Another instance already running")
	Exit
EndIf

;Run nw here
$portTry = 0
Do
	Sleep(500)
	Run("run.bat","",@SW_HIDE)
	WinWait("Hands Free Leveler")
	if Not WinExists("Hands Free Leveler") and $portTry >= 3 Then
		MsgBox(16,"Error","Error Code:1")
		Exit
	EndIf
	$portTry = $portTry  + 1
Until WinExists("Hands Free Leveler")
WinSetState("Hands Free Leveler","",@SW_SHOW)

TCPStartup()
$ip = "127.0.0.1"
$port = "44444"

For $0 = 0 To 10
	$Socket = TCPConnect($ip, $port)
	If $Socket <> -1 Then ExitLoop
	TCPCloseSocket($Socket)
	Sleep(300)
Next

If $Socket = -1 Then _Exit ()

While 1
	_Recv_From_Server ()
	updateStatus()

	If not WinExists("Hands Free Leveler") Then
		_Exit()
	EndIf
	Sleep(1000)
WEnd

Func _Send ($data)
	If $data = '' Then Return
	TCPSend($Socket, $data)
EndFunc   ;==>_send_

Func _Recv_From_Server ()
	$Recv = TCPRecv($Socket, 1000000)
	If $Recv = '' Then Return
	$commandArray = _StringExplode($Recv, "|#|", 0)
	_command($commandArray)
EndFunc   ;==>_Recv_From_Server_

Func _Exit ()
    TCPCloseSocket ($Socket)
	TCPShutdown()
	Exit
EndFunc   ;==>_Exit_

Func _command($cmd)
	If $cmd[0] == "runGame" Then
		_runGame($cmd[1])
	EndIf
EndFunc

Func _runGame($path)
	Run($path)
EndFunc

Func updateStatus()
	$bolRunning = 0

	If ProcessExists("BoL Studio.exe") Then
		$bolRunning = 1
	EndIf

	$sendData = "status" & "|" & $bolRunning
	_Send($sendData)
EndFunc

Func detectPage()
	return 1
EndFunc