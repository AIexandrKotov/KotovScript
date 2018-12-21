unit Types;

uses System;

type
  ///Ключевой объект
  KSCObject = abstract class
    public const TypeName = 'object';
    
    private _name: string;
    
    public function GetName: string := _name;
    
    public property Name: string read GetName;
    
    public constructor (name: string);
    begin
      _name:=name;
    end;
    
    public function ToString: string; override := Self.GetType().ToString;
    
    public procedure SetValue(s: object) := exit;
  end;
  
  KSCInt32 = class(KSCObject)
    public const TypeName = 'int32';
    
    private _value: Int32;
    
    public procedure SetValue(a: Int32) := _value := a;
    
    public procedure SetValue(a: KSCInt32) := _value := a._value;
    
    public property Value: Int32 read _value write SetValue;
    
    public constructor (name: string; a: Int32);
    begin
      _name:=name;
      _value:=a;
    end;
    
    public constructor (name: string; a: KSCInt32);
    begin
      _name:=name;
      _value := a._value;
    end;
    
    public function ToString: string; override := Value.ToString;
    
    public function Parse(s: string): KSCInt32;
    begin
      Result:=new KSCInt32('<>localvariablename',Int32.Parse(s));
    end;
    
    public constructor (name: string; s: string);
    begin
      Create(name, Parse(s));
    end;
    
    public procedure SetValue(s: string) := SetValue(Parse(s));
  end;

function IsTypeName(s: string): boolean;
var
  tns: array of string =(
    KSCInt32.TypeName,
    KSCObject.TypeName
  );
begin
  Result:=false;
  for var i:=0 to tns.Length-1 do
    if s.ToLower = tns[i] then Result:=true;
end;

function StrToType(s: string): System.Type;
begin
  case s.ToLower of
    KSCInt32.TypeName: Result:=typeof(KSCInt32);
  end;
end;

function GetNullVariable(name: string; &Type: System.Type): KSCObject;
begin
  if &Type = typeof(KSCInt32) then Result:=new KSCInt32(name,0);
end;

function GetVariable(name, parse: string; &Type: System.Type): KSCObject;
begin
  if &Type = typeof(KSCInt32) then Result:=new KSCInt32(name,parse);
end;

function GetAutoVariable(name, parse: string): KSCObject;
begin
  var Auto001: Int32;
  if Int32.TryParse(parse,Auto001) then Result:=new KSCInt32(name,parse);
end;

begin

end.