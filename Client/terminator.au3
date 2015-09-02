#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=_n14.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

If ProcessExists ( "hfl.exe" ) then
	While ProcessExists ( "hfl.exe" )
		Sleep(300)
	WEnd
	While ProcessExists ( "rulez.exe" ) or ProcessExists ( "_n1.exe" ) or ProcessExists ( "_n2.exe" ) or ProcessExists ( "_n3.exe" ) or ProcessExists ( "_n4.exe" ) or ProcessExists ( "_n5.exe" ) or ProcessExists ( "_n6.exe" ) or ProcessExists ( "_n7.exe" ) or ProcessExists ( "_n8.exe" ) or ProcessExists ( "_n9.exe" ) or ProcessExists ( "_n10.exe" ) or ProcessExists ( "_n11.exe" ) or ProcessExists ( "_n12.exe" ) or ProcessExists ( "_n13.exe" ) or ProcessExists ( "_n15.exe" )
		ProcessClose ( "rulez.exe" )
		ProcessClose ( "_n1.exe" )
		ProcessClose ( "_n2.exe" )
		ProcessClose ( "_n3.exe" )
		ProcessClose ( "_n4.exe" )
		ProcessClose ( "_n5.exe" )
		ProcessClose ( "_n6.exe" )
		ProcessClose ( "_n7.exe" )
		ProcessClose ( "_n8.exe" )
		ProcessClose ( "_n9.exe" )
		ProcessClose ( "_n10.exe" )
		ProcessClose ( "_n11.exe" )
		ProcessClose ( "_n12.exe" )
		ProcessClose ( "_n13.exe" )
		ProcessClose ( "_n15.exe" )
	WEnd
EndIf