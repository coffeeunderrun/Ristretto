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

  PByte  = ^Byte;
  PChar  = ^Char;
  PWord  = ^Word;
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

  TColor = record
    Red: UInt8;
    Green: UInt8;
    Blue: UInt8;
  end;

const
  ColorAmber: TColor        = (Red: $FF; Green: $B0; Blue: $00);
  ColorBlack: TColor        = (Red: $00; Green: $00; Blue: $00);
  ColorBlue: TColor         = (Red: $00; Green: $00; Blue: $AA);
  ColorBrown: TColor        = (Red: $AA; Green: $55; Blue: $00);
  ColorCyan: TColor         = (Red: $00; Green: $AA; Blue: $AA);
  ColorGray: TColor         = (Red: $55; Green: $55; Blue: $55);
  ColorGreen: TColor        = (Red: $00; Green: $AA; Blue: $00);
  ColorLightAmber: TColor   = (Red: $FF; Green: $CC; Blue: $00);
  ColorLightBlue: TColor    = (Red: $55; Green: $55; Blue: $FF);
  ColorLightCyan: TColor    = (Red: $55; Green: $FF; Blue: $FF);
  ColorLightGray: TColor    = (Red: $AA; Green: $AA; Blue: $AA);
  ColorLightGreen: TColor   = (Red: $55; Green: $FF; Blue: $55);
  ColorLightMagenta: TColor = (Red: $FF; Green: $55; Blue: $FF);
  ColorLightRed: TColor     = (Red: $FF; Green: $55; Blue: $55);
  ColorMagenta: TColor      = (Red: $AA; Green: $00; Blue: $AA);
  ColorRed: TColor          = (Red: $AA; Green: $00; Blue: $00);
  ColorWhite: TColor        = (Red: $FF; Green: $FF; Blue: $FF);
  ColorYellow: TColor       = (Red: $FF; Green: $FF; Blue: $55);

{$I setjumph.inc}
{$I rttih.inc}
{$I objpash.inc}
{$I filerec.inc}
{$I textrec.inc}
{$I excepth.inc}

procedure fpc_initializeunits; export; compilerproc;
procedure fpc_do_exit; export; compilerproc;

{****************************************************************************
                        Processor specific routines
****************************************************************************}

procedure Move(const Source; var Dest; Count: SizeUInt);
