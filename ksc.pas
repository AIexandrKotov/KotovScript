{$reference 'System.Data.dll'}
uses System.Data;

type
  ///Базовый класс в иерархии типов
  KSCObject = class
    public Name: string;
    
    public constructor(name: string);
    begin
      Self.Name:=name;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Self.GetType.ToString;
    end;
  end;
  
  ///Действие, не возвращающее значений
  KSCAction = class(KSCObject)
    public Args: array of KSCObject;
    public Value: procedure;
    
    public function GetArgs: array of KSCObject;
    begin
      Result:=Args;
    end;
    
    public function GetName: string;
    begin
      Result:=Name;
    end;
    
    public procedure DoIt;
    begin
      Value;
    end;
  end;
  
  ///Действие, возвращающее значение
  KSCFunction = class(KSCObject)
    public Args: array of KSCObject;
    public Value: function: KSCObject;
    public Rslt: KSCObject;
    
    public function GetArgs: array of KSCObject;
    begin
      Result:=Args;
    end;
    
    public function GetName: string;
    begin
      Result:=Name;
    end;
    
    public procedure DoIt;
    begin
      Rslt:=Value;
    end;
  end;
  
  ///Представляет 8-битовое целое число со знаком
  KSCSByte = class(KSCObject)
    public Value: System.SByte = 0;
    
    public constructor (name: string; a: System.SByte);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  ///Представляет 16-битовое целое число со знаком
  KSCInt16 = class(KSCObject)
    public Value: System.Int16 = 0;
    
    public constructor (name: string; a: System.Int16);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  ///Представляет 32-битовое целое число со знаком
  KSCInt32 = class(KSCObject)
    public Value: System.Int32 = 0;
    
    public constructor (name: string; a: System.Int32);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  ///Представляет 64-битовое целое число со знаком
  KSCInt64 = class(KSCObject)
    public Value: System.Int64 = 0;
    
    public constructor (name: string; a: System.Int64);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  ///Представляет 8-битовое целое число без знака
  KSCByte = class(KSCObject)
    public Value: System.Byte = 0;
    
    public constructor (name: string; a: System.Byte);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  ///Представляет 16-битовое целое число без знака
  KSCUInt16 = class(KSCObject)
    public Value: System.UInt16 = 0;
    
    public constructor (name: string; a: System.UInt16);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  ///Представляет 32-битовое целое число без знака
  KSCUInt32 = class(KSCObject)
    public Value: System.UInt32 = 0;
    
    public constructor (name: string; a: System.UInt32);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  ///Представляет 64-битовое целое число без знака
  KSCUInt64 = class(KSCObject)
    public Value: System.UInt64 = 0;
    
    public constructor (name: string; a: System.UInt64);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  ///Представляет строку
  KSCString = class(KSCObject)
    public Value: string = '';
    
    public constructor (name: string; a: string);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value;
    end;
  end;
  
  ///Представляет вещественное число одинарной точности
  KSCSingle = class(KSCObject)
    public Value: System.Single = 0;
    
    public constructor (name: string; a: System.Single);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  ///Представляет вещественное число двойной точности
  KSCDouble = class(KSCObject)
    public Value: System.Double = 0;
    
    public constructor (name: string; a: System.Double);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
var
  Names:=new List<KSCObject>;
  Tree:=new List<KSCObject>;
  
