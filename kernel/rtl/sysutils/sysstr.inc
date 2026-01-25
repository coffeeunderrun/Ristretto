{
    *********************************************************************
    Copyright (C) 1997, 1998 Gertjan Schouten

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

function IntToStr(Value: LongInt): String;
begin
  System.Str(Value, result);
end;

function IntToStr(Value: Int64): String;
begin
  System.Str(Value, result);
end;

function IntToStr(Value: QWord): String;
begin
  System.Str(Value, result);
end;

function UIntToStr(Value: QWord): String;
begin
  System.Str(Value, result);
end;

function UIntToStr(Value: Cardinal): String;
begin
  System.Str(Value, result);
end;

function IntToHex(Value: Longint; Digits: integer): string;
var i: integer;
begin
 If Digits=0 then
   Digits:=1;
 SetLength(result, digits);
 for i := 0 to digits - 1 do
  begin
   result[digits - i] := HexDigits[value and 15];
   value := value shr 4;
  end ;
 while value <> 0 do begin
   result := HexDigits[value and 15] + result;
   value := value shr 4;
 end;
end ;

function IntToHex(Value: int64; Digits: integer): string;
var i: integer;
begin
 If Digits=0 then
   Digits:=1;
 SetLength(result, digits);
 for i := 0 to digits - 1 do
  begin
   result[digits - i] := HexDigits[value and 15];
   value := value shr 4;
  end ;
 while value <> 0 do begin
   result := HexDigits[value and 15] + result;
   value := value shr 4;
 end;
end ;

function IntToHex(Value: QWord; Digits: integer): string;
begin
  result:=IntToHex(Int64(Value),Digits);
end;

function IntToHex(Value: Int8): string;
begin
  Result:=IntToHex(LongInt(Value) and $ff, 2*SizeOf(Int8));
end;

function IntToHex(Value: UInt8): string;
begin
  Result:=IntToHex(Value, 2*SizeOf(UInt8));
end;

function IntToHex(Value: Int16): string;
begin
  Result:=IntToHex(LongInt(Value) and $ffff, 2*SizeOf(Int16));
end;

function IntToHex(Value: UInt16): string;
begin
  Result:=IntToHex(Value, 2*SizeOf(UInt16));
end;

function IntToHex(Value: Int32): string;
begin
  Result:=IntToHex(Value, 2*SizeOf(Int32));
end;

function IntToHex(Value: UInt32): string;
begin
  Result:=IntToHex(LongInt(Value), 2*SizeOf(UInt32));
end;

function IntToHex(Value: Int64): string;
begin
  Result:=IntToHex(Value, 2*SizeOf(Int64));
end;

function IntToHex(Value: UInt64): string;
begin
  Result:=IntToHex(Value, 2*SizeOf(UInt64));
end;
