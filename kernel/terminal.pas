unit Terminal;

interface

uses Color;

procedure Initialize;
procedure Clear;

procedure SetX(const X: UInt64);
procedure SetY(const Y: UInt64);

procedure SetBackground(const Color: TColor);
procedure SetForeground(const Color: TColor);

function GetBackground: TColor;
function GetForeground: TColor;

procedure Write(const Text: ShortString);
procedure Write(const Text: ShortString; const FgColor: TColor);
procedure Write(const Text: ShortString; const FgColor, BgColor: TColor);

implementation

uses Framebuffer;

const
  PCScreenFontMagic: UInt16 = $0436;
  PCScreenFontMode512: UInt8 = $01;
  PCScreenFontModeHasTab: UInt8 = $02;
  PCScreenFontModeHasSequence: UInt8 = $04;
  PCScreenFontModeMax: UInt8 = $05;
  PCScreenFontSeparator: UInt16 = $FFFF;
  PCScreenFontStartSequence: UInt16 = $FFFE;

type
  PPCScreenFont = ^TPCScreenFont;
  TPCScreenFont = packed record
    Magic: UInt16;
    Mode: UInt8;
    GlyphSize: UInt8;
  end;

var
  RawKernelFontStart: pointer; external name '_binary_kernel_psf_start';
  KernelFontPtr: PPCScreenFont;
  TerminalX: UInt64;
  TerminalY: UInt64;
  TerminalBgColor: TColor;
  TerminalFgColor: TColor;

procedure Initialize;
begin
  KernelFontPtr := PPCScreenFont(@RawKernelFontStart);
  Clear;
end;

procedure Clear;
begin
  TerminalX := 0;
  TerminalY := 0;
  TerminalBgColor := ColorBlack;
  TerminalFgColor := ColorAmber;
  Framebuffer.Clear(TerminalBgColor);
end;

procedure PutChar(const X, Y: UInt64; const FgColor, BgColor: TColor; const Ch: Char);
var
  GlyphBit: UInt8;
  GlyphX: UInt8;
  GlyphY: UInt8;
  Glyph: PUInt8;
  Color: TColor;
begin
  with KernelFontPtr^ do begin
    // Glyphs immediately follow the PSF1 header.
    // Offset by character multiplied by glyph size in bytes.
    Glyph := PUInt8(KernelFontPtr) + SizeOf(TPCScreenFont) + (GlyphSize * Ord(Ch));

    for GlyphY := 0 to GlyphSize - 1 do begin
      // Start at bit 7 of current glyph byte (row).
      GlyphBit := $80;

      for GlyphX := 0 to 7 do begin
        // Use foreground color if bit is set, otherwise use background color.
        if (Glyph^ and GlyphBit) <> 0 then Color := FgColor else Color := BgColor;

        Framebuffer.PutPixel(X + GlyphX, Y + GlyphY, Color);

        // Shift right for next bit of current glyph byte (row).
        GlyphBit := GlyphBit shr 1;
      end;

      // Next glyph byte (row).
      Inc(Glyph);
    end;
  end;
end;

procedure SetX(const X: UInt64); begin TerminalX := X; end;
procedure SetY(const Y: UInt64); begin TerminalY := Y; end;

procedure SetBackground(const Color: TColor); begin TerminalBgColor := Color; end;
procedure SetForeground(const Color: TColor); begin TerminalFgColor := Color; end;

function GetBackground: TColor; begin GetBackground := TerminalBgColor; end;
function GetForeground: TColor; begin GetForeground := TerminalFgColor; end;

procedure NewLine;
begin
  TerminalX := 0;
  if (TerminalY + KernelFontPtr^.GlyphSize) >= Framebuffer.GetHeight then
    Framebuffer.MoveUp(KernelFontPtr^.GlyphSize, TerminalBgColor)
  else
    TerminalY += KernelFontPtr^.GlyphSize;
end;

procedure Write(const Text: ShortString);
begin
  Write(Text, TerminalFgColor, TerminalBgColor);
end;

procedure Write(const Text: ShortString; const FgColor: TColor);
begin
  Write(Text, FgColor, TerminalBgColor);
end;

procedure Write(const Text: ShortString; const FgColor, BgColor: TColor);
var
  Ch: Char;
begin
  for Ch in Text do case Ch of
    // Printable characters.
    #32..#255: begin
      // Wrap to next line if character will go beyond the screen width.
      if (TerminalX + 8) >= Framebuffer.GetWidth then NewLine;
      PutChar(TerminalX, TerminalY, FgColor, BgColor, Ch);
      TerminalX += 8;
    end;

    // Line feed.
    #10: NewLine;

    // Carriage return.
    #13: TerminalX := 0;
  end;
end;

end.
