unit Limine;

interface

type
  { Executable Address Request }
  PLimineExecutableAddressResponse = ^TLimineExecutableAddressResponse;
  TLimineExecutableAddressResponse = packed record
    Revision: UInt64;
    PhysicalBase: UInt64;
    VirtualBase: UInt64;
  end;

  TLimineExecutableAddressRequest = packed record
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineExecutableAddressResponse;
  end;

  { Framebuffer Request }
  PLimineVideoMode = ^TLimineVideoMode;
  TLimineVideoMode = packed record
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
  TLimineFramebuffer = packed record
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
    Unused: array [0..6] of UInt8;
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
    Id: array [0..3] of UInt64;
    Revision: UInt64;
    Response: PLimineFramebufferResponse;
  end;

var
  LimineRequestBaseRevision: array [0..3] of UInt64; external name '_limine_request_base_revision';
  LimineExecutableAddressRequest: TLimineExecutableAddressRequest; external name '_limine_request_executable_address';
  LimineRequestFramebuffer: TLimineFramebufferRequest; external name '_limine_request_framebuffer';

function BaseRevisionSupported: Boolean; inline;

implementation

function BaseRevisionSupported: Boolean; inline;
begin
  BaseRevisionSupported := LimineRequestBaseRevision[2] = 0;
end;

end.
