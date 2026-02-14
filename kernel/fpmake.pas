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
    UnitPath.Add('memory');
    UnitPath.Add('platform');
    UnitPath.Add('video');

    // Limine protocol
    Targets.AddUnit('../vendor/limine-protocol/limine.pas');

    { The idea here is to abstract Limine away from the kernel to eventually allow other boot protocols.
      I may need to rework this as more units are added. }
    with Targets.AddUnit('platform/limine/modules.pas') do begin
      IncludePath.Add('../vendor/limine-protocol');

      with Dependencies do begin
        AddUnit('limine');
      end;
    end;

    // uACPI bindings
    with Targets.AddUnit('../vendor/uacpi-bindings/uacpi.pas') do begin
      IncludePath.Add('../vendor/uacpi-bindings/inc');
    end;

    // Kernel
    with Targets.AddProgram('kernel.pas') do begin
      with Dependencies do begin
        AddUnit('modules');
        AddUnit('uacpi');
      end;
    end;
  end;

  Installer.Run;
end.
