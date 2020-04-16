uses Tlhelp32

////////////////////////////////////////////////////////////////////////

//Abaixo de {$R *.dfm}
function GetProcessID(Const ExeFileName: string; var ProcessId: integer): boolean;
var
	ContinueLoop: BOOL;
	FSnapshotHandle: THandle;
	FProcessEntry32: TProcessEntry32;
begin
	result := false;
	FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
	ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
	
	while integer(ContinueLoop) <> 0 do begin
		if (StrIComp(PChar(ExtractFileName(FProcessEntry32.szExeFile)), PChar(ExeFileName)) = 0)
			or (StrIComp(FProcessEntry32.szExeFile, PChar(ExeFileName)) = 0)  then begin
			ProcessId:= FProcessEntry32.th32ProcessID;
			result := true;
			break;
		end;
	ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
	end;
	
	CloseHandle(FSnapshotHandle);
end;  

////////////////////////////////////////////////////////////////////////

var
	Valor, Address, Buffer, Offset: Cardinal;
	PID: Integer;
	HandleX: THandle;
begin
	if GetProcessID('processo.exe', PID) then
	begin
		Address := $0012FFB0;	//Aponte a address da memoria
		Valor := 99999;			//Novo valor a ser inserido
		Offset := $194;			//Offset para o calculo da pointer
		HandleX := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
		ReadProcessMemory(HandleX,Pointer(Address), @Address,4, Buffer);
		WriteProcessMemory(HandleX,Pointer(Address + Offset), @Valor,4, Buffer);
	end;
end;
