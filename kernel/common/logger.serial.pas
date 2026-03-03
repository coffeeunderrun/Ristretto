unit Logger.Serial;

interface

implementation

uses Logger, IoPort;

const
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
    procedure Write(const Level: TLogLevel); virtual;
    procedure Write(Ch: Char); virtual;
  end;

procedure TSerialLogger.Write(const Level: TLogLevel);
var
  Ch: Char;
begin
  for Ch in LogLevelPrefix[Level] do TSerialLogger.Write(Ch);
end;

procedure TSerialLogger.Write(Ch: Char);
begin
  while (IoPort.ReadIoPort8($3FD) and $20) = 0 do;
  IoPort.WriteIoPort8($3F8, Ord(Ch));
end;

var
  SerialLogger: TSerialLogger;

begin
  SerialLogger.Create(LogLevelTrace);
  Logger.Register(SerialLogger);
end.
