{ Original source from https://wiki.freepascal.org/System_unit#Mandatory_tasks_of_System_unit }
unit system;
{$MODE FPC}
interface

type
  hresult = LongInt;
  Cardinal = LongWord;
  Integer = SmallInt;
  DWord = LongWord;

  PByte = ^Byte;
  PChar = ^Char;
  PWord = ^Word;
  PDWord = ^DWord;
  PQWord = ^QWord;

  Int8 = ShortInt;
  Int16 = SmallInt;
  Int32 = LongInt;

  PInt8 =  ^Int8;
  PInt16 = ^Int16;
  PInt32 = ^Int32;
  PInt64 = ^Int64;

  UInt8 = Byte;
  UInt16 = Word;
  UInt32 = DWord;
  UInt64 = QWord;

  PUInt8 =  ^UInt8;
  PUInt16 = ^UInt16;
  PUInt32 = ^UInt32;
  PUInt64 = ^UInt64;

  TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkSet,
    tkMethod, tkSString, tkLString, tkAString, tkWString, tkVariant, tkArray,
    tkRecord, tkInterface, tkClass, tkObject, tkWChar, tkBool, tkInt64, tkQWord,
    tkDynArray, tkInterfaceRaw, tkProcVar, tkUString, tkUChar, tkHelper, tkFile,
    tkClassRef, tkPointer);

  jmp_buf = packed record
    rbx, rbp, r12, r13, r14, r15, rsp, rip: QWord;
    {$IFDEF win64}
    rsi, rdi: QWord;
    xmm6, xmm7, xmm8, xmm9, xmm10, xmm11, xmm12, xmm13, xmm14, xmm15: record
      m1, m2: QWord;
    end;

    mxcsr: LongWord;
    fpucw: word;
    padding: word;
    {$ENDIF win64}
  end;

  Pjmp_buf = ^jmp_buf;
  PExceptAddr = ^TExceptAddr;
  TExceptAddr = record
    buf: Pjmp_buf;
    next: PExceptAddr;
    {$IFDEF CPU16}
    frametype: SmallInt;
    {$ELSE CPU16}
    frametype: LongInt;
    {$ENDIF CPU16}
  end;

  PGuid = ^TGuid;
  TGuid = packed record
    case Integer of
    1:
     (Data1: DWord;
      Data2: word;
      Data3: word;
      Data4: array [0 .. 7] of byte;
    );
    2:
     (D1: DWord;
      D2: word;
      D3: word;
      D4: array [0 .. 7] of byte;
    );
    3:
    ( { uuid fields according to RFC4122 }
      time_low: DWord; // The low field of the timestamp
      time_mid: word; // The middle field of the timestamp
      time_hi_and_version: word;
      // The high field of the timestamp multiplexed with the version number
      clock_seq_hi_and_reserved: byte;
      // The high field of the clock sequence multiplexed with the variant
      clock_seq_low: byte; // The low field of the clock sequence
      node: array [0 .. 5] of byte; // The spatially unique node identifier
    );
  end;

  // Temporary fix
  FileRec = record end;
  TextRec = record end;

var
  ExitCode: hresult = 0; export name 'operatingsystem_result';

procedure fpc_initializeunits; compilerproc;

procedure fpc_do_exit; compilerproc;

implementation

procedure fpc_initializeunits;
begin
end;

procedure fpc_do_exit;
begin
end;

end.
