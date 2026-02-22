unit Acpi.Task;

interface

implementation

uses SysUtils, Uacpi;

{$ifndef UACPI_BAREBONES_MODE}

type
  Tuacpi_work_type = (
    UACPI_WORK_GPE_EXECUTION,
    UACPI_WORK_NOTIFICATION
  );

  Tuacpi_work_handler = procedure(Ctx: Tuacpi_handle); cdecl;

procedure uacpi_kernel_sleep(Msec: Tuacpi_u64); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_sleep called.');
end;

function uacpi_kernel_get_thread_id: Tuacpi_thread_id; cdecl; public;
begin
  result := UACPI_THREAD_ID_NONE;
  WriteLn(LogTrace, 'uacpi_kernel_get_thread_id called.');
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

{$endif UACPI_BAREBONES_MODE}

end.
