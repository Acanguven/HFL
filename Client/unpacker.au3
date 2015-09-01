_Extract("node_modules.rar",@ScriptDir)

Func _Extract($sArchive, $sLocation)
    $myExtract = Run(@ScriptDir & "\UnRAR.exe x " & $sArchive & " " & $sLocation, @ScriptDir, @SW_HIDE, 0x2)
    While 1
        $extLine = StdoutRead($myExtract)
        If @error Then
            ExitLoop
        EndIf
    WEnd
EndFunc