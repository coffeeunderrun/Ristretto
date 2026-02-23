unit Interrupts;

interface

type
  TIsrHandler = procedure;

procedure Initialize;

procedure RegisterHandler(Vector: UInt8; Handler: TIsrHandler);

implementation

{$I interrupts.inc}

end.
