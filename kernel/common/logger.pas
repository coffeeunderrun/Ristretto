unit Logger;

interface

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
    FMinLogLevel: TLogLevel;
  public
    constructor Create(AMinLogLevel: TLogLevel = LogLevelInfo);
    procedure Write(const Level: TLogLevel); virtual; abstract;
    procedure Write(Ch: Char); virtual; abstract;
  end;

procedure Register(const Logger: TLogger);

implementation

var
  LoggerArr: array of TLogger;

constructor TLogger.Create(AMinLogLevel: TLogLevel);
begin
  FMinLogLevel := AMinLogLevel;
end;

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
  LogLevel: TLogLevel;
  I: Integer;
begin
  with Text do begin
    if BufPos = 0 then exit;
    LogLevel := TLogLevel(UserData[1]);
    for Logger in LoggerArr do begin
      if Logger.FMinLogLevel < LogLevel then continue;
      Logger.Write(LogLevel);
      for I := 0 to BufPos - 1 do Logger.Write(PChar(BufPtr)[I]);
    end;
    BufPos := 0;
  end;
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
