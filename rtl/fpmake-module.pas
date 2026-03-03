program fpmake;

{$mode objfpc}{$H+}

uses fpmkunit;

begin
  with Installer.AddPackage('rtl') do begin
    SourcePath.Add('module');

    with Targets.AddUnit('system.pas') do begin
      Options.Add('-Us');
      Options.Add('-Sf-');
    end;
  end;

  Installer.Run;
end.
