unit Acpi.Sync;

interface

implementation

uses SysUtils, Uacpi;

{$ifndef UACPI_BAREBONES_MODE}

{ Events }

function uacpi_kernel_create_event: Tuacpi_handle; cdecl; public;
begin
  result := Tuacpi_handle(-1);
  WriteLn(LogTrace, 'uacpi_kernel_create_event called.');
end;

procedure uacpi_kernel_free_event(Event: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_free_event called.');
end;

function uacpi_kernel_wait_for_event(Event: Tuacpi_handle; Timeout: Tuacpi_u16): Tuacpi_bool; cdecl; public;
begin
  result := true;
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

{ Mutexes }

function uacpi_kernel_create_mutex: Tuacpi_handle; cdecl; public;
begin
  result := Tuacpi_handle(-1);
  WriteLn(LogTrace, 'uacpi_kernel_create_mutex called.');
end;

procedure uacpi_kernel_free_mutex(Mutex: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_free_mutex called.');
end;

function uacpi_kernel_acquire_mutex(Mutex: Tuacpi_handle; Timeout: Tuacpi_u16): Tuacpi_status; cdecl; public;
begin
  result := UACPI_STATUS_UNIMPLEMENTED;
  WriteLn(LogTrace, 'uacpi_kernel_acquire_mutex called.');
end;

procedure uacpi_kernel_release_mutex(Mutex: Tuacpi_handle); cdecl; public;
begin
  WriteLn(LogTrace, 'uacpi_kernel_release_mutex called.');
end;

{ Spinlocks }
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

{$endif UACPI_BAREBONES_MODE}

end.
