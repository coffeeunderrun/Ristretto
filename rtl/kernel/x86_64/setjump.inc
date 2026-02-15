{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2003 by Florian Klaempfl and other members of the
    Free Pascal development team

    SetJmp and LongJmp implementation for exception handling

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

function fpc_setjmp(var S:jmp_buf):longint;assembler;[public,alias:'FPC_SETJMP'];nostackframe;compilerproc;
  asm
    movq     %rbx,jmp_buf.rbx(%rdi)
    movq     %rbp,jmp_buf.rbp(%rdi)
    movq     %r12,jmp_buf.r12(%rdi)
    movq     %r13,jmp_buf.r13(%rdi)
    movq     %r14,jmp_buf.r14(%rdi)
    movq     %r15,jmp_buf.r15(%rdi)
    leaq     8(%rsp),%rax
    movq     %rax,jmp_buf.rsp(%rdi)
    movq     (%rsp),%rax
    movq     %rax,jmp_buf.rip(%rdi)
    xorl     %eax,%eax
  end;


procedure fpc_longjmp(var S:jmp_buf;value:longint);assembler;[public,alias:'FPC_LONGJMP'];nostackframe;compilerproc;
  asm
    cmpl     $1,%esi
    adcl     $0,%esi
    movl     %esi,%eax
    movq     jmp_buf.rbx(%rdi),%rbx
    movq     jmp_buf.rbp(%rdi),%rbp
    movq     jmp_buf.r12(%rdi),%r12
    movq     jmp_buf.r13(%rdi),%r13
    movq     jmp_buf.r14(%rdi),%r14
    movq     jmp_buf.r15(%rdi),%r15
    movq     jmp_buf.rsp(%rdi),%rsp
    jmpq     jmp_buf.rip(%rdi)
  end;
