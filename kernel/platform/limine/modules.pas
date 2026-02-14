unit Modules;

interface

function GetFontModulePtr: Pointer;

implementation

uses Limine, Requests;

var
  ModuleRequest: TLimineModuleRequest; external name '_limine_request_module';
  ModuleResponse: TLimineModuleResponse;

{ TODO: Replace with a proper module management system.}
function GetFontModulePtr: Pointer;
begin
  if not Assigned(ModuleRequest.Response) then Panic;

  with ModuleRequest.Response^ do begin
    if ModuleCount = 0 then Panic;
    result := Modules^[0].Address;
  end;
end;

end.
