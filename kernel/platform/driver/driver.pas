unit Driver;

{$modeswitch advancedrecords}

interface

uses Driver.Common;

type
  PDriver = ^TDriver;
  TDriver = record
  private
    FDescriptor: TDriverDescriptor;
    FOperations: TDriverOperations;
    FLockPtr: Pointer;
    FReferenceCount: SizeUInt;

  public
    property Descriptor: TDriverDescriptor read FDescriptor;
    property Operations: TDriverOperations read FOperations;

    constructor Create(constref ADriverInformation: TDriverInformation);
    procedure Finalize;

    procedure AddReference;
    procedure RemoveReference;

    procedure Lock;
    procedure Unlock;
  end;

implementation

uses SysUtils;

constructor TDriver.Create(constref ADriverInformation: TDriverInformation);
begin
  WriteLn(LogTrace, 'TDriver.Create called.');
  FDescriptor := ADriverInformation.Descriptor^;
  FOperations := ADriverInformation.Operations^;
end;

procedure TDriver.Finalize;
begin
  WriteLn(LogTrace, 'TDriver.Finalize called.');
  if Assigned(FLockPtr) then FreeMem(FLockPtr);
end;

procedure TDriver.AddReference;
begin
  InterlockedIncrement64(FReferenceCount);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Driver reference count increased: %d.', [FReferenceCount]));
  {$endif}
end;

procedure TDriver.RemoveReference;
begin
  InterlockedDecrement64(FReferenceCount);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Driver reference count decreased: %d.', [FReferenceCount]));
  {$endif}
end;

procedure TDriver.Lock;
begin
  WriteLn(LogTrace, 'TDriver.Lock called.');
end;

procedure TDriver.Unlock;
begin
  WriteLn(LogTrace, 'TDriver.Unlock called.');
end;

end.
