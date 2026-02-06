unit Arch;

interface

uses Pmm, Vmm;

procedure Initialize;

function CreateRootFrame(
  var RootFrame: PtrUInt;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; external name '_arch_create_root_frame';

procedure LoadRootFrame(const RootFrame: PtrUInt); external name '_arch_load_root_frame';

function MapPage(
  RootFrame, Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; external name '_arch_map_page';

function MapPageRange(
  RootFrame, Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const GetPageFromFrame: TGetPageFromFrameCallback
): Boolean; external name '_arch_map_page_range';

implementation

{$I arch.inc}

end.
