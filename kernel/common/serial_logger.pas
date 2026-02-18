unit Serial_Logger;

interface

implementation

uses Logger, Serial;

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
begin
  Serial.Write(LogLevelPrefix[Level]);
end;

procedure TSerialLogger.Write(Ch: Char);
begin
  Serial.Write(Ch);
end;

var
  SerialLogger: TSerialLogger;

begin
  SerialLogger.Initialize;
  Logger.Register(SerialLogger);
end.
