unit Idt;

interface

procedure Initialize;

implementation

uses Cpu, Log, SysUtils, Terminal;

const
  PIC1_CONTROL = $20;
  PIC1_DATA    = $21;
  PIC2_CONTROL = $A0;
  PIC2_DATA    = $A1;

  Descriptions: array [0..47] of String = (
    'Divide by zero',
    'Debug',
    'Non-maskable',
    'Breakpoint',
    'Overflow',
    'Bound range exceeded',
    'Invalid opcode',
    'Device not available',
    'Double fault',
    'Reserved',
    'Invalid TSS',
    'Segment not present',
    'Stack segment fault',
    'General protection fault',
    'Page fault',
    'Reserved',
    'x87 floating point exception',
    'Alignment check',
    'Machine check',
    'SIMD floating point exception',
    'Virtualization exception',
    'Control protection exception',
    'Reserved',
    'Reserved',
    'Reserved',
    'Reserved',
    'Reserved',
    'Reserved',
    'Hypervisor injection exception',
    'VMM communication exception',
    'Security exception',
    'Reserved',
    'PIT',
    'Keyboard',
    'PIC cascade',
    'COM2/COM4',
    'COM1/COM3',
    'LPT2',
    'FDC',
    'LPT1',
    'RTC',
    'Available',
    'Available',
    'Available',
    'Mouse',
    'FPU',
    'HDC1',
    'HDC2'
  );

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
  mov al, $20   // End of interrupt command
  test Irq, $08 // Is IRQ >= 8?
  jnz @pic2     // If true, send EOI to pic 2

  @pic1:
  out PIC1_CONTROL, al
  jmp @done

  @pic2:
  out PIC2_CONTROL, al

  @done:
end;

procedure Handler(RegsPtr: PRegisters); public name '_handler';
begin
  with RegsPtr^ do begin
    if (Vector > 31) and (Vector < 48) then begin
      AcknowledgeIrq(Code);
      exit;
    end;

    Terminal.WriteLn('Interrupt: ' + Descriptions[Vector]);
    Terminal.WriteLn('RAX=' + IntToHex(RAX) + ' RBX=' + IntToHex(RBX) + ' RCX=' + IntToHex(RCX) + ' RDX=' + IntToHex(RDX));
    Terminal.WriteLn('RSI=' + IntToHex(RSI) + ' RDI=' + IntToHex(RDI) + ' RBP=' + IntToHex(RBP) + ' RSP=' + IntToHex(RSP));
    Terminal.WriteLn('R8 =' + IntToHex(R8)  + ' R9 =' + IntToHex(R9)  + ' R10=' + IntToHex(R10) + ' R11=' + IntToHex(R11));
    Terminal.WriteLn('R12=' + IntToHex(R12) + ' R13=' + IntToHex(R13) + ' R14=' + IntToHex(R14) + ' R15=' + IntToHex(R15));
    Terminal.WriteLn('RIP=' + IntToHex(RIP) + ' CS =' + IntToHex(CS)  + ' RSP=' + IntToHex(RSP) + ' SS =' + IntToHex(SS));
    Terminal.WriteLn('VEC=' + IntToHex(Vector) + ' ERR=' + IntToHex(Code) + ' RFL=' + IntToHex(RFlags));
    Halt;
  end;
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
  I: UInt8;
begin
  FillByte(IdtEntries, SizeOf(IdtEntries), 0);

  for I := 0 to 255 do begin
    Offset := IsrStubs[I];
    if Offset <> 0 then with IdtEntries[I] do begin
      OffsetHigh := Offset shr 32;
      OffsetMid := (Offset shr 16) and $FFFF;
      OffsetLow := Offset and $FFFF;
      Segment := $08;
      Flags := $8E;
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
{$ifndef NDEBUG}
  Log.DebugLn('IDT initialized.');
{$endif}
end;

end.
