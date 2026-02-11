unit Pmm;

interface

procedure Initialize;

function AllocateFrame: PtrUInt;
procedure DeallocateFrame(Frame: PtrUInt);

function EarlyAllocateFrame(var Frame: PtrUInt): Boolean;

implementation

uses ArchApi, Limine, SysUtils, Log, Terminal, Utilities;

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
  FreeListHead: PtrUInt;
  MemoryMapIndex: SizeUInt;
  MemoryMapOffset: SizeUInt;

function AllocateFrame: PtrUInt;
var
  FramePtr: PPtrUInt;
begin
  FramePtr := PPtrUInt(FreeListHead);
  result := RemoveHhdmOffset(FreeListHead);
  FreeListHead := FramePtr^;
end;

procedure DeallocateFrame(Frame: PtrUInt);
var
  FramePtr: PPtrUInt;
begin
  FramePtr := PPtrUInt(AddHhdmOffset(Frame));
  FramePtr^ := FreeListHead;
  FreeListHead := PtrUInt(FramePtr);
end;

procedure PopulateFreeList;
const
  MIB = 1024 * 1024;
var
  AvailablePages, Index, Offset: SizeUInt;
begin
  AvailablePages := 0;
  Index := MemoryMapIndex;
  Offset := MemoryMapOffset;

  Log.TraceLn('Populating free list from memory map: entry index ' + IntToStr(Index) +
    ', offset ' + IntToHex(Offset) + '.');

  with MemoryMapRequest.Response^ do
    while Index < EntryCount do begin
      with Entries^[Index] do begin
        case Entries^[Index].EntryType of
          LIMINE_MEMMAP_USABLE: begin
            AvailablePages += (Entries^[Index].Length - Offset) div PageSize;
            while Offset < Length do begin
              DeallocateFrame(Base + Offset);
              Inc(Offset, PageSize);
            end;
          end;

          // Reclaimable frames will be deallocated after initialization.
          LIMINE_MEMMAP_BOOTLOADER_RECLAIMABLE,
          LIMINE_MEMMAP_ACPI_RECLAIMABLE:
            AvailablePages += Entries^[Index].Length div PageSize;
        end;
      end;

      Offset := 0;
      Inc(Index);
    end;

  Terminal.WriteLn('Available physical memory: ' +
    IntToStr((AvailablePages * PageSize) div MIB) + ' MiB');
end;

procedure Initialize;
begin
  PopulateFreeList;

{$ifndef NDEBUG}
  Log.DebugLn('PMM initialized.');
{$endif}
end;

function EarlyAllocateFrame(var Frame: PtrUInt): Boolean;
begin
  with MemoryMapRequest.Response^ do
    while MemoryMapIndex < EntryCount do begin
      with Entries^[MemoryMapIndex] do begin
        if (EntryType = LIMINE_MEMMAP_USABLE) and (MemoryMapOffset < Length) then begin
          Frame := Base + MemoryMapOffset;
          Inc(MemoryMapOffset, PageSize);
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

  FreeListHead := 0;
  MemoryMapIndex := 0;
  MemoryMapOffset := 0;
end.
