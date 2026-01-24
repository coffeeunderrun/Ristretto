{
    This file is part of the Free Pascal Run time library.
    Copyright (c) 1999-2000 by the Free Pascal development team

    This file contains the declarations of internal compiler helper
    routines. That means you can *NOT* call these directly, as they may
    be changed or even removed at any time. The only reason they are
    included in the interface of the system unit, is so that the
    compiler doesn't need special code to access their parameter
    list information etc.

    Note that due to the "compilerproc" directive, it isn't even possible
    to use these routines in your programs.

    See the File COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

procedure fpc_initializeunits; compilerproc;

procedure fpc_do_exit; compilerproc;

procedure fpc_shortstr_to_shortstr(out Res: String; const Str: String); compilerproc;
