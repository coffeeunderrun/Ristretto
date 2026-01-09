const
  LimineRequestStartMarker: array[0..3] of UInt64 = (
    UInt64($F6B8F4B39DE7D1AE),
    UInt64($FAB91A6940FCB9CF),
    UInt64($785C6ED015D3E316),
    UInt64($181E920A7852B9D9)
  ); export name '_limine_request_start_marker';

{$MACRO ON}
{$IFNDEF LIMINE_BASE_REVISION}
{$DEFINE LIMINE_BASE_REVISION := 4}
{$ENDIF}
  LimineRequestBaseRevision: array[0..3] of UInt64 = (
    UInt64($F9562B2D5C95A6C8),
    UInt64($6A7B384944536BDC),
    LIMINE_BASE_REVISION,
    0
  ); export name '_limine_request_base_revision';
{$MACRO OFF}

{$IFDEF LIMINE_REQUEST_FRAMEBUFFER}
  LimineRequestFramebuffer: TLimineFramebufferRequest = (
    Id: (
      UInt64($C7B1DD30DF4C8B88),
      UInt64($0A82E883A194F07B),
      UInt64($9D5827DCD881DD75),
      UInt64($A3148604F6FAB11B)
    );
    Revision: 0;
    Response: nil;
  ); export name '_limine_request_frambuffer';
{$ENDIF}

  LimineRequestEndMarker: array[0..1] of UInt64 = (
    UInt64($ADC0E0531BB10D03),
    UInt64($9572709F31764C62)
  ); export name '_limine_request_end_marker';
