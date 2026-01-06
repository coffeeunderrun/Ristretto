unit Limine;

interface

type
  PLimineVideoMode = ^TLimineVideoMode;
  TLimineVideoMode = record
    Pitch: UInt64;
    Width: UInt64;
    Height: UInt64;
    BitsPerPixel: UInt16;
    MemoryModel: UInt8;
    RedMaskSize: UInt8;
    RedMaskShift: UInt8;
    GreenMaskSize: UInt8;
    GreenMaskShift: UInt8;
    BlueMaskSize: UInt8;
    BlueMaskShift: UInt8;
  end;
  ALimineVideoMode = array of TLimineVideoMode;

  PLimineFramebuffer = ^TLimineFramebuffer;
  TLimineFramebuffer = record
    Address: Pointer;
    Width: UInt64;
    Height: UInt64;
    Pitch: UInt64;
    BitsPerPixel: UInt16;
    MemoryModel: UInt8;
    RedMaskSize: UInt8;
    RedMaskShift: UInt8;
    GreenMaskSize: UInt8;
    GreenMaskShift: UInt8;
    BlueMaskSize: UInt8;
    BlueMaskShift: UInt8;
    Unused: array[0..6] of UInt8;
    EdidSize: UInt64;
    Edid: Pointer;
    ModeCount: UInt64;
    Modes: ^ALimineVideoMode;
  end;
  ALimineFramebuffer = array of TLimineFramebuffer;

  PLimineFramebufferResponse = ^TLimineFramebufferResponse;
  TLimineFramebufferResponse = record
    Revision: UInt64;
    FramebufferCount: UInt64;
    Framebuffers: ^ALimineFramebuffer;
  end;

  TLimineFramebufferRequest = record
    Id: array[0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineFramebufferResponse;
  end;

implementation

end.
