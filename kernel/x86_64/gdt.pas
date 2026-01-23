unit Gdt;

{$asmmode intel}

interface

implementation

uses Log;

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
    Base: UInt64;
  end;

var
  GdtPointer: TGdtPointer;
  GdtEntries: array [0..4] of TGdtEntry = (
    (Descriptor: 0), // Null
    (Limit: 0; BaseLow: 0; BaseMid: 0; Access: $9A; Flags: $20; BaseHigh: 0), // $08 Kernel Code
    (Limit: 0; BaseLow: 0; BaseMid: 0; Access: $92; Flags: $00; BaseHigh: 0), // $10 Kernel Data
    (Limit: 0; BaseLow: 0; BaseMid: 0; Access: $FA; Flags: $20; BaseHigh: 0), // $18 User Code
    (Limit: 0; BaseLow: 0; BaseMid: 0; Access: $F2; Flags: $00; BaseHigh: 0)  // $20 User Data
  );

begin
  GdtPointer.Limit := SizeOf(GdtEntries) - 1;
  GdtPointer.Base := PtrUInt(@GdtEntries);

  asm
    lgdt [GdtPointer]

    mov ax, $10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov rax, $08
    push rax
    lea rax, [@code_seg]
    push rax
    retfq

  @code_seg:
  end ['rax'];

  Log.Debug('Unit initialized: GDT');
end.
