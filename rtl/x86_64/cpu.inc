procedure Halt; assembler; nostackframe;
asm
@loop:
  hlt
  jmp @loop
end;
