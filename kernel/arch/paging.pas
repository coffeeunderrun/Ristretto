unit Paging;

interface

uses Vmm;

const
  PAGE_SIZE: SizeUInt = 0;

type
  TAllocateFrameCallback = function: PtrUInt;
  TDeallocateFrameCallback = procedure(Frame: PtrUInt);
  TInvalidatePageCallback = procedure(Page: PtrUInt);

function MapPage(
  RootFrame, Frame, Page: PtrUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
): Pointer;

function MapPageRange(
  RootFrame, Frame, Page: PtrUInt;
  Size: SizeUInt;
  MemoryAccess: TMemoryAccessSet;
  MemoryCache: TMemoryCache;
  const AllocateFrame: TAllocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
): Pointer;

procedure UnMapPage(
  RootFrame, Page: PtrUInt;
  const DeallocateFrame: TDeallocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
);

procedure UnMapPageRange(
  RootFrame, Page: PtrUInt;
  Size: SizeUInt;
  const DeallocateFrame: TDeallocateFrameCallback;
  const InvalidatePage: TInvalidatePageCallback = nil
);

procedure LoadRootFrame(RootFrame: PtrUInt); inline;

procedure InvalidatePage(Page: PtrUInt); inline;

implementation

{$I paging.inc}

end.
