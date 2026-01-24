{
    This file is part of the Free Pascal Run time library.
    Copyright (c) 1999-2008 by the Free Pascal development team

    See the file COPYING.FPC, included in this distribution,
    For details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{****************************************************************************
                    Include processor specific routines
****************************************************************************}

{$ifdef cpux86_64}
{$I x86_64.inc}
{$endif cpux86_64}

{ Include generic pascal only routines which are not defined in the processor
  specific include file }
{$I generic.inc}

{****************************************************************************
                  Subroutines for String handling
****************************************************************************}

{ Needs to be before RTTI handling }
{$I sstrings.inc}

{*****************************************************************************
                        Initialization / Finalization
*****************************************************************************}

type
  TInitFinalRec = record
    InitProc: TProcedure;
    FinalProc: TProcedure;
  end;

  PInitFinalTable = ^TInitFinalTable;
  TInitFinalTable = record
    TableCount: SizeUInt;
    InitCount: SizeUInt;
    Procs: array [1..1024] of TInitFinalRec;
  end;

var
  InitFinalTable: TInitFinalTable; external name 'INITFINAL';

procedure fpc_initializeunits; compilerproc; public name 'FPC_INITIALIZEUNITS';
var
  TablePtr: PInitFinalTable;
  I: SizeUInt;
begin
  TablePtr := @InitFinalTable;
  if not Assigned(TablePtr) then exit;

  with TablePtr^ do begin
    for I := 1 to TableCount do begin
      if Assigned(Procs[I].InitProc) then Procs[I].InitProc;
      InitCount := I;
    end;
  end;
end;

procedure internal_initializeunits; external name 'FPC_INITIALIZEUNITS';

{*****************************************************************************
                          Error / Exit / ExitProc
*****************************************************************************}

procedure system_exit; noreturn; forward;

procedure fpc_do_exit; compilerproc; public name 'FPC_DO_EXIT';
begin
  system_exit;
end;

procedure internal_do_exit; external name 'FPC_DO_EXIT';

procedure Halt; noreturn;
begin
  internal_do_exit;
end;