type
  NameNotFoundException = class(System.Exception) end;
  NameAlreadyExistsException = class(System.Exception) end;
  DeclareObjectException = class(System.Exception) end;

  Compilator = static class
    public static function GetString(s: string): string;
    begin
      var a, b: integer;
      a:=s.IndexOf('''');
      b:=s.LastIndexOf('''');
      Result:=Copy(s,a+2,b-a-1).Replace('''''','''').Replace('\n',NewLine);
    end;
    
    public static procedure AssignVariable(s: string);
    begin
      var sss:=s.ToWords(':= '.ToArray);
      var id:=-1;
      for var k:=0 to Names.Count-1 do
      begin
        if sss[0].ToLower=Names[k].Name then id:=k;
      end;
      if id>=0 then
      begin
        match Names[id] with
          KSCObject(var o): raise new DeclareObjectException($'Нельзя присвоить объекту');
          KSCSByte(var o): Names[id]:=new KSCSByte(sss[0],System.SByte.Parse(sss[1]));
          KSCInt16(var o): Names[id]:=new KSCInt16(sss[0],System.Int16.Parse(sss[1]));
          KSCInt32(var o): Names[id]:=new KSCInt32(sss[0],System.Int32.Parse(sss[1]));
          KSCInt64(var o): Names[id]:=new KSCInt64(sss[0],System.Int64.Parse(sss[1]));
          KSCByte(var o): Names[id]:=new KSCByte(sss[0],System.Byte.Parse(sss[1]));
          KSCUInt16(var o): Names[id]:=new KSCUInt16(sss[0],System.UInt16.Parse(sss[1]));
          KSCUInt32(var o): Names[id]:=new KSCUInt32(sss[0],System.UInt32.Parse(sss[1]));
          KSCUInt64(var o): Names[id]:=new KSCUInt64(sss[0],System.UInt64.Parse(sss[1]));
          KSCSingle(var o): Names[id]:=new KSCSingle(sss[0],System.Single.Parse(sss[1]));
          KSCDouble(var o): Names[id]:=new KSCSingle(sss[0],System.Double.Parse(sss[1]));
          KSCString(var o): Names[id]:=new KSCString(sss[0],GetString(s));
        end;
      end else raise new NameNotFoundException($'Переменная {sss[0]} не объявлена');
    end;
    
    ///Возвращает true, если переменная с таким именем существует
    public static function IsDeclarate(s: string): boolean;
    begin
      foreach var x in Names do
      begin
        if x.Name=s.ToLower then Result:=true;
      end;
    end;
    
    public static procedure DeclareVariable(s: string);
    begin
      var sss:=s.ToWords(':= '.ToArray);
      if IsDeclarate(sss[1]) then
      begin
        Names.RemoveAt(Names.FindIndex(x -> x.Name=sss[1].ToLower));
      end;
      sss[1]:=sss[1].ToLower;
      
      var a: KSCObject;
      var f:=false;
      for var k:=0 to s.Length-1 do
      begin
        if Copy(s,k,2)=':=' then f:=true;
      end;
      if not f then
      begin
        case sss[2].ToLower of
          'object','': Names.Add(new KSCObject(sss[1]));
          'byte': if sss.Length>3 then Names.Add(new KSCByte(sss[1],System.Byte.Parse(sss[3]))) else Names.Add(new KSCByte(sss[1],0));
          'uint16': if sss.Length>3 then Names.Add(new KSCUInt16(sss[1],System.UInt16.Parse(sss[3]))) else Names.Add(new KSCUInt16(sss[1],0));
          'uint32': if sss.Length>3 then Names.Add(new KSCUInt32(sss[1],System.UInt32.Parse(sss[3]))) else Names.Add(new KSCUInt32(sss[1],0));
          'uint64': if sss.Length>3 then Names.Add(new KSCUInt64(sss[1],System.UInt64.Parse(sss[3]))) else Names.Add(new KSCUInt64(sss[1],0));
          'sbyte': if sss.Length>3 then Names.Add(new KSCSByte(sss[1],System.SByte.Parse(sss[3]))) else Names.Add(new KSCSByte(sss[1],0));
          'int16': if sss.Length>3 then Names.Add(new KSCInt16(sss[1],System.Int16.Parse(sss[3]))) else Names.Add(new KSCInt16(sss[1],0));
          'int32': if sss.Length>3 then Names.Add(new KSCInt32(sss[1],System.Int32.Parse(sss[3]))) else Names.Add(new KSCInt32(sss[1],0));
          'int64': if sss.Length>3 then Names.Add(new KSCInt64(sss[1],System.Int64.Parse(sss[3]))) else Names.Add(new KSCInt64(sss[1],0));
          'single': if sss.Length>3 then Names.Add(new KSCSingle(sss[1],System.Single.Parse(s.ToWords('=')[1]))) else Names.Add(new KSCSingle(sss[1],0));
          'double': if sss.Length>3 then Names.Add(new KSCDouble(sss[1],System.Double.Parse(s.ToWords('=')[1]))) else Names.Add(new KSCDouble(sss[1],0));
          'string': if sss.Length>3 then Names.Add(new KSCString(sss[1],GetString(s))) else Names.Add(new KSCString(sss[1],''));
        end;
      end
      else
      begin
        {
          Модуль автоопределения типа, основанный на возможности пропарсировать строку
        }
        var tp: System.Type;
        var _s100: System.UInt64;
        var _s105: System.Int64;
        var _s110: System.UInt32;
        var _s115: System.Int32;
        var _s120: System.UInt16;
        var _s125: System.Int16;
        var _s130: System.Byte;
        var _s135: System.SByte;
        var _s140: System.Double;
        var _s145: System.Single;
        
        if System.Single.TryParse(sss[2],_s145) then tp:=typeof(KSCSingle)
          else if System.Double.TryParse(sss[2],_s140) then tp:=typeof(KSCDouble)
            else if System.SByte.TryParse(sss[2],_s135) then tp:=typeof(KSCSByte)
              else if System.Byte.TryParse(sss[2],_s130) then tp:=typeof(KSCByte)
                else if System.Int16.TryParse(sss[2],_s125) then tp:=typeof(KSCInt16)
                  else if System.UInt16.TryParse(sss[2],_s120) then tp:=typeof(KSCUInt16)
                    else if System.Int32.TryParse(sss[2],_s115) then tp:=typeof(KSCInt32)
                      else if System.UInt32.TryParse(sss[2],_s110) then tp:=typeof(KSCUInt32)
                        else if System.Int64.TryParse(sss[2],_s105) then tp:=typeof(KSCInt64)
                          else if System.UInt64.TryParse(sss[2],_s100) then tp:=typeof(KSCUInt64)
                            else tp:=typeof(KSCString);
        if tp=typeof(KSCObject) then Names.Add(new KSCObject(sss[1]));
        if tp=typeof(KSCSByte) then Names.Add(new KSCSByte(sss[1],_s135));
        if tp=typeof(KSCInt16) then Names.Add(new KSCInt16(sss[1],_s125));
        if tp=typeof(KSCInt32) then Names.Add(new KSCInt32(sss[1],_s115));
        if tp=typeof(KSCInt64) then Names.Add(new KSCInt64(sss[1],_s105));
        if tp=typeof(KSCByte) then Names.Add(new KSCByte(sss[1],_s130));
        if tp=typeof(KSCUInt16) then Names.Add(new KSCUInt16(sss[1],_s120));
        if tp=typeof(KSCUInt32) then Names.Add(new KSCUInt32(sss[1],_s110));
        if tp=typeof(KSCUInt64) then Names.Add(new KSCUInt64(sss[1],_s100));
        if tp=typeof(KSCSingle) then Names.Add(new KSCString(sss[1],GetString(s)));
        if tp=typeof(KSCDouble) then Names.Add(new KSCSingle(sss[1],_s145));
        if tp=typeof(KSCString) then Names.Add(new KSCDouble(sss[1],_s140));
      end;
    end;
    
    public static procedure AnalizeNames(s: string);
    begin
      var ss:=s.Remove(#13#10).Split(';');
      if ss<>nil then
      for var i:=0 to ss.Length-1 do
      begin
        if ss[i].Left(3)='var' then DeclareVariable(ss[i]);
        if ss[i].Any(x -> x='=') and (ss[i].Any(x -> x=':')) and (not (ss[i].ToLower.Contains('var'))) then AssignVariable(ss[i]);
        
        if ss[i].ToLower.Left(5)='write' then
        begin
          if ss[i].ToLower.Remove(' ')='writeln' then
          begin
            writeln;
          end
          else
          begin
            var sss:=ss[i].ToWords('()'.ToArray);
            var f: boolean = false;
            var cnt: integer = 0;
            var strincludes: boolean = false;
            var id: integer;
            for var k:=0 to Names.Count-1 do
              if sss[1].ToLower.Contains(names[k].Name) then
              begin
                sss[1]:=sss[1].ToLower.Replace(names[k].Name,names[k].ToString);
                if not f then f:=true;
                cnt+=1;
                id:=k;
                if Names[k] is KSCString then strincludes:=true;
              end;
            if (((f) and (cnt>1)) or (sss[1].Any(x -> (x='+') or (x='-') or (x='*') or (x='/')))) and (not strincludes)  then
            begin
              write((new DataTable()).Compute(sss[1],''));
            end
            else if (f) then
            begin
              write(Names[id].ToString);
            end
            else write(GetString(sss[1]));
          end;
        end;
      end;
    end;
  end;
  
begin
  var Text:=ReadAllText('Program1.ksc',encoding.UTF8);
  Compilator.AnalizeNames(Text);
  
  writeln;
  System.Console.ReadKey;
end.