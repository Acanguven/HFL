#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=_n15.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

While ProcessExists("League of Legends.exe")
	ProcessClose("League of Legends.exe")
	Sleep(100)
WEnd