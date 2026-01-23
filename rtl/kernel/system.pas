unit System;

interface

{$I systemh.inc}

implementation

{$implicitexceptions off}

{$I system.inc}

procedure system_exit; noreturn; external name '_halt';

end.
