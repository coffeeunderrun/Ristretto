unit SysUtils;

{$mode objfpc}{$H-}

interface

Var TrueBoolStrs, FalseBoolStrs : Array of String;

function IntToStr(Value: LongInt): String; inline;
function IntToStr(Value: Int64): String; inline;
function IntToStr(Value: QWord): String; inline;
function UIntToStr(Value: QWord): String; inline;
function UIntToStr(Value: Cardinal): String; inline;

function IntToHex(Value: Longint; Digits: integer): string;
function IntToHex(Value: Int64; Digits: integer): string;
function IntToHex(Value: QWord; Digits: integer): string; inline;
function IntToHex(Value: Int8): string; inline;
function IntToHex(Value: UInt8): string; inline;
function IntToHex(Value: Int16): string; inline;
function IntToHex(Value: UInt16): string; inline;
function IntToHex(Value: Int32): string; inline;
function IntToHex(Value: UInt32): string; inline;
function IntToHex(Value: Int64): string; inline;
function IntToHex(Value: UInt64): string; inline;

function TryStrToInt(const s: string; Out i : Longint): boolean;
function TryStrToDWord(const s: string; Out D : DWord): boolean;
function TryStrToUInt(const s: string; out C: Cardinal): Boolean;
function TryStrToInt64(const s: string; Out i : int64): boolean;
function TryStrToQWord(const s: string; Out Q : QWord): boolean;
function TryStrToUInt64(const s: string; Out u : UInt64): boolean; inline;
function StrToIntDef(const S: string; Default: Longint): Longint;
function StrToDWordDef(const S: string; Default: DWord): DWord;
function StrToUIntDef(const S: string; Default: Cardinal): Cardinal;
function StrToInt64Def(const S: string; Default: int64): int64;
function StrToQWordDef(const S: string; Default: QWord): QWord;
function StrToUInt64Def(const S: string; Default: UInt64): UInt64; inline;

function BoolToStr(B: Boolean;UseBoolStrs:Boolean=False): string;
function BoolToStr(B: Boolean;const TrueS,FalseS:string): string; inline;
function StrToBoolDef(const S: string; Default: Boolean): Boolean;
function TryStrToBool(const S: string; out Value: Boolean): Boolean;

function Format(const Fmt: String; const Args: array of const): String;

implementation

uses HeapMgr, SysConst;

function IntToStr(Value: LongInt): String;
begin
  Str(Value, result);
end;

function IntToStr(Value: Int64): String;
begin
  Str(Value, result);
end;

function IntToStr(Value: QWord): String;
begin
  Str(Value, result);
end;

function UIntToStr(Value: QWord): String;
begin
  Str(Value, result);
end;

function UIntToStr(Value: Cardinal): String;
begin
  Str(Value, result);
end;

function IntToHex(Value: Longint; Digits: integer): string;
var i: integer;
begin
 If Digits=0 then
   Digits:=1;
 SetLength(result, digits);
 for i := 0 to digits - 1 do
  begin
   result[digits - i] := HexDigits[value and 15];
   value := value shr 4;
  end ;
 while value <> 0 do begin
   result := HexDigits[value and 15] + result;
   value := value shr 4;
 end;
end ;

function IntToHex(Value: int64; Digits: integer): string;
var i: integer;
begin
 If Digits=0 then
   Digits:=1;
 SetLength(result, digits);
 for i := 0 to digits - 1 do
  begin
   result[digits - i] := HexDigits[value and 15];
   value := value shr 4;
  end ;
 while value <> 0 do begin
   result := HexDigits[value and 15] + result;
   value := value shr 4;
 end;
end ;

function IntToHex(Value: QWord; Digits: integer): string;
begin
  result:=IntToHex(Int64(Value),Digits);
end;

function IntToHex(Value: Int8): string;
begin
  result:=IntToHex(LongInt(Value) and $ff, 2*SizeOf(Int8));
end;

function IntToHex(Value: UInt8): string;
begin
  result:=IntToHex(Value, 2*SizeOf(UInt8));
end;

function IntToHex(Value: Int16): string;
begin
  result:=IntToHex(LongInt(Value) and $ffff, 2*SizeOf(Int16));
end;

function IntToHex(Value: UInt16): string;
begin
  result:=IntToHex(Value, 2*SizeOf(UInt16));
end;

function IntToHex(Value: Int32): string;
begin
  result:=IntToHex(Value, 2*SizeOf(Int32));
end;

function IntToHex(Value: UInt32): string;
begin
  result:=IntToHex(LongInt(Value), 2*SizeOf(UInt32));
end;

function IntToHex(Value: Int64): string;
begin
  result:=IntToHex(Value, 2*SizeOf(Int64));
end;

