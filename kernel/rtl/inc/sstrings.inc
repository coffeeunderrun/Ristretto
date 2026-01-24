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

function Space(Value: byte): ShortString;
begin
  Space[0] := Chr(Value);
  FillChar(Space[1], Value, Ord(' '));
end;

{*****************************************************************************
                              Str() Helpers
*****************************************************************************}

procedure fpc_shortstr_sint(Value: ValSInt; Len: SizeInt; out Str: ShortString); compilerproc; public name 'FPC_SHORTSTR_SINT';
begin
  int_str(Value, Str);
  if Length(Str) < Len then Str := Space(Len - Length(str)) + Str;
end;

procedure fpc_shortstr_uint(Value: ValUInt; Len: SizeInt; out Str: ShortString); compilerproc; public name 'FPC_SHORTSTR_UINT';
begin
  int_str_unsigned(Value, Str);
  if Length(Str) < Len then Str := Space(Len - Length(Str)) + Str;
end;
