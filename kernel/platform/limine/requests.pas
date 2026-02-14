unit Requests;

interface

uses Limine;

{$define LIMINE_REQUEST_EXECUTABLE_ADDRESS}
{$define LIMINE_REQUEST_FRAMEBUFFER}
{$define LIMINE_REQUEST_HHDM}
{$define LIMINE_REQUEST_MEMORY_MAP}
{$define LIMINE_REQUEST_MODULE}
{$define LIMINE_REQUEST_PAGING_MODE}
{$define LIMINE_REQUEST_RSDP}
{$I limine.inc}

implementation

begin
  if not Limine.BaseRevisionSupported then Panic;
end.
