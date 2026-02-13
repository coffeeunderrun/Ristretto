unit system;

interface

{$define FPC_IS_SYSTEM}
{$define FPC_IS_KERNEL}

{$define DISABLE_NO_THREAD_MANAGER}
{ Do not use standard memory manager }
{$define HAS_MEMORYMANAGER}
{$define FPC_NO_DEFAULT_HEAP}

{$define FPC_ANSI_TEXTFILEREC}

{$I systemh.inc}

const
{$ifdef FPC_HAS_FEATURE_TEXTIO}
  LineEnding = #10;

  CtrlZMarksEOF: boolean = false;
  DefaultTextLineBreakStyle : TTextLineBreakStyle = tlbsCrLF;
{$endif FPC_HAS_FEATURE_TEXTIO}

{$ifdef FPC_HAS_FEATURE_FILEIO}
  DirectorySeparator = '/';
  DriveSeparator = ':';
  ExtensionSeparator = '.';
  PathSeparator = ':';
  AllowDirectorySeparators: set of AnsiChar = ['\', '/'];
  AllowDriveSeparators : set of AnsiChar = [':'];

  MaxPathLen = 1024;
  AllFilesMask = '*';

  UnusedHandle = -1;

  FileNameCaseSensitive : boolean = true;
  FileNameCasePreserving: boolean = true;

{$endif FPC_HAS_FEATURE_FILEIO}

procedure Panic; noreturn; external name '_arch_panic';
procedure Panic(Msg: String); noreturn; external name '_arch_panic_msg';

{ TODO: Remove these once SysUtils is available again. }
function IntToStr(Value: LongInt): String;
function IntToStr(Value: Int64): String;
function IntToStr(Value: QWord): String;
function UIntToStr(Value: QWord): String;
function UIntToStr(Value: Cardinal): String;

function IntToHex(Value: Int8): string;
function IntToHex(Value: UInt8): string;
function IntToHex(Value: Int16): string;
function IntToHex(Value: UInt16): string;
function IntToHex(Value: Int32): string;
function IntToHex(Value: UInt32): string;
function IntToHex(Value: Int64): string;
function IntToHex(Value: UInt64): string;

implementation

{$implicitexceptions off}

{$define FPC_SYSTEM_EXIT_NO_RETURN}
{$I system.inc}

procedure system_exit; noreturn; external name '_halt';

{ TODO: Remove these once SysUtils is available again. }
function IntToStr(Value: LongInt): String; begin Str(Value, result); end;
function IntToStr(Value: Int64): String; begin Str(Value, result); end;
function IntToStr(Value: QWord): String; begin Str(Value, result); end;
function UIntToStr(Value: QWord): String; begin Str(Value, result); end;
function UIntToStr(Value: Cardinal): String; begin Str(Value, result); end;

function IntToHex(Value: Int8): string; begin Result:=HexStr(LongInt(Value) and $ff, 2*SizeOf(Int8)); end;
function IntToHex(Value: UInt8): string; begin Result:=HexStr(Value, 2*SizeOf(UInt8)); end;
function IntToHex(Value: Int16): string; begin Result:=HexStr(LongInt(Value) and $ffff, 2*SizeOf(Int16)); end;
function IntToHex(Value: UInt16): string; begin Result:=HexStr(Value, 2*SizeOf(UInt16)); end;
function IntToHex(Value: Int32): string; begin Result:=HexStr(LongInt(Value), 2*SizeOf(Int32)); end;
function IntToHex(Value: UInt32): string; begin Result:=HexStr(LongInt(Value), 2*SizeOf(UInt32)); end;
function IntToHex(Value: Int64): string; begin Result:=HexStr(Value, 2*SizeOf(Int64)); end;
function IntToHex(Value: UInt64): string; begin Result:=HexStr(Value, 2*SizeOf(UInt64)); end;

end.
