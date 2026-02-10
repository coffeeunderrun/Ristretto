unit Pmm;

interface

procedure Initialize;

function EarlyAllocateFrame(var Frame: PtrUInt; Size: SizeUInt): Boolean;

implementation

uses ArchApi, Limine, SysUtils, Log;

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

procedure Initialize;
begin
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
  if not Assigned(MemoryMapRequest.Response) then Panic('No memory map response from Limine.');

  MemoryMapIndex := 0;
  MemoryMapOffset := 0;
end.
