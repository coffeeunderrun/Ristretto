unit Utilities;

interface

function AddHhdmOffset(Frame: PtrUInt): PtrUInt; inline;
function RemoveHhdmOffset(Page: PtrUInt): PtrUInt; inline;

implementation

uses Limine;

var
  HhdmRequest: TLimineHhdmRequest; external name '_limine_request_hhdm';
  HhdmOffset: PtrUInt;

function AddHhdmOffset(Frame: PtrUInt): PtrUInt;
begin
  result := Frame + HhdmOffset;
end;

function RemoveHhdmOffset(Page: PtrUInt): PtrUInt;
begin
  result := Page - HhdmOffset;
end;

begin
  if not Assigned(HhdmRequest.Response) then Panic('No HHDM response from Limine.');

  HhdmOffset := HhdmRequest.Response^.Offset;
end.
