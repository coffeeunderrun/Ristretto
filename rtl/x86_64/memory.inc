procedure Move(const Source; var Dest; Count: SizeUInt); assembler; nostackframe;
{ TODO: Optimize this for kernel and user }
asm
  pushfq
  mov rcx, rdi // RCX = Source (temporary)
  mov rdi, rsi // RDI = Dest
  mov rsi, rcx // RSI = Source
  mov rcx, rdx // RCX = Count

  cmp rdi, rsi
  je @done
  jb @dest_below_source

@dest_above_source:
  std          // Decrement index registers
  add rdi, rcx // RDI = Dest - Count
  add rsi, rcx // RSI = Source - Count

@dest_below_source:
  rep movsb

@done:
  popfq
end;
