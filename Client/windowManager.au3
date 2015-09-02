#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=_n13.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
WinMove("[CLASS:RiotWindowClass]","",-1000,-1000)
WinSetState ( "[CLASS:RiotWindowClass]", "", @SW_DISABLE  )
WinSetState ( "[CLASS:SplashScreenClassName]", "", @SW_DISABLE  )
WinSetState ( "[CLASS:SplashScreenClassName]", "", @SW_HIDE  )