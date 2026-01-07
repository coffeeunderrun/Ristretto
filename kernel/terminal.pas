unit Terminal;

interface

uses Framebuffer;

procedure Initialize();
procedure PutText(X, Y: UInt64; FgColor, BgColor: TColor; Text: PChar);

implementation

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
  TPCScreenFont = record
    Magic: UInt16;
    Mode: UInt8;
    GlyphSize: UInt8;
  end;

var
  RawKernelFontStart: pointer; external name '_binary_kernel_psf_start';
  KernelFontPtr: PPCScreenFont;

  procedure Initialize();
  begin
    KernelFontPtr := PPCScreenFont(@RawKernelFontStart);
  end;

  procedure PutChar(X, Y: UInt64; FgColor, BgColor: TColor; Ch: Char);
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
      Glyph := PUInt8(KernelFontPtr) + sizeof(TPCScreenFont) + (GlyphSize * ord(Ch));

      for GlyphY := 0 to GlyphSize - 1 do begin
        // Start at bit 7 of current glyph byte (row).
        GlyphBit := $80;

        for GlyphX := 0 to 7 do begin
          // Use foreground color if bit is set, otherwise use background color.
          if (Glyph^ and GlyphBit) = GlyphBit then Color := FgColor else Color := BgColor;

          Framebuffer.PutPixel(X + GlyphX, Y + GlyphY, Color);

          // Shift right for next bit of current glyph byte (row).
          GlyphBit := GlyphBit shr 1;
        end;

        // Next glyph byte (row).
        inc(Glyph);
      end;
    end;
  end;

  procedure PutText(X, Y: UInt64; FgColor, BgColor: TColor; Text: PChar);
  var
    I: UInt16 = 0;
  begin
    while Text[I] <> Char(0) do begin
      // TODO: Add wrap at end of row.
      PutChar(X, Y, FgColor, BgColor, Text[I]);
      X := X + 8;
      I := I + 1;
    end
  end;

end.
