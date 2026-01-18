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

procedure fpc_initializeunits; compilerproc; export; alias: 'FPC_INITIALIZEUNITS';
begin
end;

procedure fpc_do_exit; compilerproc; export; alias: 'FPC_DO_EXIT';
begin
end;

procedure internal_do_exit; external name 'FPC_DO_EXIT';

procedure Halt; inline; noreturn;
begin
  internal_do_exit;
end;
