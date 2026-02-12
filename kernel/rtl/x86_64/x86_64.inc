procedure ReadBarrier;assembler;nostackframe;
asm
  lfence
end;

procedure ReadDependencyBarrier;assembler;nostackframe;
asm
  { reads imply barrier on earlier reads depended on }
end;

procedure ReadWriteBarrier;assembler;nostackframe;
asm
  mfence
end;

procedure WriteBarrier;assembler;nostackframe;
asm
  sfence
end;
