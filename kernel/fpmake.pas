program fpmake;

{$mode objfpc}{$H+}

uses fpmkunit;

begin
  with Installer.AddPackage('kernel') do begin
    CPUs := [x86_64];
    OSes := [embedded];
    NeedLibC := false;

    UnitPath.Add('arch');
    UnitPath.Add('arch/$(CPU)');
    UnitPath.Add('memory');
    UnitPath.Add('platform');
    UnitPath.Add('video');

    // Limine protocol
    UnitPath.Add('../vendor/limine-protocol');
    IncludePath.Add('../vendor/limine-protocol');

    // uACPI bindings
    UnitPath.Add('../vendor/uacpi-bindings');
    IncludePath.Add('../vendor/uacpi-bindings/inc');

    // Architecture-specific options
    if Defaults.CPU = x86_64 then Options.Add('-Rintel');

    Targets.AddProgram('kernel.pas');
  end;

  Installer.Run;
end.
