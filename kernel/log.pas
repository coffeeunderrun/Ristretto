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

procedure Log(Level: TLogLevel; const Text: ShortString);
procedure LogDebug(const Text: ShortString);
procedure LogError(const Text: ShortString);
procedure LogFatal(const Text: ShortString);
procedure LogInfo(const Text: ShortString);
procedure LogTrace(const Text: ShortString);
procedure LogWarn(const Text: ShortString);

implementation

uses Terminal;

procedure Log(Level: TLogLevel; const Text: ShortString);
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

procedure LogDebug(const Text: ShortString);
begin
{$IFNDEF NDEBUG}
  Log(LogLevelDebug, Text);
{$ENDIF}
end;

procedure LogError(const Text: ShortString); begin Log(LogLevelError, Text); end;
procedure LogFatal(const Text: ShortString); begin Log(LogLevelFatal, Text); end;
procedure LogInfo(const Text: ShortString); begin Log(LogLevelInfo, Text); end;
procedure LogTrace(const Text: ShortString); begin Log(LogLevelTrace, Text); end;
procedure LogWarn(const Text: ShortString); begin Log(LogLevelWarn, Text); end;

end.
