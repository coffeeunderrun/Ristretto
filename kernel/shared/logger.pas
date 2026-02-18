unit Logger;

interface

type
  TLogger = object
    constructor Initialize;
    procedure Write(const Level: TLogLevel); virtual; abstract;
    procedure Write(Ch: Char); virtual; abstract;
  end;

procedure Register(const Logger: TLogger);

implementation

var
  LoggerArr: array of TLogger;

constructor TLogger.Initialize; begin end;

procedure Register(const Logger: TLogger);
begin
  SetLength(LoggerArr, Length(LoggerArr) + 1);
  LoggerArr[High(LoggerArr)] := Logger;
end;

function Open(var Text: TextRec): Integer;
begin
  result := 0;
end;

function Close(var Text: TextRec): Integer;
begin
  result := 0;
end;

function Write(var Text: TextRec): Integer;
var
  Logger: TLogger;
  I: Integer;
begin
  if Text.BufPos = 0 then exit;
  for Logger in LoggerArr do begin
    Logger.Write(TLogLevel(Text.UserData[1]));
    for I := 0 to Text.BufPos - 1 do Logger.Write(PChar(Text.BufPtr)[I]);
  end;
  Text.BufPos := 0;
  result := 0;
end;

procedure AssignLogText(var Text: TextFile; LogLevel: TLogLevel);
begin
  Assign(Text, '');
  with TextRec(Text) do begin
    OpenFunc := @Open;
    InOutFunc := @Write;
    FlushFunc := @Write;
    CloseFunc := @Close;
    UserData[1] := Byte(LogLevel);
  end;
  Rewrite(Text);
end;

begin
  AssignLogText(LogFatal, LogLevelFatal);
  AssignLogText(LogError, LogLevelError);
  AssignLogText(LogWarn, LogLevelWarn);
  AssignLogText(LogInfo, LogLevelInfo);
  AssignLogText(LogDebug, LogLevelDebug);
  AssignLogText(LogTrace, LogLevelTrace);
end.
