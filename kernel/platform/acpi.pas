unit Acpi;

interface

procedure Initialize;

implementation

uses Device, DeviceMgr, HeapMgr, Hhdm, IoPort, Limine, SysUtils, Uacpi, Vmm;

var
  RsdpRequest: TLimineRsdpRequest; external name '_limine_request_rsdp';

type
  Tuacpi_work_type = (UACPI_WORK_GPE_EXECUTION, UACPI_WORK_NOTIFICATION);
  Tuacpi_work_handler = procedure(Ctx: Tuacpi_handle); cdecl;

function InitializeDevice(User: Pointer; Node: Puacpi_namespace_node; NodeDepth: Tuacpi_u32): Tuacpi_iteration_decision; cdecl;
var
  Status: Tuacpi_status;
  NodeInfo: Puacpi_namespace_node_info;
  Path: Puacpi_char;
  DeviceDescriptor: TDeviceDescriptor;
  IdIndex, IdCount: SizeUInt;
begin
  Status := uacpi_get_namespace_node_info(Node, NodeInfo);
  if Status <> UACPI_STATUS_OK then begin
    Path := uacpi_namespace_node_generate_absolute_path(Node);
    WriteLn(LogError, Format('uACPI device: path=%s, status=%s.', [Path, uacpi_status_to_string(Status)]));
    uacpi_free_absolute_path(Path);
    exit(UACPI_ITERATION_DECISION_CONTINUE);
  end;

  WriteLn(LogDebug, Format('uACPI device: depth=%d, name=%s, hid=%s.',
    [NodeDepth, String(NodeInfo^.Obj_Name.Text), NodeInfo^.Hid.Value]));

  // Construct a device descriptor for device manager registration.
  DeviceDescriptor := default(TDeviceDescriptor);
  with NodeInfo^, DeviceDescriptor do begin
    // Get ID count for dynamic array length.
    IdCount := 0;
    if (Flags and UACPI_NS_NODE_INFO_HAS_HID) <> 0 then Inc(IdCount);
    if (Flags and UACPI_NS_NODE_INFO_HAS_CID) <> 0 then Inc(IdCount, Cid.Num_Ids);
    SetLength(IdArr, IdCount);

    // Populate ID dynamic array.
    if (Flags and UACPI_NS_NODE_INFO_HAS_HID) <> 0 then IdArr[0].Value := NodeInfo^.Hid.Value;
    if (Flags and UACPI_NS_NODE_INFO_HAS_CID) <> 0 then
      for IdIndex := 0 to Cid.Num_Ids - 1 do IdArr[IdIndex + 1].Value := Cid.GetId(IdIndex).Value;
  end;

  DeviceMgr.RegisterDevice(DeviceDescriptor);

  uacpi_free_namespace_node_info(NodeInfo);
  result := UACPI_ITERATION_DECISION_CONTINUE;
end;

procedure Initialize;
var
  Status: Tuacpi_status;
begin
  // uacpi_context_set_log_level(UACPI_LOG_DEBUG);

  Status := uacpi_initialize(0);
  if Status <> UACPI_STATUS_OK then begin
    WriteLn(LogFatal, Format('uACPI status: %s.', [uacpi_status_to_string(Status)]));
    exit;
  end;
  WriteLn(LogInfo, 'uACPI initialized.');

  Status := uacpi_namespace_load;
  if Status <> UACPI_STATUS_OK then begin
    WriteLn(LogFatal, Format('uACPI status: %s.', [uacpi_status_to_string(Status)]));
    exit;
  end;
  WriteLn(LogInfo, 'uACPI namespace loaded.');

  Status := uacpi_namespace_initialize;
  if Status <> UACPI_STATUS_OK then begin
    WriteLn(LogFatal, Format('uACPI status: %s.', [uacpi_status_to_string(Status)]));
    exit;
  end;
  WriteLn(LogInfo, 'uACPI namespace initialized.');

  Status := uacpi_finalize_gpe_initialization;
  if Status <> UACPI_STATUS_OK then begin
    WriteLn(LogFatal, Format('uACPI status: %s.', [uacpi_status_to_string(Status)]));
    exit;
  end;
  WriteLn(LogInfo, 'uACPI GPEs initialized.');

  uacpi_namespace_for_each_child(
    uacpi_namespace_root,
    @InitializeDevice,
    UACPI_NULL,
    UACPI_OBJECT_DEVICE_BIT,
    UACPI_MAX_DEPTH_ANY,
    UACPI_NULL
  );
