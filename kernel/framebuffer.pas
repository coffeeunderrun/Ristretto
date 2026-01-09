unit Framebuffer;

interface

uses Limine;

type
  TColor = record
    Red: UInt8;
    Green: UInt8;
    Blue: UInt8;
  end;

const
  ColorBlack: TColor = (Red: $00; Green: $00; Blue: $00);
  ColorBlue: TColor = (Red: $00; Green: $00; Blue: $AA);
  ColorBrown: TColor = (Red: $AA; Green: $55; Blue: $00);
  ColorCyan: TColor = (Red: $00; Green: $AA; Blue: $AA);
  ColorGray: TColor = (Red: $55; Green: $55; Blue: $55);
  ColorGreen: TColor = (Red: $00; Green: $AA; Blue: $00);
  ColorLightBlue: TColor = (Red: $55; Green: $55; Blue: $FF);
  ColorLightCyan: TColor = (Red: $55; Green: $FF; Blue: $FF);
  ColorLightGray: TColor = (Red: $AA; Green: $AA; Blue: $AA);
  ColorLightGreen: TColor = (Red: $55; Green: $FF; Blue: $55);
  ColorLightMagenta: TColor = (Red: $FF; Green: $55; Blue: $FF);
  ColorLightRed: TColor = (Red: $FF; Green: $55; Blue: $55);
  ColorMagenta: TColor = (Red: $AA; Green: $00; Blue: $AA);
  ColorRed: TColor = (Red: $AA; Green: $00; Blue: $00);
  ColorWhite: TColor = (Red: $FF; Green: $FF; Blue: $FF);
  ColorYellow: TColor = (Red: $FF; Green: $FF; Blue: $55);

procedure Initialize();
procedure Clear(Color: TColor);
procedure PutPixel(X, Y: UInt64; Color: TColor);

function GetHeight(): UInt64;
function GetWidth(): UInt64;

implementation

var
  AddressBeginPtr: PUInt8;
  AddressEndPtr: PUInt8;
  ResolutionHeight: UInt64;
  ResolutionWidth: UInt64;
  BytesPerRow: UInt64;
  BytesPerPixel: UInt16;
  RedIndex: UInt8;
  GreenIndex: UInt8;
  BlueIndex: UInt8;

procedure Initialize();
var
  FramebufferPtr: PLimineFramebuffer;
begin
  if Limine.GetFramebufferCount = 0 then exit;

  FramebufferPtr := Limine.GetFramebuffer(0);
  if FramebufferPtr = nil then exit;

  with FramebufferPtr^ do begin
    AddressBeginPtr := PUInt8(Address);
    AddressEndPtr := AddressBeginPtr + (Pitch * Height);
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
  AddressPtr: PUInt8;
begin
  AddressPtr := AddressBeginPtr;
  while AddressPtr < AddressEndPtr do begin
    AddressPtr[RedIndex] := Color.Red;
    AddressPtr[GreenIndex] := Color.Green;
    AddressPtr[BlueIndex] := Color.Blue;
    AddressPtr := AddressPtr + BytesPerPixel;
  end;
end;

procedure PutPixel(X, Y: UInt64; Color: TColor);
var
  Offset: UInt64;
begin
  Offset := (X * BytesPerPixel) + (Y * BytesPerRow);
  AddressBeginPtr[Offset + RedIndex] := Color.Red;
  AddressBeginPtr[Offset + GreenIndex] := Color.Green;
  AddressBeginPtr[Offset + BlueIndex] := Color.Blue;
end;

function GetHeight(): UInt64; begin GetHeight := ResolutionHeight; end;
function GetWidth(): UInt64; begin GetWidth := ResolutionWidth; end;

end.
