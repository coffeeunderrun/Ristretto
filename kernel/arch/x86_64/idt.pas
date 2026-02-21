unit Idt;

interface

procedure Initialize;

procedure AcknowledgeIrq(Irq: UInt8);

implementation

uses SysUtils;

const
  PIC1_CONTROL = $20;
  PIC1_DATA    = $21;
  PIC2_CONTROL = $A0;
  PIC2_DATA    = $A1;

type
  TIdtPointer = packed record
    Limit: UInt16;
    Base: PtrUInt;
  end;

  TIdtEntry = packed record
    OffsetLow: UInt16;
    Segment: UInt16;
    Ist: UInt8;
    Flags: UInt8;
    OffsetMid: UInt16;
    OffsetHigh: UInt32;
    Reserved: UInt32;
  end;

var
  IdtEntries: array [0..255] of TIdtEntry; external name '_idt';
  IsrStubs: array [0..255] of PtrUInt; external name '_isr_stubs';

procedure AcknowledgeIrq(Irq: UInt8); assembler; nostackframe;
asm
  // Assumes caller verfied IRQ is between 0 and 15.
  mov al, $20   // End of interrupt command.
  test dil, $08 // Is IRQ >= 8? (IRQ in RDI; use DIL because TEST expects a byte).
  jnz @pic2     // If true, send EOI to pic 2.

  @pic1:
  out PIC1_CONTROL, al
  jmp @done

  @pic2:
  out PIC2_CONTROL, al

  @done:
end;

procedure InitializePics; assembler; nostackframe;
asm
  mov al, $11 // Begin initialization, ICW4 needed
  out PIC1_CONTROL, al
  out PIC2_CONTROL, al

  mov al, 32 // Remap PIC1 vectors
  out PIC1_DATA, al
  mov al, 40 // Remap PIC2 vectors
  out PIC2_DATA, al

  mov al, $04 // Inform PIC1 that PIC2 is connected to IRQ2
  out PIC1_DATA, al
  mov al, $02 // Inform PIC2 to cascade through IRQ2 on PIC1
  out PIC2_DATA, al

  mov al, $01 // Environment 8086 mode
  out PIC1_DATA, al
  out PIC2_DATA, al

  mov al, 11111110b // Mask all PIC1 IRQs, except PIT
  out PIC1_DATA, al
  mov al, 11111111b // Mask all PIC2 IRQs
  out PIC2_DATA, al
end;

procedure PopulateIdt;
var
  Offset: PtrUInt;
  Vector: UInt8;
begin
  FillByte(IdtEntries, SizeOf(IdtEntries), 0);

  for Vector := 0 to 255 do begin
    Offset := IsrStubs[Vector];
    if Offset = 0 then continue;

    with IdtEntries[Vector] do begin
      OffsetHigh := Offset shr 32;
      OffsetMid := (Offset shr 16) and $FFFF;
      OffsetLow := Offset and $FFFF;
      Segment := $08;
      Flags := $8E;
      case Vector of
        1:  Ist := 1; // Debug exception
        2:  Ist := 2; // Non-maskable interrupt
        8:  Ist := 3; // Double fault
        12: Ist := 4; // Stack segment fault
        18: Ist := 5; // Machine check
      end;
      {$ifndef NDEBUG}
      WriteLn(LogDebug, Format('Set IDT entry: vector=%d, offset=$%.16X, ist=%d, flags=$%.2X.', [Vector, Offset, Ist, Flags]));
      {$endif NDEBUG}
    end;
  end;
end;

procedure LoadIdt;
var
  IdtPointer: TIdtPointer;
begin
  IdtPointer.Limit := SizeOf(IdtEntries) - 1;
  IdtPointer.Base := PtrUInt(@IdtEntries);

  asm
    lidt [IdtPointer]
    sti
  end;
end;

procedure Initialize;
begin
  InitializePics;
  PopulateIdt;
  LoadIdt;
  WriteLn(LogInfo, 'IDT initialized.');
end;

end.
