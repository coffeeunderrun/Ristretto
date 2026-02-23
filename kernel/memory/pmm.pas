unit Pmm;

interface

procedure Initialize;

function EarlyAllocateFrame: PtrUInt;

function AllocateFrame: PtrUInt;
procedure DeallocateFrame(Frame: PtrUInt);

implementation

uses Arch, Hhdm, Limine, SysUtils;

const
  MEMORY_MAP_TYPE_NAMES: array [LIMINE_MEMMAP_USABLE..LIMINE_MEMMAP_RESERVED_MAPPED] of String = (
    'USABLE',
    'RESERVED',
    'ACPI_RECLAIMABLE',
    'ACPI_NVS',
    'BAD_MEMORY',
    'BOOTLOADER_RECLAIMABLE',
    'EXECUTABLE_AND_MODULES',
    'FRAMEBUFFER',
    'RESERVED_MAPPED'
  );

var
  MemoryMapRequest: TLimineMemoryMapRequest; external name '_limine_request_memory_map';
  FreeListHead: PtrUInt;
  MemoryMapIndex: SizeUInt;
  MemoryMapOffset: SizeUInt;

procedure PopulateFreeList;
const
  MIB = 1024 * 1024;
var
  AvailablePages, Index, Offset: SizeUInt;
begin
  AvailablePages := 0;
  Index := MemoryMapIndex;
  Offset := MemoryMapOffset;

  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('Populate free list from memory map: index=%d, offset=$%.8X.', [Index, Offset]));
  {$endif NDEBUG}

  with MemoryMapRequest.Response^ do
    while Index < EntryCount do begin
      with Entries^[Index] do begin
        case Entries^[Index].EntryType of
          LIMINE_MEMMAP_USABLE: begin
            AvailablePages += (Entries^[Index].Length - Offset) div PAGE_SIZE;
            while Offset < Length do begin
              DeallocateFrame(Base + Offset);
              Inc(Offset, PAGE_SIZE);
            end;
          end;

          // Reclaimable frames will be deallocated after initialization.
          LIMINE_MEMMAP_ACPI_RECLAIMABLE,
          LIMINE_MEMMAP_BOOTLOADER_RECLAIMABLE:
            AvailablePages += Entries^[Index].Length div PAGE_SIZE;
        end;
      end;

      Offset := 0;
      Inc(Index);
    end;

  WriteLn(Format('Available physical memory: %d MiB', [(AvailablePages * PAGE_SIZE) div MIB]));
end;

procedure Initialize;
begin
  PopulateFreeList;
  WriteLn(LogInfo, 'PMM initialized.');
end;

function EarlyAllocateFrame: PtrUInt;
var
  Frame: PtrUInt;
begin
  with MemoryMapRequest.Response^ do
    while MemoryMapIndex < EntryCount do begin
      with Entries^[MemoryMapIndex] do begin
        if (EntryType = LIMINE_MEMMAP_USABLE) and (MemoryMapOffset < Length) then begin
          Frame := Base + MemoryMapOffset;
          Inc(MemoryMapOffset, PAGE_SIZE);
          exit(Frame);
        end;

        Inc(MemoryMapIndex);
        MemoryMapOffset := 0;
      end;
    end;

  WriteLn(LogError, Format('%s:%s - Out of memory in early frame allocator.', [{$I %FILE%}, {$I %LINE%}]));
  result := High(PtrUInt);
end;

function AllocateFrame: PtrUInt;
var
  Frame: PtrUInt;
  FramePtr: PPtrUInt;
begin
  FramePtr := PPtrUInt(FreeListHead);
  if FramePtr^ = High(PtrUInt) then begin
    WriteLn(LogError, Format('%s:%s - Out of memory in frame allocator.', [{$I %FILE%}, {$I %LINE%}]));
    exit(High(PtrUInt));
  end;

  Frame := RemoveHhdmOffset(FreeListHead);
  FreeListHead := FramePtr^;
  result := Frame;
end;

procedure DeallocateFrame(Frame: PtrUInt);
var
  FramePtr: PPtrUInt;
begin
  FramePtr := PPtrUInt(AddHhdmOffset(Frame));
  FramePtr^ := FreeListHead;
  FreeListHead := PtrUInt(FramePtr);
end;

begin
  if not Assigned(MemoryMapRequest.Response) then Panic('No memory map response from Limine.');

  FreeListHead := High(PtrUInt);
  MemoryMapIndex := 0;
  MemoryMapOffset := 0;
end.
