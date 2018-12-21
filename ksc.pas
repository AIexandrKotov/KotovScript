{$reference 'System.Data.dll'}
uses System.Data;

function Lambda1498_1(sss: array of string): boolean;
begin
  if sss.Any(x ->
    begin
      Result:=(x.Any(y -> y='[')) or (x.Any(y -> y=']'));
    end) then Result:=true;
  if sss[2].Any(x -> x='(') then Result:=true;
  if sss[2].Any(x -> x=')') then Result:=true;
end;

type  
  ///Базовый класс в иерархии типов
  KSCObject = abstract class
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
  
  ///Представляет массив объектов
  KSCArray = class(KSCObject)
    public Value: array of KSCObject;
    
    public constructor (name: string; a: array of KSCObject);
    begin
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      var sb:=new StringBuilder;
      sb+='(';
      for var i:=0 to Value.Length-1 do
      begin
        sb+=Value[i].ToString;
        if i<>Value.Length-1 then sb+=',';
      end;
      sb+=')';
      Result:=sb.ToString;
    end;
  end;
  
  ///Представляет логическое значение
  KSCBoolean = class(KSCObject)
    public Value: System.Boolean = false;
    
    public constructor (name: string; a: System.Boolean);
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
  DifferentArrayElementsException = class(System.Exception) end;

  Compilator = static class
    public static function CreateAndParse(a: KSCObject; name, parse: string): KSCObject;
    begin
      match a with
        //KSCObject(var o): raise new DeclareObjectException($'Нельзя присвоить объекту');
        KSCSByte(var o): Result:=new KSCSByte(name,System.SByte.Parse(parse));
        KSCInt16(var o): Result:=new KSCInt16(name,System.Int16.Parse(parse));
        KSCInt32(var o): Result:=new KSCInt32(name,System.Int32.Parse(parse));
        KSCInt64(var o): Result:=new KSCInt64(name,System.Int64.Parse(parse));
        KSCByte(var o): Result:=new KSCByte(name,System.Byte.Parse(parse));
        KSCUInt16(var o): Result:=new KSCUInt16(name,System.UInt16.Parse(parse));
        KSCUInt32(var o): Result:=new KSCUInt32(name,System.UInt32.Parse(parse));
        KSCUInt64(var o): Result:=new KSCUInt64(name,System.UInt64.Parse(parse));
        KSCSingle(var o): Result:=new KSCSingle(name,System.Single.Parse(parse));
        KSCDouble(var o): Result:=new KSCSingle(name,System.Double.Parse(parse));
        KSCBoolean(var o): Result:=new KSCBoolean(name,System.Boolean.Parse(parse));
        KSCString(var o): Result:=new KSCString(name,GetString(parse));
      end;
    end;
    
    public static function AutoTypeParser(s: string): System.Type;
    begin
      var _s100: System.Boolean;
      var _s115: System.Int32;
      var _s140: System.Double;
      
      if System.Double.TryParse(s,_s140) then Result:=typeof(KSCDouble)
        else if System.Int32.TryParse(s,_s115) then Result:=typeof(KSCInt32)
          else if System.Boolean.TryParse(s,_s100) then Result:=typeof(KSCBoolean)
            else Result:=typeof(KSCString);
    end;
    
    public static function GetArrayLength(s: string): integer;
    begin
      var a, b: integer;
      a:=s.IndexOf('[');
      b:=s.IndexOf(']');
      if (b-a)>1 then Result:=System.Int32.Parse(Copy(s,a+2,b-a-1)) else Result:=-1;
    end;
    
    public static function GetArray(s: string): array of string;
    begin
      var a, b: integer;
      a:=s.IndexOf('(');
      b:=s.LastIndexOf(')');
      Result:=Copy(s,a+2,b-a-1).Split(',');
    end;
    
    public static function GetString(s: string): string;
    begin
      var a, b: integer;
      a:=s.IndexOf('''');
      b:=s.LastIndexOf('''');
      Result:=Copy(s,a+2,b-a-1).Replace('''''','''').Replace('\n',NewLine);
    end;
    
    public static function GetStringArray(s: string): array of string;
    begin
      var a, b: integer;
      a:=s.IndexOf('(');
      b:=s.LastIndexOf(')');
      var sts:=Copy(s,a+2,b-a);
      var Internals: boolean;
      var Last:=1;
      var Lst:=new List<string>;
      for var i:=1 to sts.Length do
      begin
        if (not internals) and (sts[i]=',') then
        begin
          Lst.Add(Copy(sts,Last,i-Last)); 
          Last:=i+1;
        end;
          
        if sts[i]='''' then
        begin
          if Internals then Internals:=false else Internals:=true;
        end;
      end;
      Lst.Add(Copy(sts,Last,sts.Length-Last));
      Result:=Lst.ToArray.ConvertAll(x -> GetString(x));
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
        Names[id]:=CreateAndParse(Names[id],sss[0],sss[1]);
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
      
      var IsArr: boolean = Lambda1498_1(sss);
      
      {begin /// Issue #1498
        if sss.Any(x ->
          begin
            Result:=(x.Any(y -> y='[')) or (x.Any(y -> y=']'));
          end) then IsArr:=true;
        if sss[2].Any(x -> x='(') then IsArr:=true;
        if sss[2].Any(x -> x=')') then IsArr:=true;
      end;}
      
      //var a : int32 = 40;
      //var b : int32[10];
      //var b : int32[] = (40,40);
      //var b : int32[10] = (40,40);
      //var b := (40,40);
      
      if IsArr then
        if not f then
        begin
          var l:=GetArrayLength(s);
          var al:=GetArray(s);
          var tp:=AutoTypeParser(al[0]);
          foreach var x in al do if AutoTypeParser(x) <> tp then raise new DifferentArrayElementsException('Элементы массива должны быть одного типа');
          var k: array of KSCObject;
          if l=-1 then k:=new KSCObject[al.Length] else k:=new KSCObject[l];
          
          if sss[2].Left(5)='sbyte' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCSByte(i.ToString,System.SByte.Parse(al[i]))
                else k[i]:=new KSCSByte(i.ToString,0);
          end;
          if sss[2].Left(5)='int16' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCInt16(i.ToString,System.Int16.Parse(al[i]))
                else k[i]:=new KSCInt16(i.ToString,0);
          end;
          if sss[2].Left(5)='int32' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCInt32(i.ToString,System.Int32.Parse(al[i]))
                else k[i]:=new KSCInt32(i.ToString,0);
          end;
          if sss[2].Left(5)='int64' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCInt64(i.ToString,System.Int64.Parse(al[i]))
                else k[i]:=new KSCInt64(i.ToString,0);
          end;
          if sss[2].Left(4)='byte' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCByte(i.ToString,System.Byte.Parse(al[i]))
                else k[i]:=new KSCByte(i.ToString,0);
          end;
          if sss[2].Left(6)='uint16' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCUInt16(i.ToString,System.UInt16.Parse(al[i]))
                else k[i]:=new KSCUInt16(i.ToString,0);
          end;
          if sss[2].Left(6)='uint32' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCUInt32(i.ToString,System.UInt32.Parse(al[i]))
                else k[i]:=new KSCUInt32(i.ToString,0);
          end;
          if sss[2].Left(6)='uint64' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCUInt64(i.ToString,System.UInt64.Parse(al[i]))
                else k[i]:=new KSCUInt64(i.ToString,0);
          end;
          if sss[2].Left(6)='single' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCSingle(i.ToString,System.Single.Parse(al[i]))
                else k[i]:=new KSCSingle(i.ToString,0);
          end;
          if sss[2].Left(6)='double' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCDouble(i.ToString,System.Double.Parse(al[i]))
                else k[i]:=new KSCDouble(i.ToString,0);
          end;
          if sss[2].Left(6)='boolean' then 
          begin
            for var i:=0 to k.Length-1 do
              if i<=al.Length-1 then k[i]:=new KSCBoolean(i.ToString,System.Boolean.Parse(al[i]))
                else k[i]:=new KSCBoolean(i.ToString,false);
          end;
          if sss[2].Left(6)='string' then 
          begin
            var kk:=GetStringArray(s);
            l:=GetArrayLength(s);
            if l=-1 then k:=new KSCObject[kk.Length] else k:=new KSCObject[l];
            for var i:=0 to k.Length-1 do
              if i<=kk.Length-1 then k[i]:=new KSCString(i.ToString,kk[i])
              else k[i]:=new KSCString(i.ToString,'');
          end;
          
          Names.Add(new KSCArray(sss[1],k));
        end
        else
        begin
          var al:=GetArray(s.Split('=')[1]);
          var tp:=AutoTypeParser(al[0]);
          foreach var x in al do if AutoTypeParser(x) <> tp then raise new DifferentArrayElementsException('Элементы массива должны быть одного типа');
          
          if tp=typeof(KSCInt32) then
          begin
            var k:=new KSCObject[al.Length];
            for var i:=0 to k.Length-1 do
              k[i]:=new KSCInt32(i.ToString,System.Int32.Parse(al[i]));
            Names.Add(new KSCArray(sss[1],k));
          end;
          if tp=typeof(KSCDouble) then
          begin
            var k:=new KSCObject[al.Length];
            for var i:=0 to k.Length-1 do
              k[i]:=new KSCDouble(i.ToString,System.Double.Parse(al[i]));
            Names.Add(new KSCArray(sss[1],k));
          end;
          if tp=typeof(KSCString) then
          begin
            var kk:=GetStringArray(s);
            var k:=new KSCObject[kk.Length];
            for var i:=0 to k.Length-1 do
              k[i]:=new KSCString(i.ToString,kk[i]);
            Names.Add(new KSCArray(sss[1],k));
          end;
        end
      else
        if not f then
        begin
          case sss[2].ToLower of
            //'object','': Names.Add(new KSCObject(sss[1]));
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
            'boolean': if sss.Length>3 then Names.Add(new KSCBoolean(sss[1],System.Boolean.Parse(s.ToWords('=')[1]))) else Names.Add(new KSCBoolean(sss[1],false));
            'string': if sss.Length>3 then Names.Add(new KSCString(sss[1],GetString(s))) else Names.Add(new KSCString(sss[1],''));
          end;
        end
        else
        begin
          {
            Модуль автоопределения типа, основанный на возможности пропарсировать строку
          }
          var tp := AutoTypeParser(sss[2]);
          //if tp=typeof(KSCObject) then Names.Add(new KSCObject(sss[1]));
          if tp=typeof(KSCInt32) then Names.Add(new KSCInt32(sss[1],System.Int32.Parse(sss[2])));
          if tp=typeof(KSCDouble) then Names.Add(new KSCDouble(sss[1],System.Double.Parse(sss[2])));
          if tp=typeof(KSCBoolean) then Names.Add(new KSCBoolean(sss[1],System.Boolean.Parse(sss[2])));
          if tp=typeof(KSCString) then Names.Add(new KSCString(sss[1],sss[2]));
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