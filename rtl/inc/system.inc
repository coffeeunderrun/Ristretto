{
    This file is part of the Free Pascal Run time library.
    Copyright (c) 1999-2008 by the Free Pascal development team

    See the file COPYING.FPC, included in this distribution,
    For details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

procedure fpc_initializeunits;
begin
end;

procedure fpc_do_exit;
begin
end;

procedure fpc_shortstr_to_shortstr(out Res: ShortString; const Str: ShortString); compilerproc;
var
  StrLen: Byte;
begin
  StrLen := Length(Str);
  if StrLen > High(Res) then StrLen := High(Res);
  Move(Str[0], Res[0], StrLen + 1);
  Res[0] := Char(StrLen);
end;

{****************************************************************************
                        Processor specific routines
****************************************************************************}
{$I memory.inc}

{*****************************************************************************
                          Init / Exit / ExitProc
*****************************************************************************}
{$I cpu.inc}
