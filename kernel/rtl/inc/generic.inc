{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by the Free Pascal development team.

    Processor independent implementation for the system unit
    (adapted for intel i386.inc file)

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

function align(addr : PtrUInt;alignment : PtrUInt) : PtrUInt;
var
  tmp,am1 : PtrUInt;
begin
  am1:=alignment-1;
  tmp:=addr+am1;
  if alignment and am1=0 then
    { Alignment is a power of two. In practice alignments are powers of two 100% of the time. }
    result:=tmp and not am1
  else
    result:=tmp-(tmp mod alignment);
end;

function align(addr : Pointer;alignment : PtrUInt) : Pointer;
var
  tmp,am1 : PtrUInt;
begin
  am1:=alignment-1;
  tmp:=PtrUint(addr)+am1;
  if alignment and am1=0 then
    result:=pointer(tmp and not am1)
  else
    result:=pointer(ptruint(tmp-(tmp mod alignment)));
end;

{****************************************************************************
                               Primitives
****************************************************************************}
procedure fpc_shortstr_shortstr_intern_charmove(const src: shortstring; const srcindex: byte; var dst: shortstring; const dstindex, len: byte); {$ifdef SYSTEMINLINE}inline;{$endif}
begin
  move(src[srcindex],dst[dstindex],len);
end;

procedure Move(const source;var dest;count:SizeInt);[public, alias: 'FPC_MOVE'];
var
  aligncount : sizeint;
  pdest,psrc,pend : pbyte;
begin
  if (@dest=@source) or (count<=0) then
    exit;
  if (@dest<@source) or (@source+count<@dest) then
    begin
      { Forward Move }
      psrc:=@source;
      pdest:=@dest;
      if (Count>4*sizeof(ptruint)-11)
        then
        begin
          { Align on native pointer size }
          aligncount:=(sizeof(PtrUInt)-PtrInt(pdest)) and (sizeof(PtrUInt)-1);
          dec(count,aligncount);
          pend:=psrc+aligncount;
          while psrc<pend do
            begin
              pdest^:=psrc^;
              inc(pdest);
              inc(psrc);
            end;
          { use sizeuint typecast to force shr optimization }
          pptruint(pend):=pptruint(psrc)+(sizeuint(count) div sizeof(ptruint));
          while psrc<pend do
            begin
              pptruint(pdest)^:=pptruint(psrc)^;
              inc(pptruint(pdest));
              inc(pptruint(psrc));
            end;
          count:=count and (sizeof(PtrUInt)-1);
        end;
      pend:=psrc+count;
      while psrc<pend do
        begin
          pdest^:=psrc^;
          inc(pdest);
          inc(psrc);
        end;
    end
  else
    begin
      { Backward Move }
      psrc:=@source+count;
      pdest:=@dest+count;
      if (Count>4*sizeof(ptruint)-11)
        then
        begin
          { Align on native pointer size }
          aligncount:=(PtrUInt(pdest) and (sizeof(PtrUInt)-1));
          dec(count,aligncount);
          pend:=psrc-aligncount;
          while psrc>pend do
            begin
              dec(pdest);
              dec(psrc);
              pdest^:=psrc^;
            end;
          { use sizeuint typecast to force shr optimization }
          pptruint(pend):=pptruint(psrc)-(sizeuint(count) div sizeof(ptruint));
          while psrc>pend do
            begin
              dec(pptruint(pdest));
              dec(pptruint(psrc));
              pptruint(pdest)^:=pptruint(psrc)^;
            end;
          count:=count and (sizeof(PtrUInt)-1);
        end;
      pend:=psrc-count;
      while psrc>pend do
        begin
          dec(pdest);
          dec(psrc);
          pdest^:=psrc^;
        end;
    end;
end;

Procedure FillChar(var x;count:SizeInt;value:byte);
var
  pdest,pend : pbyte;
  v : ALUUInt;
begin
  if count <= 0 then
    exit;
  pdest:=@x;
  if Count>4*sizeof(ptruint)-1 then
    begin
{$if sizeof(v)>=2}
      v:=(value shl 8) or value;
{$endif sizeof(v)>=2}
{$if sizeof(v)>=4}
      v:=(v shl 16) or v;
{$endif sizeof(v)>=4}
{$if sizeof(v)=8}
      v:=(v shl 32) or v;
{$endif sizeof(v)=8}
      { Align on native pointer size }
      pend:=pbyte(align(pdest,sizeof(PtrUInt)));
      dec(count,pend-pdest);
      while pdest<pend do
        begin
          pdest^:=value;
          inc(pdest);
        end;
      { use sizeuint typecast to force shr optimization }
      pptruint(pend):=pptruint(pdest)+(sizeuint(count) div sizeof(ptruint));
      while pdest<pend do
        begin
          pptruint(pdest)^:=v;
          inc(pptruint(pdest));
        end;
      count:=count and (sizeof(ptruint)-1);
    end;
  pend:=pdest+count;
  while pdest<pend do
    begin
      pdest^:=value;
      inc(pdest);
    end;
end;

procedure fillword(var x;count : SizeInt;value : word);
var
  aligncount : sizeint;
  pdest,pend : pword;
  v : ALUUInt;
begin
  if count <= 0 then
    exit;
  pdest:=@x;
  if Count>4*sizeof(ptruint)-1 then
    begin
{$if sizeof(v)>=4}
      v:=(value shl 16) or value;
{$endif sizeof(v)>=4}
{$if sizeof(v)=8}
      v:=(v shl 32) or v;
{$endif sizeof(v)=8}
      { Align on native pointer size }
      aligncount:=(PtrUInt(pdest) and (sizeof(PtrUInt)-1)) shr 1;
      dec(count,aligncount);
      pend:=pdest+aligncount;
      while pdest<pend do
        begin
          pdest^:=value;
          inc(pdest);
        end;
      { use sizeuint typecast to force shr optimization }
      pptruint(pend):=pptruint(pdest)+((sizeuint(count)*2) div sizeof(ptruint));
      while pdest<pend do
        begin
          pptruint(pdest)^:=v;
          inc(pptruint(pdest));
        end;
      count:=((count*2) and (sizeof(ptruint)-1)) shr 1;
    end;
  pend:=pdest+count;
  while pdest<pend do
    begin
      pdest^:=value;
      inc(pdest);
    end;
end;

procedure filldword(var x;count : SizeInt;value : dword);
var
  aligncount : sizeint;
  pdest,pend : pdword;
  v : ALUUInt;
begin
  if count <= 0 then
    exit;
  pdest:=@x;
  if Count>4*sizeof(ptruint)-1 then
    begin
      v:=value;
{$if sizeof(v)=8}
      v:=(v shl 32) or v;
{$endif sizeof(v)=8}
      { Align on native pointer size }
      aligncount:=(PtrUInt(pdest) and (sizeof(PtrUInt)-1)) shr 2;
      dec(count,aligncount);
      pend:=pdest+aligncount;
      while pdest<pend do
        begin
          pdest^:=value;
          inc(pdest);
        end;
      { use sizeuint typecast to force shr optimization }
      pptruint(pend):=pptruint(pdest)+((sizeuint(count)*4) div sizeof(ptruint));
      while pdest<pend do
        begin
          pptruint(pdest)^:=v;
          inc(pptruint(pdest));
        end;
      count:=((count*4) and (sizeof(ptruint)-1)) shr 2;
    end;
  pend:=pdest+count;
  while pdest<pend do
    begin
      pdest^:=value;
      inc(pdest);
    end;
end;

procedure fillqword(var x;count : SizeInt;value : qword);
var
  pdest,pend : pqword;
begin
  if count <= 0 then
    exit;
  pdest:=@x;
  pend:=pdest+count;
  while pdest<pend do
    begin
      pdest^:=value;
      inc(pdest);
    end;
end;

function IndexByte(Const buf;len:SizeInt;b:byte):SizeInt;
var
  psrc,pend : pbyte;
begin
  psrc:=@buf;
  pend:=psrc+len;
  { simulate assembler implementations behaviour, which is expected }
  { fpc_pchar_to_ansistr in astrings.inc                            }
  if (len < 0) or
     (pend < psrc) then
    pend:=pbyte(high(PtrUInt)-PtrUint(sizeof(byte)));
  while (psrc<pend) and (psrc^<>b) do
    inc(psrc);
  if psrc<pend then
    result:=psrc-pbyte(@buf)
  else
    result:=-1;
end;

{****************************************************************************
                                 String
****************************************************************************}

procedure fpc_shortstr_to_shortstr(out res:shortstring; const sstr: shortstring);[public,alias:'FPC_SHORTSTR_TO_SHORTSTR']; compilerproc;
var
  slen : byte;
begin
  slen:=length(sstr);
  if slen>high(res) then
    slen:=high(res);
  move(sstr[0],res[0],slen+1);
  res[0]:=chr(slen);
end;

procedure fpc_shortstr_concat(var dests:shortstring;const s1,s2:shortstring);compilerproc;
var
  s1l, s2l : ObjpasInt;
begin
  s1l:=length(s1);
  s2l:=length(s2);
  if s1l+s2l>high(dests) then
    begin
      if s1l>high(dests) then
        s1l:=high(dests);
      s2l:=high(dests)-s1l;
    end;
  { Copy s2 first, as in the case of @dests = @s2 it must be copied first and in other cases the order does not matter. }
  fpc_shortstr_shortstr_intern_charmove(s2,1,dests,s1l+1,s2l);
  if @dests<>@s1 then
    fpc_shortstr_shortstr_intern_charmove(s1,1,dests,1,s1l);
  dests[0]:=chr(s1l+s2l);
end;

procedure fpc_shortstr_concat_multi(var dests:shortstring;const sarr:array of pshortstring);compilerproc;
var
  i,s2l,Len,destpos0 : ObjpasInt;
  p : pshortstring;
begin
  Len:=0;
  i:=0;
  while (i<=high(sarr)) do
    begin
      p:=sarr[i];
      if assigned(p) then
        inc(Len,length(p^));
      inc(i);
    end;
  destpos0:=Len;
  { Copy strings from the last to the first, so that possible occurences of DestS read correct DestS.
    DestS[0] = length(DestS) must have its original value for a while! }
  while (destpos0>0) do
    begin
      dec(i);
      p:=sarr[i];
      if not assigned(p) then
        continue;
      s2l:=length(p^);
      dec(destpos0,s2l);
      if (destpos0=0) and (p=@dests) then { Skip moving DestS to itself when appending. This destpos0-based form also catches DestS := '' + '' + DestS. }
        break;
      if destpos0+s2l>high(dests) then
        begin
          if destpos0>=high(dests) then
            continue;
          s2l:=high(dests)-destpos0;
        end;
      fpc_shortstr_shortstr_intern_charmove(p^,1,dests,destpos0+1,s2l);
    end;
  if Len>high(dests) then
    Len:=high(dests);
  dests[0]:=Chr(Len); { Careful, loop above relies on DestS[0] having the original value. }
end;

procedure fpc_pchar_to_shortstr(out res : shortstring;p:PAnsiChar);[public,alias:'FPC_PCHAR_TO_SHORTSTR']; compilerproc;
var
  l : ObjpasInt;
begin
  if p=nil then
    begin
      res[0]:=#0;
      exit;
    end;
{ On platforms where IndexByte with len > 0 will not read the invalid memory past the null terminator, high(res) can be used as a limit. }
{$if defined(cpui386) or defined(cpux86_64)}
  l:=IndexByte(p^,high(res),0);
  if l<0 then
    l:=high(res);
{$else IndexByte(p^,high(res),0) can crash}
  l:=strlen(p);
  if l>high(res) then
    l:=high(res);
{$endif IndexByte(p^,high(res),0) can crash}
  move(p^,res[1],l);
  res[0]:=chr(l);
end;

{****************************************************************************
                                 Str()
****************************************************************************}

procedure int_str(l:longint;out s:shortstring);
var
  m,m1 : longword;
  pcstart,
  pc2start,
  pc,pc2 : PAnsiChar;
  hs : string[32];
  overflow : longint;
begin
  pc2start:=@s[1];
  pc2:=pc2start;
  if (l<0) then
    begin
      pc2^:='-';
      inc(pc2);
      m:=longword(-l);
    end
  else
    m:=longword(l);
  pcstart:=PAnsiChar(@hs[0]);
  pc:=pcstart;
  repeat
    m1:=m div 10;
    inc(pc);
    pc^:=AnsiChar(m-(m1*10)+byte('0'));
    m:=m1;
  until m=0;
  overflow:=(pc-pcstart)+(pc2-pc2start)-high(s);
  if overflow>0 then
    inc(pcstart,overflow);
  while (pc>pcstart) do
    begin
      pc2^:=pc^;
      inc(pc2);
      dec(pc);
    end;
  s[0]:=AnsiChar(pc2-pc2start);
end;

procedure int_str_unsigned(l:longword;out s:shortstring);
var
  m1 : longword;
  pcstart,
  pc2start,
  pc,pc2 : PAnsiChar;
  hs : string[32];
  overflow : longint;
begin
  pc2start:=@s[1];
  pc2:=pc2start;
  pcstart:=PAnsiChar(@hs[0]);
  pc:=pcstart;
  repeat
    inc(pc);
    m1:=l div 10;
    pc^:=AnsiChar(l-(m1*10)+byte('0'));
    l:=m1;
  until l=0;
  overflow:=(pc-pcstart)-high(s);
  if overflow>0 then
    inc(pcstart,overflow);
  while (pc>pcstart) do
    begin
      pc2^:=pc^;
      inc(pc2);
      dec(pc);
    end;
  s[0]:=AnsiChar(pc2-pc2start);
end;

procedure int_str(l:int64;out s:shortstring);
var
  m,m1 : qword;
  pcstart,
  pc2start,
  pc,pc2 : PAnsiChar;
  hs : string[32];
  overflow : longint;
begin
  pc2start:=@s[1];
  pc2:=pc2start;
  if (l<0) then
    begin
      pc2^:='-';
      inc(pc2);
      m:=qword(-l);
    end
  else
    m:=qword(l);
  pcstart:=PAnsiChar(@hs[0]);
  pc:=pcstart;
  repeat
    m1:=m div 10;
    inc(pc);
    pc^:=AnsiChar(m-(m1*10)+byte('0'));
    m:=m1;
  until m=0;
  overflow:=(pc-pcstart)+(pc2-pc2start)-high(s);
  if overflow>0 then
    inc(pcstart,overflow);
  while (pc>pcstart) do
    begin
      pc2^:=pc^;
      inc(pc2);
      dec(pc);
    end;
  s[0]:=AnsiChar(pc2-pc2start);
end;

procedure int_str_unsigned(l:qword;out s:shortstring);
var
  m1 : qword;
  pcstart,
  pc2start,
  pc,pc2 : PAnsiChar;
  hs : string[64];
  overflow : longint;
begin
  pc2start:=@s[1];
  pc2:=pc2start;
  pcstart:=PAnsiChar(@hs[0]);
  pc:=pcstart;
  repeat
    inc(pc);
    m1:=l div 10;
    pc^:=AnsiChar(l-(m1*10)+byte('0'));
    l:=m1;
  until l=0;
  overflow:=(pc-pcstart)-high(s);
  if overflow>0 then
    inc(pcstart,overflow);
  while (pc>pcstart) do
    begin
      pc2^:=pc^;
      inc(pc2);
      dec(pc);
    end;
  s[0]:=AnsiChar(pc2-pc2start);
end;
