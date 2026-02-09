unit System;

{$implicitexceptions off}

interface

{$I systemh.inc}

implementation

{$I system.inc}

procedure system_exit; noreturn; external name '_halt';

end.
