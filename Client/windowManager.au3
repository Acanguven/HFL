#NoTrayIcon
#RequireAdmin
while 1
	WinMove("[CLASS:RiotWindowClass]","",-1000,-1000)
	WinSetState ( "[CLASS:RiotWindowClass]", "", @SW_DISABLE  )
	WinSetState ( "[CLASS:SplashScreenClassName]", "", @SW_DISABLE  )
	WinSetState ( "[CLASS:SplashScreenClassName]", "", @SW_HIDE  )
	Sleep(100)
WEnd