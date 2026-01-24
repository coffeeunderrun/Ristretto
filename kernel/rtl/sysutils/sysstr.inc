{
    *********************************************************************
    Copyright (C) 1997, 1998 Gertjan Schouten

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

function IntToStr(Value: Int64): String;
begin
  System.Str(Value, result);
end;

function UIntToStr(Value: Uint64): String;
begin
  result := IntToStr(Value);
end;
