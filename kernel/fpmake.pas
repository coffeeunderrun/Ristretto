program fpmake;

{$mode objfpc}{$H+}

uses fpmkunit;

begin
  with Installer.AddPackage('kernel') do begin
    CPUs := [x86_64];
    OSes := [linux];
    NeedLibC := false;

    // Kernel sources
    SourcePath.Add('src');
    IncludePath.Add('inc');

    // Architecture-specific units
    UnitPath.Add('$(CPU)');

    // Limine protocol
    UnitPath.Add('../vendor/limine-protocol');
    IncludePath.Add('../vendor/limine-protocol');

    // uACPI bindings
    UnitPath.Add('../vendor/uacpi-bindings');
    IncludePath.Add('../vendor/uacpi-bindings/inc');

    // Compiler options
    with Options do begin
      Add('-ap');
      Add('-Aelf');
      Add('-Cni-o-r-t-');
      Add('-Mobjfpc');
      Add('-n');
      Add('-Sagic');
    end;

    // Architecture-specific options
    if Defaults.CPU = x86_64 then Options.Add('-Rintel');

    Targets.AddProgram('kernel.pas');
  end;

  Installer.Run;
end.