function IntToHex(Value: UInt64): string;
begin
  result:=IntToHex(Value, 2*SizeOf(UInt64));
end;

function TryStrToInt(const s: string; out i : Longint) : boolean;
var
  Error : word;
begin
  Val(s, i, Error);
  TryStrToInt:=(Error=0)
end;

function TryStrToInt64(const s: string; Out i : int64) : boolean;
var Error : word;
begin
  Val(s, i, Error);
  TryStrToInt64:=Error=0
end;

function TryStrToDWord(const s: string; Out D: DWord): boolean;
var
  Error : word;
  lq : QWord;
begin
  Val(s, lq, Error);
  TryStrToDWord:=(Error=0) and (lq<=High(DWord));
  if TryStrToDWord then
    D:=lq;
end;

function TryStrToUInt(const s: string; out C: Cardinal): Boolean;
begin
  TryStrToUInt:=TryStrToDWord(s, C);
end;

function TryStrToQWord(const s: string; Out Q: QWord): boolean;
var Error : word;
begin
  Val(s, Q, Error);
  TryStrToQWord:=Error=0
end;

function TryStrToUInt64(const s: string; Out u: UInt64): boolean;
begin
  result:=TryStrToQWord(s,u);
end;

{   StrToIntDef converts the string S to an integer value,
    Default is returned in case S does not represent a valid integer value  }
function StrToIntDef(const S: string; Default: Longint): Longint;
begin
  if not(TryStrToInt(s,Result)) then
    result := Default;
end;

{   StrToDWordDef converts the string S to an DWord value,
    Default is returned in case S does not represent a valid DWord value  }
function StrToDWordDef(const S: string; Default: DWord): DWord;
begin
  if not(TryStrToDWord(s,Result)) then
    result := Default;
end;

function StrToUIntDef(const S: string; Default: Cardinal): Cardinal;
begin
  Result:=StrToDWordDef(S, Default);
end;

{   StrToInt64Def converts the string S to an int64 value,
    Default is returned in case S does not represent a valid int64 value  }
function StrToInt64Def(const S: string; Default: int64): int64;
begin
  if not(TryStrToInt64(s,Result)) then
    result := Default;
end;

{   StrToQWordDef converts the string S to an QWord value,
    Default is returned in case S does not represent a valid QWord value  }
function StrToQWordDef(const S: string; Default: QWord): QWord;
begin
  if not(TryStrToQWord(s,Result)) then
    result := Default;
end;

function StrToUInt64Def(const S: string; Default: UInt64): UInt64;
begin
  result:=StrToQWordDef(S,Default);
end;

procedure CheckBoolStrs;
begin
    If Length(TrueBoolStrs)=0 then
      begin
        SetLength(TrueBoolStrs,1);
        TrueBoolStrs[0]:='True';
      end;
    If Length(FalseBoolStrs)=0 then
      begin
        SetLength(FalseBoolStrs,1);
        FalseBoolStrs[0]:='False';
      end;
end;

function BoolToStr(B: Boolean;UseBoolStrs:Boolean=False): string;
begin
 if UseBoolStrs Then
  begin
    CheckBoolStrs;
    if B then
      Result:=TrueBoolStrs[0]
    else
      Result:=FalseBoolStrs[0];
  end
 else
  If B then
    Result:='-1'
  else
    Result:='0';
end;

function BoolToStr(B: boolean; const TrueS, FalseS: string): string;
begin
  if B then Result:=TrueS else BoolToStr:=FalseS;
end;

function StrToBoolDef(const S: string; Default: Boolean): Boolean;
begin
  if not(TryStrToBool(S,Result)) then Result:=Default;
end;

function TryStrToBool(const S: string; out Value: Boolean): Boolean;
Var
  Temp : String;
  I    : Longint;
  D : Longint;
  Code: word;
begin
  Temp:=upcase(S);
  Val(temp,D,code);
  Result:=true;
  If (Code=0) then
    Value:=(D<>0)
  else
    begin
      CheckBoolStrs;
      for I:=low(TrueBoolStrs) to High(TrueBoolStrs) do
        if Temp=upcase(TrueBoolStrs[I]) then
          begin
            Value:=true;
            exit;
          end;
      for I:=low(FalseBoolStrs) to High(FalseBoolStrs) do
        if Temp=upcase(FalseBoolStrs[I]) then
          begin
            Value:=false;
            exit;
          end;
      Result:=false;
    end;
end;

Const
  feInvalidFormat   = 1;
  feMissingArgument = 2;
  feInvalidArgIndex = 3;

Procedure DoFormatError (ErrCode : Longint;const fmt:String);
Var
  S : String;
begin
  S:=fmt;
  Case ErrCode of
   feInvalidFormat : ;
   feMissingArgument : ;
   feInvalidArgIndex : ;
 end;
