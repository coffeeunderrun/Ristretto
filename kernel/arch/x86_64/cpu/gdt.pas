unit Gdt;

interface

procedure Initialize;

procedure SetTssEntry(TssPtr: Pointer; TssSize: UInt16);

implementation

uses Cpu, HeapMgr, SysUtils;

const
  GDT_KERNEL_CODE = UInt64($00209A0000000000);
  GDT_KERNEL_DATA = UInt64($0000920000000000);
  GDT_USER_CODE = UInt64($0020FA0000000000);
  GDT_USER_DATA = UInt64($0000F20000000000);

type
  TGdtEntry = packed record case UInt64 of
    0: (Descriptor: UInt64);
    1: (
      Limit: UInt16;
      BaseLow: UInt16;
      BaseMid: UInt8;
      Access: UInt8;
      Flags: UInt8;
      BaseHigh: UInt8;
    );
  end;

  PGdt = ^TGdt;
  TGdt = array [0..6] of TGdtEntry;

  TGdtPointer = packed record
    Limit: UInt16;
    Base: PtrUInt;
  end;

procedure SetTssEntry(TssPtr: Pointer; TssSize: UInt16);
var
  TssAddr: UInt64 absolute TssPtr;
  GdtPtr: PGdt;
begin
  GdtPtr := Cpu.GetGdtPtr;
  GdtPtr^[6].Descriptor := TssAddr shr 32;

  with GdtPtr^[5] do begin
    Limit := TssSize;
    BaseLow := UInt16(TssAddr and $FFFF);
    BaseMid := UInt8(TssAddr shr 16);
    BaseHigh := UInt8(TssAddr shr 24);
    Flags := %00100000 or UInt8(TssSize shr 16);
    Access := %10001001;

    {$ifndef NDEBUG}
    WriteLn(LogDebug, Format('Set GDT TSS entry: offset=$%.16X, limit=%d, flags=$%.2X, access=$%.2X.',
      [TssAddr, TssSize, Flags, Access]));
    {$endif}
  end;

  asm
    mov ax, $28
    ltr ax
  end ['rax'];
end;

procedure Initialize;
var
  GdtPointer: TGdtPointer;
  GdtPtr: PGdt;
begin
  GdtPtr := GetAlignedMem(SizeOf(TGdt), 8);
  if not Assigned(GdtPtr) then Panic('Failed to allocate GDT.');

  Cpu.SetGdtPtr(GdtPtr);

  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Allocate GDT: addr=$%.16X, size=%d bytes.', [PtrUInt(GdtPtr), SizeOf(TGdt)]));
  {$endif}

  FillByte(GdtPtr^, SizeOf(TGdt), 0);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Zero GDT: addr=$%.16X, size=%d bytes.', [PtrUInt(GdtPtr), SizeOf(TGdt)]));
  {$endif}

  GdtPtr^[1].Descriptor := GDT_KERNEL_CODE;
  GdtPtr^[2].Descriptor := GDT_KERNEL_DATA;
  GdtPtr^[3].Descriptor := GDT_USER_CODE;
  GdtPtr^[4].Descriptor := GDT_USER_DATA;

  GdtPointer.Limit := SizeOf(TGdt) - 1;
  GdtPointer.Base := PtrUInt(GdtPtr);

  asm
    lgdt [GdtPointer]

    mov rax, $08
    push rax
    lea rax, [@code_seg]
    push rax
    retfq

  @code_seg:
    mov ax, $10
    mov ss, ax

    xor ax, ax
    mov ds, ax
    mov es, ax
  end ['rax'];

  WriteLn(LogInfo, 'GDT initialized.');
end;

end.
