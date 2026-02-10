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
      Add('-ap');
      Add('-Aelf');
      Add('-Ci-o-r-t-');
      Add('-Mobjfpc');
      Add('-n');
      Add('-Sagic');
    end;

    with Targets.AddUnit('system.pas') do begin
      IncludePath.Add('inc');
      IncludePath.Add('$(CPU)');
    end;

    with Targets.AddUnit('objpas.pas') do begin
      Dependencies.AddUnit('system');
      IncludePath.Add('objpas');
    end;

    with Targets.AddUnit('sysconst.pas') do begin
      Dependencies.AddUnit('system');
    end;

    with Targets.AddUnit('sysutils.pas') do begin
      Dependencies.AddUnit('system');
      IncludePath.Add('sysutils');
    end;

    with Targets.AddUnit('si_prc.pas') do begin
      Dependencies.AddUnit('system');
    end;

    with Targets.AddUnit('fpintres.pas') do begin
      Dependencies.AddUnit('system');
    end;
  end;

  Installer.Run;
end.
