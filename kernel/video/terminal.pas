unit Terminal;

interface

uses Color;

procedure Clear;

procedure SetX(X: UInt64); inline;
procedure SetY(Y: UInt64); inline;

procedure SetBackground(Color: TColor); inline;
procedure SetForeground(Color: TColor); inline;

function GetBackground: TColor; inline;
function GetForeground: TColor; inline;

procedure Write(const Text: String); inline;
procedure Write(const Text: String; FgColor: TColor); inline;
procedure Write(const Text: String; FgColor, BgColor: TColor);

procedure WriteLn(const Text: String); inline;
procedure WriteLn(const Text: String; FgColor: TColor); inline;
procedure WriteLn(const Text: String; FgColor, BgColor: TColor);

implementation

{$macro on}
{$define DEFAULT_BG_COLOR := ColorBlack}
{$define DEFAULT_FG_COLOR := ColorAmber}

uses Framebuffer, Modules;

const
  PSF_MAGIC: UInt16 = $0436;
  PSF_MODE_512: UInt8 = $01;
  PSF_MODE_HAS_TAB: UInt8 = $02;
  PSF_MODE_HAS_SEQUENCE: UInt8 = $04;
  PSF_MODE_MAX: UInt8 = $05;
  PSF_SEPARATOR: UInt16 = $FFFF;
  PSF_START_SEQUENCE: UInt16 = $FFFE;

type
  PPCScreenFont = ^TPCScreenFont;
  TPCScreenFont = packed record
    Magic: UInt16;
    Mode: UInt8;
    GlyphSize: UInt8;
  end;

var
  KernelFontPtr: PPCScreenFont;
  TerminalX: UInt64;
  TerminalY: UInt64;
  TerminalBgColor: TColor;
  TerminalFgColor: TColor;

procedure Clear;
begin
  TerminalX := 0;
  TerminalY := 0;
  TerminalBgColor := DEFAULT_BG_COLOR;
  TerminalFgColor := DEFAULT_FG_COLOR;
  Framebuffer.Clear(TerminalBgColor);
end;

procedure PutChar(X, Y: UInt64; FgColor, BgColor: TColor; Ch: Char);
var
  GlyphX, GlyphY: UInt8;
  GlyphBit: UInt8;
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

procedure SetX(X: UInt64); begin TerminalX := X; end;
procedure SetY(Y: UInt64); begin TerminalY := Y; end;

procedure SetBackground(Color: TColor); begin TerminalBgColor := Color; end;
procedure SetForeground(Color: TColor); begin TerminalFgColor := Color; end;

function GetBackground: TColor; begin result := TerminalBgColor; end;
function GetForeground: TColor; begin result := TerminalFgColor; end;

procedure NewLine;
begin
  TerminalX := 0;
  if (TerminalY + KernelFontPtr^.GlyphSize) >= Framebuffer.GetHeight then
    Framebuffer.MoveUp(KernelFontPtr^.GlyphSize, TerminalBgColor)
  else
    TerminalY += KernelFontPtr^.GlyphSize;
end;

procedure Write(const Text: String);
begin
  Write(Text, TerminalFgColor, TerminalBgColor);
end;

procedure Write(const Text: String; FgColor: TColor);
begin
  Write(Text, FgColor, TerminalBgColor);
end;

procedure Write(const Text: String; FgColor, BgColor: TColor);
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

procedure WriteLn(const Text: String);
begin
  WriteLn(Text, TerminalFgColor, TerminalBgColor);
end;

procedure WriteLn(const Text: String; FgColor: TColor);
begin
  WriteLn(Text, FgColor, TerminalBgColor);
end;

procedure WriteLn(const Text: String; FgColor, BgColor: TColor);
begin
  Write(Text + #10, FgColor, BgColor);
end;

begin
  TerminalX := 0;
  TerminalY := 0;
  TerminalBgColor := DEFAULT_BG_COLOR;
  TerminalFgColor := DEFAULT_FG_COLOR;
  KernelFontPtr := PPCScreenFont(Modules.GetFontModulePtr);
end.
