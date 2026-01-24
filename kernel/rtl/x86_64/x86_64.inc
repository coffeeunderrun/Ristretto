{$asmmode intel}

{ NOTE: Assumes default 'register' calling convention using 'Linux' target, i.e., System V ABI }

procedure Move(const Source; var Dest; Count: SizeUInt); assembler; nostackframe;
// Source: RDI; Dest: RSI; Count: RDX
asm
  mov rcx, rdi // RCX <= Source (temporary)
  mov rdi, rsi // RDI <= Dest
  mov rsi, rcx // RSI <= Source
  mov rcx, rdx // RCX <= Count

  cmp rdi, rsi
  je @done
  jb @dest_below_source

@dest_above_source:
  std          // Decrement index registers
  add rdi, rcx // RDI <= Dest - Count
  add rsi, rcx // RSI <= Source - Count

@dest_below_source:
  rep movsb

@done:
  cld
end;

procedure FillChar(var Dest; Count: SizeUInt; Value: Byte); assembler; nostackframe;
// Dest: RDI; Count: RSI; Value: RDX
asm
  mov rcx, rsi // RCX <= Count
  mov rax, rdx // RAX <= Value
  rep stosb
end;