end;

function uacpi_kernel_get_rsdp(out Address: Tuacpi_phys_addr): Tuacpi_status; cdecl; public;
begin
  if Assigned(RsdpRequest.Response) then begin
    // Limine protocol base revision 4 states that the RSDP address will be virtual (HHDM).
    Address := Tuacpi_phys_addr(RemoveHhdmOffset(PtrUInt(RsdpRequest.Response^.Address)));
    {$ifndef NDEBUG}
    WriteLn(LogDebug, Format('uACPI RSDP found: paddr=$%.16X.', [Address]));
    {$endif}
    exit(UACPI_STATUS_OK);
  end;

  result := UACPI_STATUS_NOT_FOUND;
end;

function uacpi_kernel_map(Address: Tuacpi_phys_addr; Size: Tuacpi_size): Pointer; cdecl; public;
begin
  result := MapDirectPageRange(Address, Size);
  {$ifndef NDEBUG}
  // WriteLn(LogDebug, Format('uACPI map: paddr=$%.16X, vaddr=$%P, size=%d bytes.', [Address, result, Size]));
  {$endif}
end;

procedure uacpi_kernel_unmap(Ptr: Pointer; Size: Tuacpi_size); cdecl; public;
begin
  UnMapDirectPageRange(Ptr, Size);
  {$ifndef NDEBUG}
  // WriteLn(LogDebug, Format('uACPI unmap: vaddr=$%P, size=%d bytes.', [Ptr, Size]));
  {$endif}
end;

procedure uacpi_kernel_log(LogLevel: Tuacpi_log_level; const Message: Puacpi_char); cdecl; public;
begin
  case LogLevel of
    UACPI_LOG_ERROR: Write(LogError, Message);
    UACPI_LOG_WARN: Write(LogWarn, Message);
    UACPI_LOG_INFO: Write(LogInfo, Message);
    UACPI_LOG_TRACE: Write(LogTrace, Message);
    UACPI_LOG_DEBUG: Write(LogDebug, Message);
  end;
end;

function uacpi_kernel_pci_device_open(Address: Tuacpi_pci_address; out OutHandle: Tuacpi_handle): Tuacpi_status; cdecl; public;
begin
  OutHandle := Tuacpi_handle(-1);
  result := UACPI_STATUS_NOT_FOUND;
  WriteLn(LogTrace, 'uacpi_kernel_pci_device_open called.');
end;

