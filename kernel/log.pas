unit Log;

interface

uses Color;

type
  TLogLevel = (
    LogLevelFatal,
    LogLevelError,
    LogLevelWarn,
    LogLevelInfo,
    LogLevelDebug,
    LogLevelTrace
  );

procedure Debug(const Text: ShortString);
procedure Error(const Text: ShortString);
procedure Fatal(const Text: ShortString);
procedure Info(const Text: ShortString);
procedure Trace(const Text: ShortString);
procedure Warn(const Text: ShortString);

implementation

uses Terminal;

const
  LogLevelColor: array [TLogLevel] of PColor = (
    @ColorWhite,
    @ColorLightRed,
    @ColorYellow,
    @ColorWhite,
    @ColorLightCyan,
    @ColorLightMagenta
  );

  LogLevelPrefix: array [TLogLevel] of ShortString = (
    'FATAL: ',
    'ERROR: ',
    'WARN: ',
    'INFO: ',
    'DEBUG: ',
    'TRACE: '
  );

procedure Log(const Level: TLogLevel; const Text: ShortString);
var
  BgColor: TColor;
  FgColor: TColor;
begin
  if Level = LogLevelFatal then BgColor := ColorLightRed else BgColor := Terminal.GetBackground;
  FgColor := LogLevelColor[Level]^;
  Terminal.Write(LogLevelPrefix[Level], FgColor, BgColor);
  Terminal.Write(Text, FgColor, BgColor);
  Terminal.Write(#10);
end;

procedure Debug(const Text: ShortString);
begin
{$IFNDEF NDEBUG}
  Log(LogLevelDebug, Text);
{$ENDIF}
end;

procedure Error(const Text: ShortString); begin Log(LogLevelError, Text); end;
procedure Fatal(const Text: ShortString); begin Log(LogLevelFatal, Text); end;
procedure Info(const Text: ShortString); begin Log(LogLevelInfo, Text); end;
procedure Trace(const Text: ShortString); begin Log(LogLevelTrace, Text); end;
procedure Warn(const Text: ShortString); begin Log(LogLevelWarn, Text); end;

end.
