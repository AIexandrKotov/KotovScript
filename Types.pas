unit Types;

uses System, OperatorNew, LightParser, Exceptions;

const
  ReservedNames: array of string = (
    'KSCObject',
    'object',
    'KSCInt32',
    'int32'
  );
  
  LocalName = '<>LocalVariable';

function IsType(s: string) := ReservedNames.Contains(s);

type
  BadFormatException = class(KSCException) end;

  ///Является предком всех KSC-типов, это исходный базовый класс
  KSCObject = abstract class(object)
    const TypeName = 'object';
    const FullTypeName = 'kcsobject';
    
    private _name: string;
    
    public procedure Rename(newname: string);
    begin
      _name:=newname;
    end;
    
    ///Имя объекта
    public property Name: string read _name write Rename;
    
    ///Преобразует объект в строку
    public function ToString: string; override := Self.GetType.ToString;
  end;
  
  KSCAutoType = sealed class(KSCObject)
  end;
  
  {$region Целые числовые типы}
  KSCInt32 = class(KSCObject)
    const TypeName = 'int32';
    const FullTypeName = 'kscint32';
    
    private _value: Int32;
    
    public procedure SetValue(a: integer) := _value := a;
    
    public property Value: Int32 read _value write SetValue;
    
    public function ToString: string; override := Self._value.ToString;
    
    public constructor (name: string; value: integer);
    begin
      _name:=name;
      _value:=value;
    end;
    
    public constructor (name: string; a: KSCInt32);
    begin
      _name:=name;
      _value:=a._value;
    end;
    
    public static function ParseConstructor(s: string): KSCInt32;
    begin
      Result:=new KSCInt32(LocalName,Int32.Parse(s));
    end;
    
    ///Преобразует строку в объект
    public static function Parse(s: string): KSCInt32;
    begin
      try
        if OperatorNew.Contains(s) then Result:=ParseConstructor(s.GetBetweenString('(',')')) else Result:=new KSCInt32(LocalName,Int32.Parse(s));
      except
        on e: KSCException do raise new BadFormatException('Не удалось преобразовать строку к Int32');
      end;
    end;
    
    ///Преобразует строковое представление в объект и возвращает true, если преобразование было выполнено успешно
    public static function TryParse(s: string; var rslt: KSCInt32): boolean;
    begin
      try
        Rslt:=Parse(s);
        Result:=true;
      except
        on e: BadFormatException do Result:=false;
      end;
    end;
    
  end;
  {$endregion}
  
function ParseType(s: string): System.Type;
begin
  case s of
    KSCObject.TypeName, KSCObject.FullTypeName: Result:=typeof(KSCObject);
    KSCInt32.TypeName, KSCInt32.FullTypeName: Result:=typeof(KSCInt32);
  end;
end;

function TypeToString(a: System.Type): string;
begin
  if a = typeof(KSCObject) then Result:=KSCObject.FullTypeName;
  if a = typeof(KSCInt32) then Result:=KSCInt32.FullTypeName;
end;

function DeclareAndAssign(name: string; &Type: System.Type; parse: string): KSCObject;
begin
  if &Type = typeof(KSCAutoType) then
  begin
    
  end
  else
  begin
    if &Type = typeof(KSCInt32) then Result:=new KSCInt32(name,KSCInt32.Parse(parse));
  end;
end;

begin
  
end.