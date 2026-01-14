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

  LogLevelPrefix: array [TLogLevel] of PChar = (
    'FATAL: ',
    'ERROR: ',
    'WARN: ',
    'INFO: ',
    'DEBUG: ',
    'TRACE: '
  );

procedure Log(Level: TLogLevel; Text: PChar);
procedure LogDebug(Text: PChar);
procedure LogError(Text: PChar);
procedure LogFatal(Text: PChar);
procedure LogInfo(Text: PChar);
procedure LogTrace(Text: PChar);
procedure LogWarn(Text: PChar);

implementation

uses Terminal;

procedure Log(Level: TLogLevel; Text: PChar);
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

procedure LogDebug(Text: PChar);
begin
{$IFNDEF NDEBUG}
  Log(LogLevelDebug, Text);
{$ENDIF}
end;

procedure LogError(Text: PChar); begin Log(LogLevelError, Text); end;
procedure LogFatal(Text: PChar); begin Log(LogLevelFatal, Text); end;
procedure LogInfo(Text: PChar); begin Log(LogLevelInfo, Text); end;
procedure LogTrace(Text: PChar); begin Log(LogLevelTrace, Text); end;
procedure LogWarn(Text: PChar); begin Log(LogLevelWarn, Text); end;

end.
