unit Pmm;

interface

type
  TAllocateFrameCallback = function(var Frame: PtrUInt; Size: SizeUInt): Boolean;

procedure Initialize;

function EarlyAllocateFrame(var Frame: PtrUInt; Size: SizeUInt): Boolean;

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
  MemoryMapIndex: SizeUInt;
  MemoryMapOffset: SizeUInt;

procedure ParseMemoryMap;
var
  I: SizeUInt;
begin
  with MemoryMapRequest.Response^ do begin
    for I := 0 to EntryCount - 1 do
      Log.DebugLn('Memory Map Entry:' +
        ' Base=' + IntToHex(Entries^[I].Base) +
        ' Size=' + IntToHex(Entries^[I].Length) +
        ' Type=' + MEMORY_MAP_TYPE_NAMES[Entries^[I].EntryType]);
  end;
end;

procedure Initialize;
begin
  if not Assigned(MemoryMapRequest.Response) then begin
    Log.FatalLn('No memory map response from Limine.');
    Halt;
  end;

  // ParseMemoryMap;
{$ifndef NDEBUG}
  Log.DebugLn('PMM initialized.');
{$endif}
end;

function EarlyAllocateFrame(var Frame: PtrUInt; Size: SizeUInt): Boolean;
begin
  with MemoryMapRequest.Response^ do
    while MemoryMapIndex < EntryCount do begin
      with Entries^[MemoryMapIndex] do begin
        if (EntryType = LIMINE_MEMMAP_USABLE) and (MemoryMapOffset < Length) then begin
          Frame := Base + MemoryMapOffset;
          Inc(MemoryMapOffset, Size);
          // Log.TraceLn('EarlyAllocateFrame: Allocated frame at ' + IntToHex(Frame) + ' of size ' + IntToHex(Size));
          exit(true);
        end;

        Inc(MemoryMapIndex);
        MemoryMapOffset := 0;
      end;
    end;

  Log.ErrorLn('Out of memory in early frame allocator.');
  result := false;
end;

begin
  if not Assigned(MemoryMapRequest.Response) then begin
    Log.FatalLn('No memory map response from Limine.');
    Halt;
  end;

  MemoryMapIndex := 0;
  MemoryMapOffset := 0;
end.
