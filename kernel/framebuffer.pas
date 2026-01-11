unit Framebuffer;

interface

uses Limine;

procedure Initialize;
procedure Clear(Color: TColor);
procedure PutPixel(X, Y: UInt64; Color: TColor);
procedure MoveDown(Delta: UInt64; FillColor: TColor);
procedure MoveUp(Delta: UInt64; FillColor: TColor);

function GetHeight: UInt64;
function GetWidth: UInt64;

implementation

var
  FramebufferAddress: Pointer;
  FramebufferSize: SizeUInt;
  ResolutionHeight: UInt64;
  ResolutionWidth: UInt64;
  BytesPerRow: UInt64;
  BytesPerPixel: UInt16;
  RedIndex: UInt8;
  GreenIndex: UInt8;
  BlueIndex: UInt8;

procedure Initialize;
var
  FramebufferPtr: PLimineFramebuffer;
begin
  if Limine.GetFramebufferCount = 0 then exit;
  FramebufferPtr := Limine.GetFramebuffer(0);

  if FramebufferPtr <> nil then with FramebufferPtr^ do begin
    FramebufferAddress := Address;
    FramebufferSize := Height * Pitch;
    ResolutionHeight := Height;
    ResolutionWidth := Width;
    BytesPerRow := Pitch;
    BytesPerPixel := BitsPerPixel shr 3;
    RedIndex := RedMaskShift shr 3;
    GreenIndex := GreenMaskShift shr 3;
    BlueIndex := BlueMaskShift shr 3;
  end;
end;

procedure Clear(Color: TColor);
var
  FramebufferPtr: PUInt8;
  FramebufferEndPtr: PUInt8;
begin
  FramebufferPtr := PUInt8(FramebufferAddress);
  FramebufferEndPtr := PUInt8(FramebufferAddress) + FramebufferSize;

  while FramebufferPtr < FramebufferEndPtr do begin
    FramebufferPtr[RedIndex] := Color.Red;
    FramebufferPtr[GreenIndex] := Color.Green;
    FramebufferPtr[BlueIndex] := Color.Blue;
    FramebufferPtr += BytesPerPixel;
  end;
end;

procedure PutPixel(X, Y: UInt64; Color: TColor);
var
  FramebufferPtr: PUInt8;
begin
  FramebufferPtr := PUInt8(FramebufferAddress) + (X * BytesPerPixel) + (Y * BytesPerRow);
  FramebufferPtr[RedIndex] := Color.Red;
  FramebufferPtr[GreenIndex] := Color.Green;
  FramebufferPtr[BlueIndex] := Color.Blue;
end;

procedure MoveDown(Delta: UInt64; FillColor: TColor);
var
  Count: SizeUInt;
  FramebufferPtr: PUInt8;
  FramebufferEndPtr: PUInt8;
begin
  Count := FramebufferSize - (Delta * BytesPerRow);
  FramebufferPtr := PUInt8(FramebufferAddress);
  FramebufferEndPtr := FramebufferPtr + ((Delta - 1) * BytesPerRow);

  Move(FramebufferPtr^, FramebufferEndPtr^, Count);

  // Fill gap after moving framebuffer content.
  while FramebufferPtr < FramebufferEndPtr do begin
    FramebufferPtr[RedIndex] := FillColor.Red;
    FramebufferPtr[GreenIndex] := FillColor.Green;
    FramebufferPtr[BlueIndex] := FillColor.Blue;
    FramebufferPtr += BytesPerPixel;
  end;
end;

procedure MoveUp(Delta: UInt64; FillColor: TColor);
var
  Count: SizeUInt;
  FramebufferPtr: PUInt8;
  FramebufferEndPtr: PUInt8;
begin
  Count := FramebufferSize - (Delta * BytesPerRow);
  FramebufferPtr := PUInt8(FramebufferAddress);
  FramebufferEndPtr := FramebufferPtr + (Delta * BytesPerRow);

  Move(FramebufferEndPtr^, FramebufferPtr^, Count);

  // Fill gap after moving framebuffer content.
  FramebufferPtr += Count;
  FramebufferEndPtr += Count;
  while FramebufferPtr < FramebufferEndPtr do begin
    FramebufferPtr[RedIndex] := FillColor.Red;
    FramebufferPtr[GreenIndex] := FillColor.Green;
    FramebufferPtr[BlueIndex] := FillColor.Blue;
    FramebufferPtr += BytesPerPixel;
  end;
end;

function GetHeight: UInt64; begin GetHeight := ResolutionHeight; end;
function GetWidth: UInt64; begin GetWidth := ResolutionWidth; end;

end.
