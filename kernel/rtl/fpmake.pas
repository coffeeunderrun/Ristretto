program fpmake;

{$mode objfpc}{$H+}

uses fpmkunit;

begin
  with Installer.AddPackage('rtl') do begin
    CPUs := [x86_64];
    OSes := [linux];
    NeedLibC := false;

    Directory := 'rtl';
    SourcePath.Add('src');

    with Options do begin
      Add('-n');
      Add('-Aelf');
      Add('-Ci-o-r-t-');
      Add('-Mobjfpc');
      Add('-Sagic');
    end;

    with Targets.AddUnit('system.pas') do begin
      IncludePath.Add('inc');
      IncludePath.Add('$(CPU)');
    end;

    Targets.AddUnit('objpas.pas');
    Targets.AddUnit('sysconst.pas');

    with Targets.AddUnit('sysutils.pas') do begin
      IncludePath.Add('sysutils');
    end;

    Targets.AddUnit('si_prc.pas');
    Targets.AddUnit('fpintres.pas');
  end;

  Installer.Run;
end.
