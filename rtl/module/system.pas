unit System;

interface

type
  DWord    = LongWord;
  Cardinal = LongWord;
  Integer  = SmallInt;
  UInt64   = QWord;
  HResult  = LongInt;

  TExceptAddr = record end;

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
      time_low: DWord;
      time_mid: Word;
      time_hi_and_version: Word;
      clock_seq_hi_and_reserved: Byte;
      clock_seq_low: Byte;
      node: array [0..5] of Byte;
    );
  end;

  jmp_buf = packed record
    rbx,rbp,r12,r13,r14,r15,rsp,rip : qword;
    {$ifdef FPC_ABI_WIN64}
    rsi,rdi : qword;
    xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13,xmm14,xmm15: record m1,m2: qword; end;
    mxcsr: DWord;
    fpucw: Word;
    padding: Word;
    {$endif FPC_ABI_WIN64}
  end;

  FileRec = record end;
  TextRec = record end;

  TTypeKind = (tkUnknown,tkInteger,tkChar,tkEnumeration,tkFloat,
              tkSet,tkMethod,tkSString,tkLString,tkAString,
              tkWString,tkVariant,tkArray,tkRecord,tkInterface,
              tkClass,tkObject,tkWChar,tkBool,tkInt64,tkQWord,
              tkDynArray,tkInterfaceRaw,tkProcVar,tkUString,tkUChar,
              tkHelper,tkFile,tkClassRef,tkPointer);

implementation

end.
