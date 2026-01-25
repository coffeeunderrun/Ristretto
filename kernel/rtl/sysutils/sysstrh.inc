{
    *********************************************************************
    Copyright (C) 1997, 1998 Gertjan Schouten

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

function IntToStr(Value: LongInt): String; inline;
function IntToStr(Value: Int64): String; inline;
function IntToStr(Value: QWord): String; inline;
function UIntToStr(Value: QWord): String; inline;
function UIntToStr(Value: Cardinal): String; inline;

function IntToHex(Value: Longint; Digits: integer): string;
function IntToHex(Value: Int64; Digits: integer): string;
function IntToHex(Value: QWord; Digits: integer): string; inline;
function IntToHex(Value: Int8): string; inline;
function IntToHex(Value: UInt8): string; inline;
function IntToHex(Value: Int16): string; inline;
function IntToHex(Value: UInt16): string; inline;
function IntToHex(Value: Int32): string; inline;
function IntToHex(Value: UInt32): string; inline;
function IntToHex(Value: Int64): string; inline;
function IntToHex(Value: UInt64): string; inline;
