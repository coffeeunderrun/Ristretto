unit Paging;

interface

procedure Initialize;

implementation

uses ArchApi, Hhdm, Limine, Log;

const
  PAGE_SIZE = $1000;
  DEFAULT_PAGE_LEVEL_MAX = 4;

  PAGE_ENTRY_PRESENT = $1;
  PAGE_ENTRY_WRITABLE = $2;
  PAGE_ENTRY_USER = $4;
  PAGE_ENTRY_WRITE_THROUGH = $8;
  PAGE_ENTRY_CACHE_DISABLE = $10;
  PAGE_ENTRY_PAT = $80;
  PAGE_ENTRY_GLOBAL = $100;
  PAGE_ENTRY_NO_EXECUTE = UInt64($8000000000000000);

type
  PPageTable = ^APageTable;
  APageTable = array [0..511] of UInt64;

var
  PagingModeRequest: TLiminePagingModeRequest; external name '_limine_request_paging_mode';
  PageSize: SizeUInt = PAGE_SIZE; public name '_arch_page_size';
  PageLevelMax: UInt8;

procedure SetLeafEntry(
  var Entry: UInt64;
  Frame: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache
);
begin
  Entry := (UInt64(Frame) and $FFFFFFFFFF000) or PAGE_ENTRY_PRESENT;

  if not (MemoryAccessExecute in MemoryAccess) then Entry := Entry or PAGE_ENTRY_NO_EXECUTE;
  if MemoryAccessGlobal in MemoryAccess then Entry := Entry or PAGE_ENTRY_GLOBAL;
  if MemoryAccessUser in MemoryAccess then Entry := Entry or PAGE_ENTRY_USER;
  if MemoryAccessWrite in MemoryAccess then Entry := Entry or PAGE_ENTRY_WRITABLE;

  case MemoryCache of
    MemoryCacheNone: Entry := Entry or PAGE_ENTRY_CACHE_DISABLE;
    // MemoryCacheWriteBack: do nothing
    MemoryCacheWriteCombining: Entry := Entry or PAGE_ENTRY_PAT or PAGE_ENTRY_WRITE_THROUGH;
    MemoryCacheWriteThrough: Entry := Entry or PAGE_ENTRY_WRITE_THROUGH;
  end;
end;

  function MapPage(
  RootFrame, Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
): Pointer; public name '_arch_map_page';
var
  Shift, PageLevelIndex: UInt8;
  Table: PPageTable;
  TableFrame: PtrUInt;
  TableEntry: PUInt64;
  TableIndex: UInt16;
begin
  result := Pointer(Page);

  // Start at root page table.
  Table := PPageTable(AddHhdmOffset(RootFrame));

  // Root page table entry index.
  Shift := ((PageLevelMax - 1) * 9) + 12;

  // Traverse page table levels.
  for PageLevelIndex := PageLevelMax downto 1 do begin
    TableIndex := (Page shr Shift) and $1FF;
    TableEntry := @Table^[TableIndex];

    Shift := Shift - 9;

    // Is table entry present?
    if (PageLevelIndex > 1) and (TableEntry^ and $1 <> 0) then begin
      TableFrame := TableEntry^ and $FFFFFFFFFF000;
      Table := PPageTable(AddHhdmOffset(TableFrame));
      continue;
    end;

    // Allocate new page table or set leaf entry.
    if PageLevelIndex = 1 then begin
      SetLeafEntry(TableEntry^, Frame, MemoryAccess, MemoryCache);
      WriteBarrier;
      if Assigned(InvalidatePage) then InvalidatePage(Page);
    end else begin
      TableFrame := AllocateFrame();
      if TableFrame = 0 then begin
        Log.ErrorLn('Failed to allocate page table frame.');
        exit(nil);
      end;

      TableEntry^ := (UInt64(TableFrame) and $FFFFFFFFFF000) or PAGE_ENTRY_PRESENT or PAGE_ENTRY_WRITABLE;
      WriteBarrier;
      if Assigned(InvalidatePage) then InvalidatePage(Page);

      Table := PPageTable(AddHhdmOffset(TableFrame));
      FillByte(Table^, SizeOf(Table^), 0);
    end;
  end;
end;

{ TODO: Optimize to map ranges instead of one by one. }
function MapPageRange(
  RootFrame, Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
): Pointer; public name '_arch_map_page_range';
var
  Ptr: Pointer;
begin
  result := Pointer(Page);

  Size := Align(Size, PAGE_SIZE);

  while Size > 0 do begin
    Ptr := MapPage(RootFrame, Frame, Page, MemoryAccess, MemoryCache, AllocateFrame, InvalidatePage);
    if not Assigned(Ptr) then exit(nil);
    Frame += PAGE_SIZE;
    Page += PAGE_SIZE;
    Size -= PAGE_SIZE;
  end;
end;

{ TODO: This should also unmap parent page table when all entries are not present. }
procedure UnMapPage(
  RootFrame, Page: PtrUInt;
  const DeallocateFrame: TDeallocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
); public name '_arch_unmap_page';
var
  Shift, PageLevelIndex: UInt8;
  Table: PPageTable;
  TableFrame: PtrUInt;
  TableEntry: PUInt64;
  TableIndex: UInt16;
begin
  // Start at root page table.
  Table := PPageTable(AddHhdmOffset(RootFrame));

  // Root page table entry index.
  Shift := ((PageLevelMax - 1) * 9) + 12;

  // Traverse page table levels.
  for PageLevelIndex := PageLevelMax downto 1 do begin
    TableIndex := (Page shr Shift) and $1FF;
    TableEntry := @Table^[TableIndex];

    Shift := Shift - 9;

    // Is table entry present?
    if (PageLevelIndex > 1) and (TableEntry^ and $1 <> 0) then begin
      TableFrame := TableEntry^ and $FFFFFFFFFF000;
      Table := PPageTable(AddHhdmOffset(TableFrame));
      continue;
    end;

    // Page table not mapped.
    if PageLevelIndex > 1 then exit;

    // Page table entry is not present.
    if TableEntry^ and $1 = 0 then exit;

    TableFrame := TableEntry^ and $FFFFFFFFFF000;
    TableEntry^ := 0;

    WriteBarrier;
    if Assigned(InvalidatePage) then InvalidatePage(Page);

    DeallocateFrame(TableFrame);
  end;
end;

procedure UnMapPageRange(
  RootFrame, Page: PtrUInt;
  Size: SizeUInt;
  const DeallocateFrame: TDeallocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
); public name '_arch_unmap_page_range';
begin
  Size := Align(Size, PAGE_SIZE);

  while Size > 0 do begin
    UnMapPage(RootFrame, Page, DeallocateFrame, InvalidatePage);
    Page += PAGE_SIZE;
    Size -= PAGE_SIZE;
  end;
end;

procedure Initialize;
begin
  {$ifndef NDEBUG}
  Log.DebugLn('Paging initialized.');
  {$endif}
end;

begin
  if Assigned(PagingModeRequest.Response) then
    case PagingModeRequest.Response^.Mode of
      LIMINE_PAGING_MODE_X86_64_4LVL: PageLevelMax := 4;
      LIMINE_PAGING_MODE_X86_64_5LVL: PageLevelMax := 5;
    else
      PageLevelMax := LIMINE_PAGING_MODE_X86_64_DEFAULT;
    end
  else
    PageLevelMax := DEFAULT_PAGE_LEVEL_MAX;
end.
