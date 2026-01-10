{
    This file contains the OS independent declarations of the system unit

    This file is part of the Free Pascal Run time library.
    Copyright (c) 1999-2005 by the Free Pascal development team

    See the File COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$I-,Q-,H-,R-,V-,S-}

Type
  HResult  = type LongInt;
  DWord    = LongWord;
  Cardinal = LongWord;
  Integer  = SmallInt;

  PByte = ^Byte;
  PChar = ^Char;
  PWord = ^Word;
  PDWord = ^DWord;
  PQWord = ^QWord;

  Int8   = ShortInt;
  Int16  = SmallInt;
  Int32  = Longint;
  IntPtr = Int64;

  PInt8   = ^Int8;
  PInt16  = ^Int16;
  PInt32  = ^Int32;
  PInt64  = ^Int64;
  PIntPtr = ^IntPtr;

  UInt8   = Byte;
  UInt16  = Word;
  UInt32  = DWord;
  UInt64  = QWord;
  UIntPtr = QWord;

  PUInt8   = ^UInt8;
  PUInt16  = ^UInt16;
  PUInt32  = ^UInt32;
  PUInt64  = ^UInt64;
  PUIntPtr = ^UIntPtr;

  SizeInt  = Int64;
  SizeUInt = UInt64;

{$IF DECLARED(AnsiChar)}
  Char = AnsiChar;
{$ELSE}
  AnsiChar = Char;
{$ENDIF}

{$I setjumph.inc}
{$I rttih.inc}
{$I objpash.inc}
{$I filerec.inc}
{$I textrec.inc}
{$i excepth.inc}

procedure fpc_initializeunits; export; compilerproc;
procedure fpc_do_exit; export; compilerproc;
