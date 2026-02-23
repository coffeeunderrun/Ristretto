uses Cpu, SysUtils;

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
  IsrHandlers: array [0..255] of array of TIsrHandler;

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

procedure Handler(RegsPtr: PRegisters); public name '_handler';
var
  IsrHandler: TIsrHandler;
begin
  with RegsPtr^ do begin
    if Vector > 255 then begin
      WriteLn(LogError, Format('%s:%s - Invalid vector %d.', [{$I %FILE%}, {$I %LINE%}, Vector]));
      exit;
    end;

    for IsrHandler in IsrHandlers[Vector] do IsrHandler;

    if (Vector > 31) and (Vector < 48) then begin
      AcknowledgeIrq(Code);
      exit;
    end;

    WriteLn(Format('Interrupt: %s', [Descriptions[Vector]]));
    WriteLn(Format('RAX=$%.16X RBX=$%.16X RCX=$%.16X RDX=$%.16X', [RAX, RBX, RCX, RDX]));
    WriteLn(Format('RSI=$%.16X RDI=$%.16X RBP=$%.16X RSP=$%.16X', [RSI, RDI, RBP, RSP]));
    WriteLn(Format('R8 =$%.16X R9 =$%.16X R10=$%.16X R11=$%.16X', [R8, R9, R10, R11]));
    WriteLn(Format('R12=$%.16X R13=$%.16X R14=$%.16X R15=$%.16X', [R12, R13, R14, R15]));
    WriteLn(Format('RIP=$%.16X CS =$%.16X SS =$%.16X', [RIP, CS, SS]));
    WriteLn(Format('VEC=$%.16X ERR=$%.16X RFL=$%.16X', [Vector, Code, RFlags]));
    WriteLn(Format('CR0=$%.16X CR2=$%.16X CR3=$%.16X CR4=$%.16X', [ReadCR0, ReadCR2, ReadCR3, ReadCR4]));

    Halt;
  end;
end;

procedure Initialize;
begin
  InitializePics;
  PopulateIdt;
  LoadIdt;
  WriteLn(LogInfo, 'IDT initialized.');
end;

procedure RegisterHandler(Vector: UInt8; Handler: TIsrHandler);
begin
  SetLength(IsrHandlers[Vector], Length(IsrHandlers[Vector]) + 1);
  IsrHandlers[Vector][High(IsrHandlers[Vector])] := Handler;
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Register handler: vector=%d.', [Vector]));
  {$endif}
end;
