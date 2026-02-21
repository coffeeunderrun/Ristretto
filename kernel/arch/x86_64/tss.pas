unit Tss;

interface

procedure Initialize;

implementation

uses Cpu, Gdt, HeapMgr, SysUtils;

type
  PTss = ^TTss;
  TTss = packed record
    Reserved1: UInt32;
    Rsp: array [0..2] of UInt64;
    Reserved2: UInt64;
    Ist: array [1..7] of UInt64;
    Reserved3: UInt64;
    Reserved4: UInt16;
    Iopb: UInt16;
  end;

procedure Initialize;
var
  TssPtr: PTss;
  CpuPtr: PCpu;
begin
  TssPtr := GetAlignedMem(SizeOf(TTss), 8);
  if not Assigned(TssPtr) then Panic('Failed to allocate TSS.');

  CpuPtr := GetCpuPtr;
  CpuPtr^.TssPtr := TssPtr;

  SetGdtTssEntry(TssPtr, SizeOf(TTss) - 1);

  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Allocate TSS: addr=$%.16X.', [PtrUInt(TssPtr)]));
  {$endif NDEBUG}

  FillByte(TssPtr^, SizeOf(TTss), 0);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Zero TSS: addr=$%.16X, size=%d bytes.', [PtrUInt(TssPtr), SizeOf(TTss)]));
  {$endif NDEBUG}

  with TssPtr^ do begin
    { Tss entries must point to top of stack.
      May be beneficial allocate with stack protection. For now I will just use the heap. }
    Rsp[0] := PtrUInt(GetAlignedMem($1000, 16)) + $1000;
    Ist[1] := PtrUInt(GetAlignedMem($1000, 16)) + $1000;
    Ist[2] := PtrUInt(GetAlignedMem($1000, 16)) + $1000;
    Ist[3] := PtrUInt(GetAlignedMem($1000, 16)) + $1000;
    Ist[4] := PtrUInt(GetAlignedMem($1000, 16)) + $1000;
    Ist[5] := PtrUInt(GetAlignedMem($1000, 16)) + $1000;

    {$ifndef NDEBUG}
    WriteLn(LogDebug, Format('Set RSP0: stack top=$%.16X.', [Rsp[0]]));
    WriteLn(LogDebug, Format('Set IST1: stack top=$%.16X.', [Ist[1]]));
    WriteLn(LogDebug, Format('Set IST2: stack top=$%.16X.', [Ist[2]]));
    WriteLn(LogDebug, Format('Set IST3: stack top=$%.16X.', [Ist[3]]));
    WriteLn(LogDebug, Format('Set IST4: stack top=$%.16X.', [Ist[4]]));
    WriteLn(LogDebug, Format('Set IST5: stack top=$%.16X.', [Ist[5]]));
    {$endif NDEBUG}
  end;

  WriteLn(LogInfo, 'TSS initialized.');
end;

end.
