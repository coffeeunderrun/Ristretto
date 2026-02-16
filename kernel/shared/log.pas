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

  TLogger = object
  private
    constructor Initialize;
  public
    procedure Log(const Level: TLogLevel; const Text: String); virtual; abstract;
  end;

procedure Debug(const Text: String); inline;
procedure Error(const Text: String); inline;
procedure Fatal(const Text: String); inline;
procedure Info(const Text: String); inline;
procedure Trace(const Text: String); inline;
procedure Warn(const Text: String); inline;

procedure DebugLn(const Text: String); inline;
procedure ErrorLn(const Text: String); inline;
procedure FatalLn(const Text: String); inline;
procedure InfoLn(const Text: String); inline;
procedure TraceLn(const Text: String); inline;
procedure WarnLn(const Text: String); inline;

implementation

uses Serial, Terminal;

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

type
  TSerialLogger = object(TLogger)
    procedure Log(const Level: TLogLevel; const Text: String); virtual;
  end;

var
  SerialLogger: TSerialLogger;

procedure Log(const Level: TLogLevel; const Text: String);
var
  BgColor, FgColor: TColor;
begin
  if Level = LogLevelFatal then BgColor := ColorLightRed else BgColor := Terminal.GetBackground;
  FgColor := LogLevelColor[Level]^;
  // Terminal.Write(LogLevelPrefix[Level] + Text, FgColor, BgColor);
  SerialLogger.Log(Level, Text);
end;

procedure Debug(const Text: String); begin Log(LogLevelDebug, Text); end;
procedure Error(const Text: String); begin Log(LogLevelError, Text); end;
procedure Fatal(const Text: String); begin Log(LogLevelFatal, Text); end;
procedure Info(const Text: String); begin Log(LogLevelInfo, Text); end;
procedure Trace(const Text: String); begin Log(LogLevelTrace, Text); end;
procedure Warn(const Text: String); begin Log(LogLevelWarn, Text); end;

procedure DebugLn(const Text: String); begin Log(LogLevelDebug, Text + #10); end;
procedure ErrorLn(const Text: String); begin Log(LogLevelError, Text + #10); end;
procedure FatalLn(const Text: String); begin Log(LogLevelFatal, Text + #10); end;
procedure InfoLn(const Text: String); begin Log(LogLevelInfo, Text + #10); end;
procedure TraceLn(const Text: String); begin Log(LogLevelTrace, Text + #10); end;
procedure WarnLn(const Text: String); begin Log(LogLevelWarn, Text + #10); end;

constructor TLogger.Initialize; begin end;

procedure TSerialLogger.Log(const Level: TLogLevel; const Text: String);
begin
  { TODO: Don't use the serial unit directly. }
  Serial.Write(LogLevelPrefix[Level] + Text);
end;

begin
  SerialLogger.Initialize;
end.
