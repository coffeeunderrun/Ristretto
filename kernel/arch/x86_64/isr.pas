unit Isr;

interface

uses Cpu;

type
  TIsrHandler = procedure;

procedure RegisterHandler(Vector: UInt8; Handler: TIsrHandler);

implementation

uses Idt, SysUtils;

const
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

var
  IsrHandlers: array [0..255] of array of TIsrHandler;

procedure Handler(RegsPtr: PRegisters); public name '_handler';
var
  IsrHandler: TIsrHandler;
begin
  with RegsPtr^ do begin
    if Vector > 255 then begin
      WriteLn(LogError, 'Handler: invalid vector ', Vector);
      Panic;
    end;

    for IsrHandler in IsrHandlers[Vector] do IsrHandler;

    if (Vector > 31) and (Vector < 48) then begin
      AcknowledgeIrq(Code);
      exit;
    end;

    WriteLn(Format('Interrupt: %s', [Descriptions[Vector]]));
    WriteLn(Format('RAX=%.16X RBX=%.16X RCX=%.16X RDX=%.16X', [RAX, RBX, RCX, RDX]));
    WriteLn(Format('RSI=%.16X RDI=%.16X RBP=%.16X RSP=%.16X', [RSI, RDI, RBP, RSP]));
    WriteLn(Format('R8 =%.16X R9 =%.16X R10=%.16X R11=%.16X', [R8, R9, R10, R11]));
    WriteLn(Format('R12=%.16X R13=%.16X R14=%.16X R15=%.16X', [R12, R13, R14, R15]));
    WriteLn(Format('RIP=%.16X CS =%.16X RSP=%.16X SS =%.16X', [RIP, CS, RSP, SS]));
    WriteLn(Format('VEC=%.16X ERR=%.16X RFL=%.16X', [Vector, Code, RFlags]));

    Halt;
  end;
end;

procedure RegisterHandler(Vector: UInt8; Handler: TIsrHandler);
begin
  if Vector > 255 then begin
    WriteLn(LogError, 'RegisterHandler: invalid vector ', Vector);
    exit;
  end;

  SetLength(IsrHandlers[Vector], Length(IsrHandlers[Vector]) + 1);
  IsrHandlers[Vector][High(IsrHandlers[Vector])] := Handler;
  WriteLn(LogTrace, 'Registered handler for vector ', Vector);
end;

end.
