program fpmake;

{$mode objfpc}{$H+}

uses fpmkunit;

begin
  with Installer.AddPackage('rtl') do begin
    // Disable FPU support in RTL.
    Options.Add('-dFPUNONE');

    SourcePath.Add('inc');
    SourcePath.Add('objpas');
    SourcePath.Add('kernel');

    IncludePath.Add('inc');
    IncludePath.Add('objpas');
    IncludePath.Add('kernel');

    // Custom includes for CPU to avoid using FPU instructions/registers in kernel.
    IncludePath.Add('kernel/$(CPU)');

    with Targets.AddUnit('system.pas') do begin
      Options.Add('-Us');
      Options.Add('-Sf-');
      // Options.Add('-SfANSISTRINGS');
      Options.Add('-SfCLASSES');
      // Options.Add('-SfCOMMANDARGS');
      Options.Add('-SfDYNARRAYS');
      Options.Add('-SfEXCEPTIONS');
      Options.Add('-SfFILEIO');
      Options.Add('-SfHEAP');
      Options.Add('-SfOBJECTS');
      // Options.Add('-SfRANDOM');
      // Options.Add('-SfRESOURCES');
      Options.Add('-SfRTTI');
      // Options.Add('-SfSOFTFPU');
      Options.Add('-SfTEXTIO');
      // Options.Add('-SfTHREADING');
      // Options.Add('-SfVARIANTS');
      // Options.Add('-SfWIDESTRINGS');

      with Dependencies do begin
        AddInclude('setjumph.inc');
        AddInclude('systemh.inc');
        AddInclude('objpash.inc');
        AddInclude('mathh.inc');
        AddInclude('wstringh.inc');
        AddInclude('dynarrh.inc');
        AddInclude('compproc.inc');
        AddInclude('heaph.inc');
        AddInclude('threadh.inc');
        AddInclude('varianth.inc');
        AddInclude('sysosh.inc');
        AddInclude('resh.inc');
        AddInclude('currh.inc');
        AddInclude('set.inc');
        AddInclude('int64p.inc');
        AddInclude('setjump.inc');
        AddInclude('sysos.inc');
        AddInclude('sysheap.inc');
        AddInclude('sysdir.inc');
        AddInclude('sysfile.inc');
        AddInclude('sysres.inc');
        AddInclude('except.inc');
        AddInclude('threadvr.inc');
        AddInclude('filerec.inc');
        AddInclude('textrec.inc');
        AddInclude('generic.inc');
        AddInclude('genset.inc');
        AddInclude('genmath.inc');
        AddInclude('gencurr.inc');
        AddInclude('sstrings.inc');
        AddInclude('int64.inc');
        AddInclude('astrings.inc');
        AddInclude('wstrings.inc');
        AddInclude('aliases.inc');
        AddInclude('dynarr.inc');
        AddInclude('objpas.inc');
        AddInclude('variant.inc');
        AddInclude('rtti.inc');
        AddInclude('heap.inc');
        AddInclude('thread.inc');
        AddInclude('text.inc');
        AddInclude('file.inc');
        AddInclude('typefile.inc');
        AddInclude('innr.inc');
        AddInclude('$(CPU).inc');
        AddInclude('math.inc');
        AddInclude('flt_conv.inc');
        AddInclude('flt_core.inc');
        AddInclude('flt_pack.inc');
      end;
    end;

    with Targets.AddUnit('objpas.pp') do Dependencies.AddUnit('system');

    with Targets.AddUnit('heapmgr.pas') do Dependencies.AddUnit('objpas');

    with Targets.AddUnit('sysconst.pp') do Dependencies.AddUnit('objpas');

    with Targets.AddUnit('sysutils.pas') do begin
      with Dependencies do begin
        AddUnit('heapmgr');
        AddUnit('sysconst');
      end;
    end;
  end;

  Installer.Run;
end.
