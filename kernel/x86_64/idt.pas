unit Idt;

interface

implementation

uses Log;

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
  IdtPointer: TIdtPointer;
  IdtEntries: array [0..255] of TIdtEntry; external name '_idt';
  IsrStubs: array [0..255] of PtrUInt; external name '_isr_stubs';

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

  mov al, $FF // Mask IRQs
  out PIC1_DATA, al
  out PIC2_DATA, al
end;

procedure SetGate(Vector, Ist, Flags: UInt8; Segment: UInt16; Offset: PtrUInt);
begin
  IdtEntries[Vector].OffsetHigh := Offset shr 32;
  IdtEntries[Vector].OffsetMid := (Offset shr 16) and $FFFF;
  IdtEntries[Vector].OffsetLow := Offset and $FFFF;
  IdtEntries[Vector].Segment := Segment;
  IdtEntries[Vector].Flags := Flags;
  IdtEntries[Vector].Ist := Ist and $7;
end;

procedure Handler; public name '_handler';
begin
  Log.Debug('Interrupt handler called.');
  Halt;
end;

var
  I: UInt8;

begin
  InitializePics;

  FillByte(IdtEntries, SizeOf(IdtEntries), 0);

  for I := 0 to 255 do begin
    SetGate(I, 0, $8E, $08, IsrStubs[I]);
  end;

  IdtPointer.Limit := SizeOf(IdtEntries) - 1;
  IdtPointer.Base := PtrUInt(@IdtEntries);

  asm
    lidt [IdtPointer]
  end;

  Log.Debug('Unit initialized: IDT');
end.
