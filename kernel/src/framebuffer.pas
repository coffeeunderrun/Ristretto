unit Framebuffer;

interface

uses Color;

procedure Clear(Color: TColor);
procedure PutPixel(X, Y: UInt64; Color: TColor);
procedure MoveDown(Delta: UInt64; FillColor: TColor);
procedure MoveUp(Delta: UInt64; FillColor: TColor);

function GetHeight: UInt64; inline;
function GetWidth: UInt64; inline;

function GetVirtualBase: PtrUInt; inline;
function GetSize: SizeUInt; inline;

implementation

uses Limine;

var
  FramebufferRequest: TLimineFramebufferRequest; external name '_limine_request_framebuffer';
  FramebufferAddress: Pointer;
  FramebufferSize: SizeUInt;
  ResolutionHeight: UInt64;
  ResolutionWidth: UInt64;
  BytesPerRow: UInt64;
  BytesPerPixel: UInt16;
  RedIndex: UInt8;
  GreenIndex: UInt8;
  BlueIndex: UInt8;

procedure Clear(Color: TColor);
var
  FramebufferPtr: PUInt8;
  FramebufferEndPtr: PUInt8;
begin
  if not Assigned(FramebufferAddress) then exit;

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
  if not Assigned(FramebufferAddress) then exit;

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
  if not Assigned(FramebufferAddress) then exit;

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
  if not Assigned(FramebufferAddress) then exit;

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

function GetHeight: UInt64; begin result := ResolutionHeight; end;
function GetWidth: UInt64; begin result := ResolutionWidth; end;

function GetVirtualBase: PtrUInt; begin result := PtrUInt(FramebufferAddress); end;
function GetSize: SizeUInt; inline; begin result := FramebufferSize; end;

begin
  FramebufferAddress := nil;

  if not Assigned(FramebufferRequest.Response) then exit;

  with FramebufferRequest.Response^ do begin
    if (FramebufferCount = 0) or not Assigned(Framebuffers) then exit;

    with Framebuffers^[0] do begin
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
end.
