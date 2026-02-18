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

implementation

uses SysUtils;

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
  WriteLn(LogDebug,Format('CPUID: EAX=%.8X, EBX=%.8X, ECX=%.8X, EDX=%.8X', [Version, Additional, Features1, Features2]));
  {$endif}

  // Set up PAT, if supported, using defaults; except for PAT5 = Write Combining
  if Features2 and (1 shl 16) <> 0 then asm
    mov eax, $00070406 // PAT3=UC, PAT2=UC-, PAT1=WT, PAT0=WB
    mov edx, $00070106 // PAT7=UC, PAT6=UC-, PAT5=WC, PAT4=WB
    mov ecx, $277
    wrmsr
  end ['rax', 'rcx', 'rdx'];
end;

procedure LoadRootFrame(RootFrame: PtrUInt); assembler; nostackframe; public name '_arch_load_root_frame';
asm
  mov rax, RootFrame
  mov cr3, rax
end;

procedure InvalidatePage(Page: PtrUInt); assembler; nostackframe; public name '_arch_invalidate_page';
asm
  mov rax, Page
  invlpg [rax]
end;

end.
