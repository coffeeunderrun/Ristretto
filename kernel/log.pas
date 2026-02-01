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

procedure Debug(const Text: String); inline;
procedure Error(const Text: String); inline;
procedure Fatal(const Text: String); inline;
procedure Info(const Text: String); inline;
procedure Trace(const Text: String); inline;
procedure Warn(const Text: String); inline;

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

  LogLevelPrefix: array [TLogLevel] of String = (
    '[FATAL] ',
    '[ERROR] ',
    '[WARN ] ',
    '[INFO ] ',
    '[DEBUG] ',
    '[TRACE] '
  );

procedure Log(const Level: TLogLevel; const Text: String);
var
  BgColor, FgColor: TColor;
begin
  if Level = LogLevelFatal then BgColor := ColorLightRed else BgColor := Terminal.GetBackground;
  FgColor := LogLevelColor[Level]^;
  Terminal.Write(LogLevelPrefix[Level] + Text + #10, FgColor, BgColor);
end;

procedure Debug(const Text: String);
begin
{$ifndef NDEBUG}
  Log(LogLevelDebug, Text);
{$endif}
end;

procedure Error(const Text: String); begin Log(LogLevelError, Text); end;
procedure Fatal(const Text: String); begin Log(LogLevelFatal, Text); end;
procedure Info(const Text: String); begin Log(LogLevelInfo, Text); end;
procedure Trace(const Text: String); begin Log(LogLevelTrace, Text); end;
procedure Warn(const Text: String); begin Log(LogLevelWarn, Text); end;

end.
