unit Modules;

interface

function FindModule(Name: String): Pointer;

implementation

uses Limine, Requests, SysUtils;

type
  TModuleInfo = record
    Name: String;
    Ptr: Pointer;
  end;

  TModuleHash = record
    Hash: UInt64;
    Info: TModuleInfo;
  end;

var
  ModuleRequest: TLimineModuleRequest; external name '_limine_request_module';
  ModuleResponse: TLimineModuleResponse;
  ModuleHashArr: array of TModuleHash;

function FindModule(Name: String): Pointer;
var
  Hash: UInt64;
  ModuleHash: TModuleHash;
begin
  if Length(Name) = 0 then exit(nil);
  Hash := HashString(Name);

  WriteLn(LogTrace, Format('Looking for module `%s`, hash %.16X...', [Name, Hash]));

  { TODO: The FGL unit depends on the Types unit which fails to compile with FPUNONE defined.
    Perhaps a minimal Types unit, or a custom hashmap implementation. }
  for ModuleHash in ModuleHashArr do
    if (ModuleHash.Hash = Hash) and (ModuleHash.Info.Name = Name) then begin
      WriteLn(LogTrace, Format('Found module `%s`, hash %.16X.', [Name, Hash]));
      exit(ModuleHash.Info.Ptr);
    end;

  result := nil;
end;

var
  I: UInt8;

begin
  if not Assigned(ModuleRequest.Response) then Panic;

  with ModuleRequest.Response^ do begin
    SetLength(ModuleHashArr, ModuleCount);

    for I := 0 to ModuleCount - 1 do with Modules^[I] do begin
      if Length(Str) = 0 then continue;
      ModuleHashArr[I].Hash := HashString(Str);
      ModuleHashArr[I].Info.Ptr := Address;
      ModuleHashArr[I].Info.Name := Str;
    end;
  end;
end.