end;

function Format(const Fmt: String; const Args: array of const): String;
var
  ChPos,OldPos,ArgPos,DoArg,Len : SizeInt;
  Hs,ToAdd : String;
  Index : SizeInt;
  Width,Prec : Longint;
  Left : Boolean;
  Fchar : Char;
  vq : qword;

  Function ReadFormat : Char;
  Var
    Value : longint;

    Procedure ReadInteger;
    var
      Code: Word;
      ArgN: SizeInt;
    begin
      If Value<>-1 then exit; // Was already read.
      OldPos:=ChPos;
      While (ChPos<=Len) and
            (Fmt[ChPos]<='9') and (Fmt[ChPos]>='0') do inc(ChPos);
      If ChPos>len then
        DoFormatError(feInvalidFormat,Fmt);
      If Fmt[ChPos]='*' then
        begin

        if Index=-1 then
          ArgN:=Argpos
        else
        begin
          ArgN:=Index;
          Inc(Index);
        end;

        If (ChPos>OldPos) or (ArgN>High(Args)) then
          DoFormatError(feInvalidFormat,Fmt);

        ArgPos:=ArgN+1;

        case Args[ArgN].Vtype of
          vtInteger: Value := Args[ArgN].VInteger;
          vtInt64: Value := Args[ArgN].VInt64^;
          vtQWord: Value := Args[ArgN].VQWord^;
        else
          DoFormatError(feInvalidFormat,Fmt);
        end;
        Inc(ChPos);
        end
      else
        begin
        If (OldPos<ChPos) Then
          begin
          Val (Copy(Fmt,OldPos,ChPos-OldPos),value,code);
          // This should never happen !!
          If Code>0 then DoFormatError (feInvalidFormat,Fmt);
          end
        else
          Value:=-1;
        end;
    end;

    Procedure ReadIndex;
    begin
      If Fmt[ChPos]<>':' then
        ReadInteger
      else
        value:=0; // Delphi undocumented behaviour, assume 0, #11099
      If Fmt[ChPos]=':' then
        begin
        If Value=-1 then DoFormatError(feMissingArgument,Fmt);
        Index:=Value;
        Value:=-1;
        Inc(ChPos);
        end;
    end;

    Procedure ReadLeft;
    begin
      If Fmt[ChPos]='-' then
        begin
        left:=True;
        Inc(ChPos);
        end
      else
        Left:=False;
    end;

    Procedure ReadWidth;
    begin
      ReadInteger;
      If Value<>-1 then
        begin
        Width:=Value;
        Value:=-1;
        end;
    end;

    Procedure ReadPrec;
    begin
      If Fmt[ChPos]='.' then
        begin
        inc(ChPos);
          ReadInteger;
        If Value=-1 then
         Value:=0;
        prec:=Value;
        end;
    end;

  begin
    Index:=-1;
    Width:=-1;
    Prec:=-1;
    Value:=-1;
    inc(ChPos);
    If Fmt[ChPos]='%' then
      begin
        Result:='%';
        exit;                           // VP fix
      end;
    ReadIndex;
    ReadLeft;
    ReadWidth;
    ReadPrec;
    ReadFormat:=Upcase(Fmt[ChPos]);
end;

function Checkarg (AT : SizeInt;err:boolean):boolean;
begin
  result:=false;
  if Index=-1 then
    DoArg:=Argpos
  else
    DoArg:=Index;
  ArgPos:=DoArg+1;
  If (Doarg>High(Args)) or (Args[Doarg].Vtype<>AT) then
   begin
     if err then
      DoFormatError(feInvalidArgindex,Fmt);
     dec(ArgPos);
     exit;
   end;
  result:=true;
end;

Function StringOfChar(c : Char;l : SizeInt) : String;
begin
  SetLength(StringOfChar,l);
  FillChar(StringOfChar[1],Length(StringOfChar),c);
end;

