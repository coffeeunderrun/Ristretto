unit Modules;

interface

function FindModule(Name: String): Pointer;

implementation

uses Limine, Log, Requests, SysUtils;

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

  Log.TraceLn('Looking for module `' + Name + '`, hash ' + IntToHex(Hash) + '...');

  { TODO: The Classes unit would likely be overkill for kernel space.
    I should look into implementing a hashmap type; maybe a minimal Classes unit like I did with SysUtils. }
  for ModuleHash in ModuleHashArr do
    if (ModuleHash.Hash = Hash) and (ModuleHash.Info.Name = Name) then begin
      Log.TraceLn('Found module `' + Name + '`, hash ' + IntToHex(Hash) + '.');
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
