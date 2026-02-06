unit Paging;

interface

procedure Initialize;

implementation

uses Limine, Log, Pmm, SysUtils, Vmm;

const
  ARCH_PAGE_SIZE = $1000;
  DEFAULT_PAGE_LEVEL_MAX = 4;

type
  PPageTable = ^APageTable;
  APageTable = array [0..511] of UInt64;

var
  PagingModeRequest: TLiminePagingModeRequest; external name '_limine_request_paging_mode';
  PageLevelMax: UInt8;

procedure SetPageTableEntry(
  var Entry: UInt64;
  Frame: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache
); inline;
begin
  Entry := (UInt64(Frame) and $FFFFFFFFFF000) or $1;

  if not (MemoryAccessExecute in MemoryAccess) then Entry := Entry or (UInt64($1) shl 63);
  if MemoryAccessGlobal in MemoryAccess then Entry := Entry or $100;
  if MemoryAccessSupervisor in MemoryAccess then Entry := Entry or $4;
  if MemoryAccessWrite in MemoryAccess then Entry := Entry or $2;

  { TODO: Utilize PAT and MTRRs. }
  case MemoryCache of
    MemoryCacheNone: Entry := Entry or $10;
    // MemoryCacheWriteBack: Entry := Entry or ();
    MemoryCacheWriteThrough: Entry := Entry or $8;
    // MemoryCacheWriteCombining: Entry := Entry or ();
  end;
end;

function MapPage(
  var RootFrame: PtrUInt;
  Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; public name '_arch_map_page';
var
  Shift, PageLevelIndex: UInt8;
  Table: PPageTable;
  TableFrame: PtrUInt;
  TableEntry: PUInt64;
  TableIndex: UInt16;
begin
  // Initialize root page table if not already done.
  if RootFrame = 0 then begin
    RootFrame := AllocateFrame(ARCH_PAGE_SIZE);
    Table := PPageTable(GetPageFromFrame(RootFrame));
    FillByte(Table^, SizeOf(Table^), 0);
  end else
    Table := PPageTable(GetPageFromFrame(RootFrame));

  // Initial shift to get the top-level index.
  Shift := ((DEFAULT_PAGE_LEVEL_MAX - 1) * 9) + 12;

  // Traverse page table levels.
  for PageLevelIndex := DEFAULT_PAGE_LEVEL_MAX downto 1 do begin
    TableIndex := (Page shr Shift) and $1FF;
    TableEntry := @Table^[TableIndex];

    // Next page table level.
    Shift := Shift - 9;

    // If entry is present, follow it.
    if TableEntry^ and $1 <> 0 then begin
      TableFrame := TableEntry^ and $FFFFFFFFFF000;
      Table := PPageTable(GetPageFromFrame(TableFrame));
      continue;
    end;

    // Allocate new page table or use frame for final level.
    if PageLevelIndex = 1 then
      TableFrame := Frame
    else begin
      TableFrame := AllocateFrame(ARCH_PAGE_SIZE);
      Table := PPageTable(GetPageFromFrame(TableFrame));
      FillByte(Table^, SizeOf(Table^), 0);
    end;

    SetPageTableEntry(TableEntry^, TableFrame, MemoryAccess, MemoryCache);
  end;

  result := true;
end;

{ TODO: Optimize to map ranges instead of one by one. }
function MapPageRange(
  var RootFrame: PtrUInt;
  Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; public name '_arch_map_page_range';
begin
  // Align size to page boundary.
  Size := Align(Size, ARCH_PAGE_SIZE);

  // Map pages one by one.
  while Size > 0 do begin
    MapPage(RootFrame, Frame, Page, MemoryAccess, MemoryCache, AllocateFrame, GetPageFromFrame);
    Frame += ARCH_PAGE_SIZE;
    Page += ARCH_PAGE_SIZE;
    Size -= ARCH_PAGE_SIZE;
  end;

  result := true;
end;

procedure Initialize;
begin
  Log.Debug('Paging initialized.');
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
