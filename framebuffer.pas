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

implementation

var
  LimineRequestFramebuffer: TLimineFramebufferRequest; external;
  FramebufferPtr: PLimineFramebuffer;
  AddressBeginPtr : PUInt8;
  AddressEndPtr: PUInt8;
  BytesPerPixel: UInt16;
  RedIndex: UInt8;
  GreenIndex: UInt8;
  BlueIndex: UInt8;

procedure Initialize();
begin
  FramebufferPtr := PLimineFramebuffer(LimineRequestFramebuffer.Response^.Framebuffers[0]);
  AddressBeginPtr := PUInt8(FramebufferPtr^.Address);
  AddressEndPtr := AddressBeginPtr + (FramebufferPtr^.Pitch * FramebufferPtr^.Height);
  BytesPerPixel := FramebufferPtr^.BitsPerPixel shr 3;
  RedIndex := FramebufferPtr^.RedMaskShift shr 3;
  GreenIndex := FramebufferPtr^.GreenMaskShift shr 3;
  BlueIndex := FramebufferPtr^.BlueMaskShift shr 3;
end;

procedure Clear(Color: TColor);
var
  AddressPtr: PUInt8;
begin
  AddressPtr := AddressBeginPtr;
  while AddressPtr < AddressEndPtr do
  begin
    AddressPtr[RedIndex] := Color.Red;
    AddressPtr[GreenIndex] := Color.Green;
    AddressPtr[BlueIndex] := Color.Blue;
    AddressPtr := AddressPtr + BytesPerPixel;
  end;
end;

end.
