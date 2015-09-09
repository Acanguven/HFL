#pragma once
#include <windows.h>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <tlhelp32.h>
#include <sys/stat.h>
#include <sstream>
using namespace std;

class bInjectClass{
public:
	bInjectClass();
	int SetDebugRights();
	bool InjectInto(string DllName, LPCSTR processName);
	DWORD GetProcessID(string procName);
	int DllExist(char *filename);
};

bInjectClass::bInjectClass(){
	bInjectClass::SetDebugRights();
}

int bInjectClass::SetDebugRights(){
	//cout << "SetDebugRights\n";
	HANDLE Token;
	TOKEN_PRIVILEGES tp;
	if (OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &Token))
	{
		//cout << "Token: " << Token << "\n";
		LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &tp.Privileges[0].Luid);
		tp.PrivilegeCount = 1;
		tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
		if (AdjustTokenPrivileges(Token, 0, &tp, sizeof(tp), NULL, NULL) == 0){
			//cout << "Set: Fail\n";
			return 1; //FAIL
		}
		else{
			//cout << "Set: Success\n";
			return 0; //SUCCESS
		}
	}
	return 1;
}

bool bInjectClass::InjectInto(string DllName, LPCSTR processName){
	char dll[MAX_PATH];
	strcpy_s(dll, DllName.c_str());
	if (DllExist(dll) != 0) {
		//cout << "Error NO DLL\n";
		return NULL;
	};
	DWORD id = NULL;
	HANDLE wHandle = NULL;
	wHandle = FindWindow(0, processName);
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
	//cout << "id: " << id << " -> " << &id << "\n";
	HANDLE p;
	p = OpenProcess(PROCESS_ALL_ACCESS, false, id);
	if (p == NULL) {
		//cout << "Error 2\n";
		return NULL;
	};
	LPVOID mem = VirtualAllocEx(p, NULL, sizeof(dll), MEM_COMMIT, PAGE_READWRITE);
	WriteProcessMemory(p, mem, dll, sizeof(dll), NULL);
	HANDLE thread = CreateRemoteThread(p, NULL, 0, (LPTHREAD_START_ROUTINE)GetProcAddress(GetModuleHandle("kernel32.dll"), "LoadLibraryA"), mem, 0, NULL);
	//cout << "thread: " << thread << "\n";
	bool done;
	if (thread != 0){
		done = true;
	}
	else{
		//cout << "Error 3\n";
		done = NULL;
	}
	CloseHandle(thread);
	CloseHandle(p);
	return done;
}

int bInjectClass::DllExist(char *filename) {
	struct stat buffer;
	if (stat(filename, &buffer)) return 1;
	return 0;
}