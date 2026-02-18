unit Gdt;

interface

procedure Initialize;

implementation

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

  TGdtPointer = packed record
    Limit: UInt16;
    Base: PtrUInt;
  end;

var
  GdtEntries: array [0..6] of TGdtEntry = (
    (Descriptor: $0000000000000000), // $00 Null
    (Descriptor: $00209A0000000000), // $08 Kernel Code
    (Descriptor: $0000920000000000), // $10 Kernel Data
    (Descriptor: $0020FA0000000000), // $18 User Code
    (Descriptor: $0000F20000000000), // $20 User Data
    (Descriptor: $0000000000000000), // $28 TSS
    (Descriptor: $0000000000000000)
  );

procedure Initialize;
var
  GdtPointer: TGdtPointer;
begin
  GdtPointer.Limit := SizeOf(GdtEntries) - 1;
  GdtPointer.Base := PtrUInt(@GdtEntries);

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

  {$ifndef NDEBUG}
  WriteLn(LogDebug, 'GDT initialized.');
  {$endif}
end;

end.
