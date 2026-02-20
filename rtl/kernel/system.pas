unit System;

interface

{$define FPC_IS_SYSTEM}

{$define DISABLE_NO_THREAD_MANAGER}
{ Do not use standard memory manager }
{$define HAS_MEMORYMANAGER}
{$define FPC_NO_DEFAULT_HEAP}

{$define FPC_ANSI_TEXTFILEREC}

{$I systemh.inc}

var
  LogFatal, LogError, LogWarn, LogInfo, LogDebug, LogTrace: Text;

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

function HashString(const Str: String): UInt64; inline;

implementation

{$implicitexceptions off}

{$undef SUPPORT_DOUBLE}
{$undef SUPPORT_EXTENDED}

{$define FPC_SYSTEM_EXIT_NO_RETURN}
{$I system.inc}

procedure system_exit; noreturn; external name '_halt';

function HashString(const Str: String): UInt64;
const
  FNV_OFFSET_BASIS = 2166136261;
  FNV_PRIME = 16777619;
var
  Ch: Char;
begin
  result := FNV_OFFSET_BASIS;
  for Ch in Str do result := (result xor Ord(Ch)) * FNV_PRIME;
end;

end.
