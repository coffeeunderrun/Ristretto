unit Pmm;

interface

type
  TAllocateFrameCallback = function(Size: SizeUInt): PtrUInt;

function EarlyAllocateFrame(Size: SizeUInt): PtrUInt;

implementation

uses Limine, SysUtils, Log;

const
  MEMORY_MAP_TYPE_NAMES: array [LIMINE_MEMMAP_USABLE..LIMINE_MEMMAP_ACPI_TABLES] of String = (
    'USABLE',
    'RESERVED',
    'ACPI_RECLAIMABLE',
    'ACPI_NVS',
    'BAD_MEMORY',
    'BOOTLOADER_RECLAIMABLE',
    'EXECUTABLE_AND_MODULES',
    'FRAMEBUFFER',
    'ACPI_TABLES'
  );

var
  MemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';

function EarlyAllocateFrame(Size: SizeUInt): PtrUInt;
var
  I: SizeUInt;
begin
  { TODO: Do NOT mutate the Limine memory map. }
  with MemoryMapRequest.Response^ do begin
    for I := 1 to EntryCount do with Entries^[I] do begin
      if (EntryType <> LIMINE_MEMMAP_USABLE) or (Length < Size) then continue;

      result := Base;
      Base := Base + Size;
      Length := Length - Size;
      exit;
    end;
  end;

  result := default(PtrUInt);
end;

procedure ParseMemoryMap;
var
  I: SizeUInt;
begin
  with MemoryMapRequest.Response^ do begin
    for I := 1 to EntryCount do
      Log.Debug('Memory Map Entry:' +
        ' Base=' + IntToHex(Entries^[I].Base) +
        ' Size=' + IntToHex(Entries^[I].Length) +
        ' Type=' + MEMORY_MAP_TYPE_NAMES[Entries^[I].EntryType]);
  end;
end;

begin
  if not Assigned(MemoryMapRequest.Response) then begin
    Log.Fatal('No memory map response from Limine.');
    exit;
  end;

  ParseMemoryMap;
  Log.Debug('Unit initialized: PMM');
end.
