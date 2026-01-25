{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2005 by the Free Pascal development team

    This unit makes Free Pascal as much as possible Delphi compatible,
    defining several internal structures for classes, interfaces, and
    resource strings.

    Additionally this file defines the interface of TObject, providing
    their basic implementation in the corresponding objpas.inc file.

    WARNING: IF YOU CHANGE SOME OF THESE INTERNAL RECORDS, MAKE SURE
    TO MODIFY THE COMPILER AND OBJPAS.INC ACCORDINGLY, OTHERWISE
    THIS WILL LEAD TO CRASHES IN THE RESULTING COMPILER AND/OR RTL.

    IN PARTICULAR, THE IMPLEMENTATION PART OF THIS INCLUDE FILE,
    OBJPAS.INC, USES SOME HARDCODED RECORD MEMBER OFFSETS.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

type
  PGuid = ^TGuid;
  TGuid = packed record case Integer of
    1: (
      Data1: DWord;
      Data2: Word;
      Data3: Word;
      Data4: array [0..7] of Byte;
    );
    2: (
      D1: DWord;
      D2: Word;
      D3: Word;
      D4: array [0..7] of Byte;
    );
    3: (
      { uuid fields according to RFC4122 }
      time_low: DWord;
      time_mid: Word;
      time_hi_and_version: Word;
      clock_seq_hi_and_reserved: Byte;
      clock_seq_low: Byte;
      node: array [0..5] of Byte;
    );
  end;

{*****************************************************************************
                              Array of const support
*****************************************************************************}

{ NOTE: stripped down version of FPC's implementation }
const
  vtInteger   = 0;
  vtBoolean   = 1;
  vtChar      = 2;
  vtString    = 4;
  vtPointer   = 5;
  vtPChar     = 6;
  vtInterface = 14;
  vtInt64     = 16;
  vtQWord     = 17;

type
  PVarRec = ^TVarRec;
  TVarRec = record case VType : SizeInt of
    vtInteger:   (VInteger: LongInt);
    vtBoolean:   (VBoolean: Boolean);
    vtChar:      (VChar: Char);
    vtString:    (VString: PShortString);
    vtPointer:   (VPointer: Pointer);
    vtPChar:     (VPChar: PChar);
    vtInterface: (VInterface: Pointer);
    vtInt64:     (VInt64: PInt64);
    vtQWord:     (VQWord: PQWord);
  end;
