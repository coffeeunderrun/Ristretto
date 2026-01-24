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

{****************************************************************************
                               Primitives
****************************************************************************}
procedure fpc_shortstr_shortstr_intern_charmove(const Src: ShortString; const SrcIndex: Byte; var Dest: ShortString; const DestIndex, Len: Byte); inline;
begin
  Move(Src[SrcIndex], Dest[DestIndex], Len);
end;

{****************************************************************************
                                 String
****************************************************************************}

procedure fpc_shortstr_to_shortstr(out Res: ShortString; const Str: ShortString); compilerproc; public name 'FPC_SHORTSTR_TO_SHORTSTR';
var
  StrLen: Byte;
begin
  StrLen := Length(Str);
  if StrLen > High(Res) then StrLen := High(Res);
  Move(Str[0], Res[0], StrLen + 1);
  Res[0] := Chr(StrLen);
end;

procedure fpc_shortstr_concat(var Dest: ShortString; const Str1, Str2: ShortString); compilerproc;
var
  StrLen1: Byte;
  StrLen2: Byte;
begin
  StrLen1 := Length(Str1);
  StrLen2 := Length(Str2);

  if StrLen1 + StrLen2 > High(Dest) then begin
    if StrLen1 > High(Dest) then StrLen1 := High(Dest);
    StrLen2 := High(Dest) - StrLen1;
  end;

  fpc_shortstr_shortstr_intern_charmove(Str2, 1, Dest, StrLen1 + 1, StrLen2);
  if @Dest <> @Str1 then fpc_shortstr_shortstr_intern_charmove(Str1, 1, Dest, 1, StrLen1);
  Dest[0] := Chr(StrLen1 + StrLen2);
end;

{****************************************************************************
                                 Str()
****************************************************************************}

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
