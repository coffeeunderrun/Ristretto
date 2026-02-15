{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2002 by Florian Klaempfl and Sergei Gorelkin
    Members of the Free Pascal development team

    Processor dependent implementation for the system unit for
    the x86-64 architecture

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$asmmode GAS}

{ Generic implementations of Move, FillChar, Index, and Compare can be found in rtl/inc/generic.inc
  This is to avoid using XMM registers in the kernel. }

{$define FPC_SYSTEM_HAS_SPTR}
Function Sptr : Pointer;assembler;nostackframe;
asm
        movq    %rsp,%rax
end;

{$define FPC_SYSTEM_HAS_GET_CALLER_ADDR}
function get_caller_addr(framebp:pointer;addr:pointer=nil):pointer;
begin
  get_caller_addr:=framebp;
  if assigned(framebp) then
    get_caller_addr:=PPointer(framebp)[1];
end;

{$define FPC_SYSTEM_HAS_GET_CALLER_FRAME}
function get_caller_frame(framebp:pointer;addr:pointer=nil):pointer;
begin
  get_caller_frame:=framebp;
  if assigned(framebp) then
    get_caller_frame:=PPointer(framebp)^;
end;

{$ifdef VER3_2}
function InterLockedDecrement (var Target: longint) : longint; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_DEC_32}
function fpc_atomic_dec_32 (var Target: longint) : longint; assembler; nostackframe;
{$endif VER3_2}
asm
        movl    $-1,%eax
        lock
        xaddl   %eax, {$ifdef FPC_ABI_WIN64} (%rcx) {$else} (%rdi) {$endif}
        decl    %eax
end;

{$ifdef VER3_2}
function InterLockedIncrement (var Target: longint) : longint; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_INC_32}
function fpc_atomic_inc_32 (var Target: longint) : longint; assembler; nostackframe;
{$endif VER3_2}
asm
        movl    $1,%eax
        lock
        xaddl   %eax, {$ifdef FPC_ABI_WIN64} (%rcx) {$else} (%rdi) {$endif}
        incl    %eax
end;

{$ifdef VER3_2}
function InterLockedExchange (var Target: longint;Source : longint) : longint; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_XCHG_32}
function fpc_atomic_xchg_32 (var Target: longint;Source : longint) : longint; assembler; nostackframe;
{$endif VER3_2}
asm
        xchgl   ({$ifdef FPC_ABI_WIN64} %rcx {$else} %rdi {$endif}),Source
        movl    Source,%eax
end;

{$ifdef VER3_2}
function InterLockedExchangeAdd (var Target: longint;Source : longint) : longint; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_ADD_32}
function fpc_atomic_add_32 (var Target: longint;Value : longint) : longint; assembler; nostackframe;
{$endif VER3_2}
asm
        lock
        xaddl   {$ifdef VER3_2} Source {$else} Value {$endif},({$ifdef FPC_ABI_WIN64} %rcx {$else} %rdi {$endif})
        movl    {$ifdef VER3_2} Source {$else} Value {$endif},%eax
end;

{$ifdef VER3_2}
function InterLockedCompareExchange(var Target: longint; NewValue, Comperand : longint): longint; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_CMP_XCHG_32}
function fpc_atomic_cmp_xchg_32 (var Target: longint; NewValue, Comparand : longint) : longint; assembler; nostackframe;
{$endif VER3_2}
asm
        movl            {$ifdef VER3_2} Comperand {$else} Comparand {$endif},%eax
        lock
        cmpxchgl        NewValue,({$ifdef FPC_ABI_WIN64} %rcx {$else} %rdi {$endif})
end;

{$ifdef VER3_2}
function InterLockedDecrement64 (var Target: int64) : int64; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_DEC_64}
function fpc_atomic_dec_64 (var Target: int64) : int64; assembler; nostackframe;
{$endif VER3_2}
asm
        movq    $-1,%rax
        lock
        xaddq   %rax, {$ifdef FPC_ABI_WIN64} (%rcx) {$else} (%rdi) {$endif}
        decq    %rax
end;

{$ifdef VER3_2}
function InterLockedIncrement64 (var Target: int64) : int64; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_INC_64}
function fpc_atomic_inc_64 (var Target: int64) : int64; assembler; nostackframe;
{$endif VER3_2}
asm
        movq    $1,%rax
        lock
        xaddq   %rax, {$ifdef FPC_ABI_WIN64} (%rcx) {$else} (%rdi) {$endif}
        incq    %rax
end;

{$ifdef VER3_2}
function InterLockedExchange64 (var Target: int64;Source : int64) : int64; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_XCHG_64}
function fpc_atomic_xchg_64 (var Target: int64;Source: int64) : int64; assembler; nostackframe;
{$endif VER3_2}
asm
        xchgq   ({$ifdef FPC_ABI_WIN64} %rcx {$else} %rdi {$endif}),Source
        movq    Source,%rax
end;

{$ifdef VER3_2}
function InterLockedExchangeAdd64 (var Target: int64;Source : int64) : int64; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_ADD_64}
function fpc_atomic_add_64 (var Target: int64;Value: int64) : int64; assembler; nostackframe;
{$endif VER3_2}
asm
        lock
        xaddq   {$ifdef VER3_2} Source {$else} Value {$endif},({$ifdef FPC_ABI_WIN64} %rcx {$else} %rdi {$endif})
        movq    {$ifdef VER3_2} Source {$else} Value {$endif},%rax
end;

{$ifdef VER3_2}
function InterLockedCompareExchange64(var Target: int64; NewValue, Comperand : int64): int64; assembler; nostackframe;
{$else VER3_2}
{$define FPC_SYSTEM_HAS_ATOMIC_CMP_XCHG_64}
function fpc_atomic_cmp_xchg_64 (var Target: int64; NewValue, Comparand : int64) : int64; [public, alias:'FPC_ATOMIC_CMP_XCHG_64']; assembler; nostackframe;
{$endif VER3_2}
asm
        movq            {$ifdef VER3_2} Comperand {$else} Comparand {$endif},%rax
        lock
        cmpxchgq        NewValue,({$ifdef FPC_ABI_WIN64} %rcx {$else} %rdi {$endif})
end;
