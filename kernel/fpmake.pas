program fpmake;

{$mode objfpc}{$H+}

uses fpmkunit;

begin
  with Installer.AddPackage('kernel') do begin
    CPUs := [x86_64];
    OSes := [embedded];
    NeedLibC := false;

    // Architecture-specific options
    if Defaults.CPU = x86_64 then Options.Add('-Rintel');

    UnitPath.Add('arch');
    UnitPath.Add('arch/$(CPU)');
    UnitPath.Add('arch/$(CPU)/cpu');
    UnitPath.Add('arch/$(CPU)/device');
    IncludePath.Add('arch/$(CPU)');

    UnitPath.Add('acpi');
    UnitPath.Add('boot');
    UnitPath.Add('boot/limine');
    UnitPath.Add('common');
    UnitPath.Add('memory');
    UnitPath.Add('video');

    UnitPath.Add('../vendor/limine-protocol');
    IncludePath.Add('../vendor/limine-protocol');

    UnitPath.Add('../vendor/uacpi-bindings');
    IncludePath.Add('../vendor/uacpi-bindings/inc');

    Targets.AddProgram('kernel.pas');
  end;

  Installer.Run;
end.