procedure uacpi_kernel_pci_device_close(Handle: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_pci_device_close called.');
end;

function uacpi_kernel_pci_read8(Device: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u8): Tuacpi_status; cdecl; public;
begin
  Value := 0;
  result := UACPI_STATUS_NOT_FOUND;
  WriteLn(LogTrace, 'uacpi_kernel_pci_read8 called.');
end;

function uacpi_kernel_pci_read16(Device: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  Value := 0;
  result := UACPI_STATUS_NOT_FOUND;
  WriteLn(LogTrace, 'uacpi_kernel_pci_read16 called.');
end;

function uacpi_kernel_pci_read32(Device: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u32): Tuacpi_status; cdecl; public;
begin
  Value := 0;
  result := UACPI_STATUS_NOT_FOUND;
  WriteLn(LogTrace, 'uacpi_kernel_pci_read32 called.');
end;

function uacpi_kernel_pci_write8(Device: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u8): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_NOT_FOUND;
  WriteLn(LogTrace, 'uacpi_kernel_pci_write8 called.');
end;

function uacpi_kernel_pci_write16(Device: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_NOT_FOUND;
  WriteLn(LogTrace, 'uacpi_kernel_pci_write16 called.');
end;

function uacpi_kernel_pci_write32(Device: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u32): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_NOT_FOUND;
  WriteLn(LogTrace, 'uacpi_kernel_pci_write32 called.');
end;

function uacpi_kernel_io_map(Base: Tuacpi_io_addr; Len: Tuacpi_size; out OutHandle: Tuacpi_handle): Tuacpi_status; cdecl; public;
begin
  OutHandle := Tuacpi_handle(Base);
  result := UACPI_STATUS_OK;
  WriteLn(LogTrace, 'uacpi_kernel_io_map called.');
end;

procedure uacpi_kernel_io_unmap(Handle: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_io_unmap called.');
end;

function uacpi_kernel_io_read8(Handle: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u8): Tuacpi_status; cdecl; public;
begin
  Value := ReadIoPort8(Tuacpi_io_addr(Handle) + Offset);
  result := UACPI_STATUS_OK;
  WriteLn(LogTrace, 'uacpi_kernel_io_read8 called.');
end;

function uacpi_kernel_io_read16(Handle: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  Value := ReadIoPort16(Tuacpi_io_addr(Handle) + Offset);
  result := UACPI_STATUS_OK;
  WriteLn(LogTrace, 'uacpi_kernel_io_read16 called.');
end;

function uacpi_kernel_io_read32(Handle: Tuacpi_handle; Offset: Tuacpi_size; out Value: Tuacpi_u32): Tuacpi_status; cdecl; public;
begin
  Value := ReadIoPort32(Tuacpi_io_addr(Handle) + Offset);
  result := UACPI_STATUS_OK;
  WriteLn(LogTrace, 'uacpi_kernel_io_read32 called.');
end;

function uacpi_kernel_io_write8(Handle: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u8): Tuacpi_status; cdecl; public;
begin
  WriteIoPort8(Tuacpi_io_addr(Handle) + Offset, Value);
  result := UACPI_STATUS_OK;
  WriteLn(LogTrace, 'uacpi_kernel_io_write8 called.');
end;

function uacpi_kernel_io_write16(Handle: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  WriteIoPort16(Tuacpi_io_addr(Handle) + Offset, Value);
  result := UACPI_STATUS_OK;
  WriteLn(LogTrace, 'uacpi_kernel_io_write16 called.');
end;

function uacpi_kernel_io_write32(Handle: Tuacpi_handle; Offset: Tuacpi_size; Value: Tuacpi_u32): Tuacpi_status; cdecl; public;
begin
  WriteIoPort32(Tuacpi_io_addr(Handle) + Offset, Value);
  result := UACPI_STATUS_OK;
  WriteLn(LogTrace, 'uacpi_kernel_io_write32 called.');
end;

function uacpi_kernel_alloc(Size: Tuacpi_size): Pointer; cdecl; public;
begin
  result := GetMem(Size);
  {$ifndef NDEBUG}
  // WriteLn(LogDebug, Format('uACPI alloc: vaddr=$%P, size=%d bytes.', [result, Size]));
  {$endif}
end;

procedure uacpi_kernel_free(Mem: Pointer); cdecl; public;
begin
  FreeMem(Mem);
  {$ifndef NDEBUG}
  // WriteLn(LogDebug, Format('uACPI free: vaddr=$%P.', [Mem]));
  {$endif}
end;

function uacpi_kernel_get_nanoseconds_since_boot: Tuacpi_u64; cdecl; public;
begin
  result := 0;
  WriteLn(LogTrace, 'uacpi_kernel_get_nanoseconds_since_boot called.');
end;

procedure uacpi_kernel_stall(Usec: Tuacpi_u8); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_stall called.');
end;

procedure uacpi_kernel_sleep(Msec: Tuacpi_u64); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_sleep called.');
end;

function uacpi_kernel_create_mutex: Tuacpi_handle; cdecl; public;
begin
  result := Tuacpi_handle(-1);
  WriteLn(LogTrace, 'uacpi_kernel_create_mutex called.');
end;

procedure uacpi_kernel_free_mutex(Mutex: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_free_mutex called.');
end;

function uacpi_kernel_create_event: Tuacpi_handle; cdecl; public;
begin
  result := Tuacpi_handle(-1);
  WriteLn(LogTrace, 'uacpi_kernel_create_event called.');
end;

procedure uacpi_kernel_free_event(Event: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_free_event called.');
end;

function uacpi_kernel_get_thread_id: Tuacpi_thread_id; cdecl; public;
begin
  result := UACPI_THREAD_ID_NONE;
  WriteLn(LogTrace, 'uacpi_kernel_get_thread_id called.');
end;

function uacpi_kernel_disable_interrupts: Tuacpi_interrupt_state; cdecl; public;
begin
  result := 0;
  WriteLn(LogTrace, 'uacpi_kernel_disable_interrupts called.');
end;

procedure uacpi_kernel_restore_interrupts(state: Tuacpi_interrupt_state); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_restore_interrupts called.');
end;

function uacpi_kernel_acquire_mutex(Mutex: Tuacpi_handle; Timeout: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_OK;
  // WriteLn(LogTrace, 'uacpi_kernel_acquire_mutex called.');
end;

procedure uacpi_kernel_release_mutex(Mutex: Tuacpi_handle); cdecl; public;
begin
  // WriteLn(LogTrace, 'uacpi_kernel_release_mutex called.');
end;

function uacpi_kernel_wait_for_event(Event: Tuacpi_handle; Timeout: Tuacpi_u16): Tuacpi_bool; cdecl; public;
begin
  result := false;
  WriteLn(LogTrace, 'uacpi_kernel_wait_for_event called.');
end;

procedure uacpi_kernel_signal_event(Event: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_signal_event called.');
end;

procedure uacpi_kernel_reset_event(Event: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_reset_event called.');
end;

function uacpi_kernel_handle_firmware_request(Request: Tuacpi_firmware_request): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_NOT_FOUND;
  WriteLn(LogTrace, 'uacpi_kernel_handle_firmware_request called.');
end;

function uacpi_kernel_install_interrupt_handler(
  Irq: Tuacpi_u32;
  Handler: Tuacpi_interrupt_handler;
  Ctx: Tuacpi_handle;
  out OutIrqHandle: Tuacpi_handle
): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_OK;
  OutIrqHandle := Tuacpi_handle(Irq);
  {$ifndef NDEBUG}
  WriteLn(LogDebug, Format('uACPI install interrupt handler: IRQ=%d, Handler=%p, Ctx=%p.', [Irq, @Handler, Ctx]));
  {$endif}
end;

function uacpi_kernel_uninstall_interrupt_handler(Handler: Tuacpi_interrupt_handler; IrqHandle: Tuacpi_handle): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_OK;
  WriteLn(LogTrace, 'uacpi_kernel_uninstall_interrupt_handler called.');
end;

function uacpi_kernel_create_spinlock: Tuacpi_handle; cdecl; public;
begin
  result := Tuacpi_handle(-1);
  WriteLn(LogTrace, 'uacpi_kernel_create_spinlock called.');
end;

procedure uacpi_kernel_free_spinlock(Spinlock: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_free_spinlock called.');
end;

function uacpi_kernel_lock_spinlock(Spinlock: Tuacpi_handle): Tuacpi_cpu_flags; cdecl; public;
begin
  result := 0;
  WriteLn(LogTrace, 'uacpi_kernel_lock_spinlock called.');
end;

procedure uacpi_kernel_unlock_spinlock(Spinlock: Tuacpi_handle; Flags: Tuacpi_cpu_flags); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_unlock_spinlock called.');
end;

function uacpi_kernel_schedule_work(WorkType: Tuacpi_work_type; Handler: Tuacpi_work_handler; Ctx: Tuacpi_handle): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_schedule_work called.');
end;

function uacpi_kernel_wait_for_work_completion: Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_wait_for_work_completion called.');
end;

end.
