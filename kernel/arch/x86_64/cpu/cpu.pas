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

procedure Initialize;

function ReadCR0: UInt64; inline;
function ReadCR2: UInt64; inline;
function ReadCR3: UInt64; inline;
function ReadCR4: UInt64; inline;

function GetProcId: UInt32; inline;
function GetGdtPtr: Pointer; inline;
function GetTssPtr: Pointer; inline;
function GetThreadId: TThreadId; inline;

procedure SetProcId(Id: UInt32); inline;
procedure SetGdtPtr(GdtPtr: Pointer); inline;
procedure SetTssPtr(TssPtr: Pointer); inline;
procedure SetThreadId(Id: TThreadId); inline;

implementation

uses HeapMgr, SysUtils;

const
  IA32_GS_BASE = $C0000101;
  IA32_KERNEL_GS_BASE = $C0000102;

type
  PCpu = ^TCpu;
  TCpu = record
    ProcId: UInt32;
    GdtPtr: Pointer;
    TssPtr: Pointer;
    ThreadId: TThreadId;
  end;

procedure CreateCpuStructure;
var
  CpuPtr: PCpu;
begin
  CpuPtr := GetAlignedMem(SizeOf(TCpu), 64);
  if not Assigned(CpuPtr) then Panic('Failed to allocate CPU structure.');

  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Allocate CPU structure: addr=$%.16X, size=%d bytes.', [PtrUInt(CpuPtr), SizeOf(TCpu)]));
  {$endif}

  asm
    mov ecx, IA32_GS_BASE
    mov eax, CpuPtr
    mov rdx, CpuPtr
    shr rdx, 32
    wrmsr
  end ['rax'];
end;

procedure Initialize;
var
  Version, Additional, Features1, Features2: UInt32;
begin
  asm
    mov eax, 1
    cpuid
    mov [Version], eax
    mov [Additional], ebx
    mov [Features1], ecx
    mov [Features2], edx
  end ['rax', 'rbx', 'rcx', 'rdx'];

  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('CPUID: EAX=$%.8X, EBX=$%.8X, ECX=$%.8X, EDX=$%.8X.',
    [Version, Additional, Features1, Features2]));
  {$endif}

  // Set up PAT, if supported, using defaults; except for PAT5 = Write Combining
  if Features2 and (1 shl 16) <> 0 then asm
    mov eax, $00070406 // PAT3=UC, PAT2=UC-, PAT1=WT, PAT0=WB
    mov edx, $00070106 // PAT7=UC, PAT6=UC-, PAT5=WC, PAT4=WB
    mov ecx, $277
    wrmsr
  end ['rax', 'rcx', 'rdx'];

  CreateCpuStructure;
end;

function ReadCR0: UInt64; assembler; nostackframe;
asm
  mov rax, cr0
end;

function ReadCR2: UInt64; assembler; nostackframe;
asm
  mov rax, cr2
end;

function ReadCR3: UInt64; assembler; nostackframe;
asm
  mov rax, cr3
end;

function ReadCR4: UInt64; assembler; nostackframe;
asm
  mov rax, cr4
end;

procedure WriteCR3(Value: UInt64); assembler; nostackframe; public name '_arch_load_root_frame';
asm
  mov rax, Value
  mov cr3, rax
end;

procedure InvalidatePage(Page: PtrUInt); assembler; nostackframe; public name '_arch_invalidate_page';
asm
  mov rax, Page
  invlpg [rax]
end;

function GetProcId: UInt32; assembler; nostackframe;
asm
  mov eax, gs:[TCpu.ProcId]
end;

function GetGdtPtr: Pointer; assembler; nostackframe;
asm
  mov rax, gs:[TCpu.GdtPtr]
end;

function GetTssPtr: Pointer; assembler; nostackframe;
asm
  mov rax, gs:[TCpu.TssPtr]
end;

function GetThreadId: TThreadId; assembler; nostackframe;
asm
  mov rax, gs:[TCpu.ThreadId]
end;

procedure SetProcId(Id: UInt32); assembler; nostackframe;
asm
  mov gs:[TCpu.ProcId], edi
end;

procedure SetGdtPtr(GdtPtr: Pointer); assembler; nostackframe;
asm
  mov gs:[TCpu.GdtPtr], rdi
end;

procedure SetTssPtr(TssPtr: Pointer); assembler; nostackframe;
asm
  mov gs:[TCpu.TssPtr], rdi
end;

procedure SetThreadId(Id: TThreadId); assembler; nostackframe;
asm
  mov gs:[TCpu.ThreadId], rdi
end;

end.