begin
  Result:='';
  Len:=Length(Fmt);
  ChPos:=1;
  OldPos:=1;
  ArgPos:=0;
  While ChPos<=len do
    begin
    While (ChPos<=Len) and (Fmt[ChPos]<>'%') do
      inc(ChPos);
    If ChPos>OldPos Then
      Result:=Result+Copy(Fmt,OldPos,ChPos-Oldpos);
    If ChPos<Len then
      begin
      FChar:=ReadFormat;
      Case FChar of
        'B' : begin
              if Checkarg(vtInteger,False) then
                ToAdd:=BoolToStr((Args[Doarg].VInteger<>0),True)
              else if Checkarg(vtInt64,False) then
                ToAdd:=BoolToStr((Args[Doarg].VInt64^<>0),True)
              else if Checkarg(vtBoolean,True) then
                ToAdd:=BoolToStr(Args[Doarg].VBoolean,True);
              Index:=Length(ToAdd);
              // Top off
              If (Prec<>-1) and (Index>Prec) then
                begin
                Index:=Prec;
                SetLength(ToAdd,Index);
                end;
              end;
        'D' : begin
              if Checkarg(vtinteger,false) then
                Str(Args[Doarg].VInteger,ToAdd)
              else if CheckArg(vtInt64,false) then
                Str(Args[DoArg].VInt64^,toadd)
              else if CheckArg(vtQWord,true) then
                Str(int64(Args[DoArg].VQWord^),toadd);
              Width:=Abs(width);
              Index:=Prec-Length(ToAdd);
              If ToAdd[1]<>'-' then
                ToAdd:=String(StringOfChar('0',Index))+ToAdd
              else
                // + 1 to accommodate for - sign in length !!
                Insert(String(StringOfChar('0',Index+1)),toadd,2);
              end;
        'U' : begin
              if Checkarg(vtinteger,false) then
                Str(cardinal(Args[Doarg].VInteger),ToAdd)
              else if CheckArg(vtInt64,false) then
                Str(qword(Args[DoArg].VInt64^),toadd)
              else if CheckArg(vtQWord,true) then
                Str(Args[DoArg].VQWord^,toadd);
              Width:=Abs(width);
              Index:=Prec-Length(ToAdd);
              ToAdd:=String(StringOfChar('0',Index))+ToAdd
              end;
        'S' : begin
                if CheckArg(vtString,false) then
                  hs:=String(Args[doarg].VString^)
                else
                  if CheckArg(vtChar,false) then
                    hs:=String(Args[doarg].VChar)
                else
                  if CheckArg(vtPChar,false) then
                    hs:=String(Args[doarg].VPChar)
                else
                  if CheckArg(vtAnsiString,false) then
                    hs:=String(PChar(Args[doarg].VAnsiString));
                Index:=Length(hs);
                If (Prec<>-1) and (Index>Prec) then
                  SetLength(hs,Prec);
                ToAdd:=hs;
              end;
        'O' :
              begin
              if CheckArg(vtClass,false) then
                begin
                if (Args[DoArg].VClass=Nil) then
                  ToAdd:='<Nil>'
                else
                  ToAdd:=String(Args[DoArg].VClass.ClassName);
                end
              else
                begin
                CheckArg(vtObject,True);
                if (Args[DoArg].VObject=Nil) then
                  ToAdd:='<Nil>'
                else
                  ToAdd:=String(Args[DoArg].VObject.ToString);
                end
              end;
        'P' : begin
              if CheckArg(vtObject,false) then
                ToAdd:=String(HexStr(ptruint(Args[DoArg].VObject),sizeof(Ptruint)*2))
              else if CheckArg(vtClass,false) then
                ToAdd:=String(HexStr(ptruint(Args[DoArg].VClass),sizeof(Ptruint)*2))
              else
                begin
                CheckArg(vtpointer,true);
                ToAdd:=String(HexStr(ptruint(Args[DoArg].VPointer),sizeof(Ptruint)*2));
                end;
              // Insert ':'. Is this needed in 32 bit ? No it isn't.
              // Insert(':',ToAdd,5);
              end;
        'X' : begin
              if Checkarg(vtinteger,false) then
                 begin
                   vq:=Cardinal(Args[Doarg].VInteger);
                   index:=16;
                 end
              else
                 if CheckArg(vtQWord, false) then
                   begin
                     vq:=Qword(Args[DoArg].VQWord^);
                     index:=31;
                   end
              else
                 begin
                   CheckArg(vtInt64,true);
                   vq:=Qword(Args[DoArg].VInt64^);
                   index:=31;
                 end;
              If Prec>index then
                ToAdd:=String(HexStr(int64(vq),index))
              else
                begin
                // determine minimum needed number of hex digits.
                Index:=1;
                While (qWord(1) shl (Index*4)<=vq) and (index<16) do
                  inc(Index);
                If Index>Prec then
                  Prec:=Index;
                ToAdd:=String(HexStr(int64(vq),Prec));
                end;
              end;
        '%': ToAdd:='%';
      end;
      // Padding ?
      If (Width=-1) or (Length(ToAdd)>=Width) then
        // No width specified or the string to add has required width or greater
        Result:=Result+ToAdd
      else
        begin
        // String to add is less than requested width. Calc padding string
        hs:=String(space(Width-Length(ToAdd)));
        if Left then
          // Add left aligned
          Result:=Result+ToAdd+hs
        else
          // Add right aligned
          Result:=Result+hs+ToAdd;
        end;
      end;
    inc(ChPos);
    Oldpos:=ChPos;
    end;
end;

end.
