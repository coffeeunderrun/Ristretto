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

{$P+}

type
  DWord    = LongWord;
  Cardinal = LongWord;
  Integer  = SmallInt;

  Int8   = ShortInt;
  Int16  = SmallInt;
  Int32  = Longint;
  IntPtr = Int64;

  UInt8   = Byte;
  UInt16  = Word;
  UInt32  = DWord;
  UInt64  = QWord;
  UIntPtr = QWord;

  SizeInt  = Int64;
  SizeUInt = QWord;
  PtrInt   = Int64;
  PtrUInt  = QWord;
  ValSInt  = Int64;
  ValUInt  = QWord;

  PBoolean  = ^Boolean;
  PSmallInt = ^SmallInt;
  PShortInt = ^ShortInt;
  PInteger  = ^Integer;
  PLongWord = ^LongWord;
  PLongInt  = ^LongInt;
  PCardinal = ^Cardinal;

  PByte  = ^Byte;
  PChar  = ^Char;
  PWord  = ^Word;
  PDWord = ^DWord;
  PQWord = ^QWord;

  PInt8   = ^Int8;
  PInt16  = ^Int16;
  PInt32  = ^Int32;
  PInt64  = ^Int64;
  PIntPtr = ^IntPtr;

  PUInt8   = ^UInt8;
  PUInt16  = ^UInt16;
  PUInt32  = ^UInt32;
  PUInt64  = ^UInt64;
  PUIntPtr = ^UIntPtr;

  PPtrInt   = ^PtrInt;
  PPtrUInt  = ^PtrUInt;
  PSizeInt  = ^SizeInt;
  PSizeUInt = ^SizeUInt;

  HResult = type LongInt;

  AnsiChar     = Char;
  PAnsiChar    = ^AnsiChar;
  PShortString = ^ShortString;

  TProcedure = Procedure;

{ Numbers for routines that have compiler magic }
{$I innr.inc}

{*****************************************************************************
                          TextRec/FileRec
*****************************************************************************}

{$I filerec.inc}
{$I textrec.inc}

{****************************************************************************
                        Processor specific routines
****************************************************************************}

Procedure Move(const source;var dest;count:SizeInt);
Procedure FillChar(var x;count:SizeInt;Value:Byte);
Procedure FillChar(var x;count:SizeInt;Value:Boolean);
Procedure FillChar(var x;count:SizeInt;Value:AnsiChar);
procedure FillByte(var x;count:SizeInt;value:byte);

{****************************************************************************
                          Math Routines
****************************************************************************}

Function Align(Addr : PtrUInt; Alignment : PtrUInt) : PtrUInt; inline;
Function Align(Addr : Pointer; Alignment : PtrUInt) : Pointer; inline;

{****************************************************************************
                      Characters and String Handling
****************************************************************************}

{$if defined(VER3_2)}
Function Chr(Value: Byte): AnsiChar; [INTERNPROC: fpc_in_chr_byte];
{$endif defined(VER3_2)}

{*****************************************************************************
                          Init / Exit / ExitProc
*****************************************************************************}

procedure Halt; inline; noreturn;

{*****************************************************************************
                          SetJmp/LongJmp
*****************************************************************************}

{$I setjumph.inc}

{*****************************************************************************
                           RTTI support
*****************************************************************************}

{$I rttih.inc}

{*****************************************************************************
                       Object Pascal support
*****************************************************************************}

{$I objpash.inc}

{*****************************************************************************
                   Internal helper routines support
*****************************************************************************}

{$I compproc.inc}

{*****************************************************************************
                          Exception support
*****************************************************************************}

{$I excepth.inc}
