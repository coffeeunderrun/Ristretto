unit Color;

interface

type
  PColor = ^TColor;
  TColor = record
    Red: UInt8;
    Green: UInt8;
    Blue: UInt8;
  end;

const
  ColorAmber: TColor        = (Red: $FF; Green: $B0; Blue: $00);
  ColorBlack: TColor        = (Red: $00; Green: $00; Blue: $00);
  ColorBlue: TColor         = (Red: $00; Green: $00; Blue: $AA);
  ColorBrown: TColor        = (Red: $AA; Green: $55; Blue: $00);
  ColorCyan: TColor         = (Red: $00; Green: $AA; Blue: $AA);
  ColorGray: TColor         = (Red: $55; Green: $55; Blue: $55);
  ColorGreen: TColor        = (Red: $00; Green: $AA; Blue: $00);
  ColorLightAmber: TColor   = (Red: $FF; Green: $CC; Blue: $00);
  ColorLightBlue: TColor    = (Red: $55; Green: $55; Blue: $FF);
  ColorLightCyan: TColor    = (Red: $55; Green: $FF; Blue: $FF);
  ColorLightGray: TColor    = (Red: $AA; Green: $AA; Blue: $AA);
  ColorLightGreen: TColor   = (Red: $55; Green: $FF; Blue: $55);
  ColorLightMagenta: TColor = (Red: $FF; Green: $55; Blue: $FF);
  ColorLightRed: TColor     = (Red: $FF; Green: $55; Blue: $55);
  ColorMagenta: TColor      = (Red: $AA; Green: $00; Blue: $AA);
  ColorRed: TColor          = (Red: $AA; Green: $00; Blue: $00);
  ColorWhite: TColor        = (Red: $FF; Green: $FF; Blue: $FF);
  ColorYellow: TColor       = (Red: $FF; Green: $FF; Blue: $55);

implementation

end.
