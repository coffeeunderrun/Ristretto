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
                                 String
****************************************************************************}

procedure fpc_shortstr_to_shortstr(out Res: String; const Str: String); compilerproc; export; alias: 'FPC_SHORTSTR_TO_SHORTSTR';
var
  StrLen: Byte;
begin
  StrLen := Length(Str);
  if StrLen > High(Res) then StrLen := High(Res);
  Move(Str[0], Res[0], StrLen + 1);
  Res[0] := Char(StrLen);
end;
