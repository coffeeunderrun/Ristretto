unit System;

{$implicitexceptions off}

interface

{$I systemh.inc}

procedure Panic; noreturn; external name '_arch_panic';
procedure Panic(Msg: String); noreturn; external name '_arch_panic_msg';

implementation

{$I system.inc}

procedure system_exit; noreturn; external name '_halt';

end.
