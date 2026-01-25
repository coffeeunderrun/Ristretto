{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by the Free Pascal development team

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{****************************************************************************
                    subroutines for string handling
****************************************************************************}

procedure fpc_Shortstr_SetLength(var s:shortstring;len:SizeInt);[Public,Alias : 'FPC_SHORTSTR_SETLENGTH']; compilerproc;
begin
  if len<0 then
    len:=0;
  if len>high(s) then
    len:=high(s);
  s[0]:=chr(len);
end;

function space (b : byte): shortstring;
begin
  space[0] := chr(b);
  FillChar (Space[1],b, Ord(' '));
end;

{*****************************************************************************
                              Str() Helpers
*****************************************************************************}

procedure fpc_shortstr_SInt(v : valSInt;len : SizeInt;out s : shortstring);[public,alias:'FPC_SHORTSTR_SINT']; compilerproc;
begin
  int_str(v,s);
  if length(s)<len then
    s:=space(len-length(s))+s;
end;


procedure fpc_shortstr_UInt(v : valUInt;len : SizeInt;out s : shortstring);[public,alias:'FPC_SHORTSTR_UINT']; compilerproc;
begin
  int_str_unsigned(v,s);
  if length(s)<len then
    s:=space(len-length(s))+s;
end;
