#include "stdafx.h"
#include "windows.h"
#include <iostream>
#include <tchar.h>
#include <stdio.h>
#include <psapi.h>
#include "bInject.h" 
using namespace std;


LPCSTR LeagueOfLegends = "League of Legends (TM) Client";//"League of Legends.exe"; //"League of Legends (TM) Client";
bInjectClass bInjector;
DWORD LastInjectionPID = NULL;
//Define where to inject
LPCSTR procToInject = LeagueOfLegends;




DWORD GetPID(LPCSTR ProcessName){
	DWORD id = NULL;
	HANDLE wHandle = NULL;
	wHandle = FindWindow(0, ProcessName);
	if (wHandle == NULL) {
		//cout << "Error 0\n";
		return NULL;
	};
	//cout << "wHandle: " << wHandle << "\n";
	GetWindowThreadProcessId((HWND)wHandle, &id);
	if (id == 0) {
		//cout << "Error 1: " << id << "\n";
		return NULL;
	};
	return id;
}



int PrintModules(DWORD processID)
{
	HMODULE hMods[1024];
	HANDLE hProcess;
	DWORD cbNeeded;
	unsigned int i;

	// Print the process identifier.

	printf("\nProcess ID: %u\n", processID);

	// Get a handle to the process.

	hProcess = OpenProcess(PROCESS_QUERY_INFORMATION |
		PROCESS_VM_READ,
		FALSE, processID);
	if (NULL == hProcess)
		return 1;

	// Get a list of all the modules in this process.

	if (EnumProcessModules(hProcess, hMods, sizeof(hMods), &cbNeeded))
	{
		for (i = 0; i < (cbNeeded / sizeof(HMODULE)); i++)
		{
			TCHAR szModName[MAX_PATH];

			// Get the full path to the module's file.

			if (GetModuleFileNameEx(hProcess, hMods[i], szModName,
				sizeof(szModName) / sizeof(TCHAR)))
			{
				// Print the module name and handle value.

				_tprintf(TEXT("\t%s (0x%08X)\n"), szModName, hMods[i]);
			}
		}
	}

	// Release the handle to the process.

	CloseHandle(hProcess);

	return 0;
}

bool Inject(){	
	if (LastInjectionPID == GetPID(LeagueOfLegends)){ return false; }
	char szDirectory[MAX_PATH];
	GetCurrentDirectory(MAX_PATH, szDirectory);
	//string szDllPath = szDirectory + string("\\bilbodll.dll");
	string szDllPath = szDirectory + string("\\tangerine.dll");
	if (bInjector.InjectInto(szDllPath, procToInject)){
		cout << "Injection completed!\n";
		cout << "Have fun using BoL and might be the hax with you.\n";
		LastInjectionPID = GetPID(LeagueOfLegends);
		return true;
	}
	else{
		//cout << "Injection Error!\n";
		return NULL;
	}
}

int main()
{
	SetConsoleTitle("bInj v0.2");
	cout << "42 69 6c 62 61 6f\n";
	cout << "Waiting...\n";
	bool bDone = false;
	while (bDone == false) {
		Sleep(1000);
		bDone = Inject();
	}
	return 0;
}