{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2014 by Maciej Izak

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$push}
{$Z1}

type
  TTypeKind = (
    tkUnknown,
    tkInteger,
    tkChar,
    tkEnumeration,
    tkFloat,
    tkSet,
    tkMethod,
    tkSString,
    tkLString,
    tkAString,
    tkWString,
    tkVariant,
    tkArray,
    tkRecord,
    tkInterface,
    tkClass,
    tkObject,
    tkWChar,
    tkBool,
    tkInt64,
    tkQWord,
    tkDynArray,
    tkInterfaceRaw,
    tkProcVar,
    tkUString,
    tkUChar,
    tkHelper,
    tkFile,
    tkClassRef,
    tkPointer
  );

{$pop}
