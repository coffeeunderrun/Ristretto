unit Log;

interface

uses Terminal;

type
  TLogLevel = (
    LogLevelFatal,
    LogLevelError,
    LogLevelWarn,
    LogLevelInfo,
    LogLevelDebug,
    LogLevelTrace
  );

procedure Log(Level: TLogLevel; Text: PChar);
procedure LogDebug(Text: PChar);
procedure LogError(Text: PChar);
procedure LogFatal(Text: PChar);
procedure LogInfo(Text: PChar);
procedure LogTrace(Text: PChar);
procedure LogWarn(Text: PChar);

implementation

procedure Log(Level: TLogLevel; Text: PChar);
var
  BgColor: TColor;
  FgColor: TColor;
begin
  BgColor := Terminal.GetBackground;

  case Level of
    LogLevelTrace: FgColor := ColorLightMagenta;
    LogLevelDebug: FgColor := ColorLightCyan;
    LogLevelInfo: FgColor := ColorWhite;
    LogLevelWarn: FgColor := ColorYellow;
    LogLevelError: FgColor := ColorRed;
    LogLevelFatal: begin BgColor := ColorRed; FgColor := ColorWhite; end;
  end;

  Terminal.Write(Text, FgColor, BgColor);
  Terminal.Write(#10);
end;

procedure LogDebug(Text: PChar); begin Log(LogLevelDebug, Text); end;
procedure LogError(Text: PChar); begin Log(LogLevelError, Text); end;
procedure LogFatal(Text: PChar); begin Log(LogLevelFatal, Text); end;
procedure LogInfo(Text: PChar); begin Log(LogLevelInfo, Text); end;
procedure LogTrace(Text: PChar); begin Log(LogLevelTrace, Text); end;
procedure LogWarn(Text: PChar); begin Log(LogLevelWarn, Text); end;

end.
