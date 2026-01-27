unit Cpu;

interface

type
  PRegisters = ^TRegisters;
  TRegisters = record
    RAX, RBX, RCX, RDX, RBP, RSI, RDI: UInt64;
    R8, R9, R10, R11, R12, R13, R14, R15: UInt64;
    Vector, Code: UInt64;
    RIP, CS, RFlags, RSP, SS: UInt64;
  end;

implementation

end.
