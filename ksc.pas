{$reference 'System.Data.dll'}
uses System.Data;

type
  
  KSCType = (
  _object,
  _action,
  _function,
  _int32,
  _int64,
  _single,
  _string
  );

  ///Базовый класс в иерархии типов
  KSCObject = class
    public &Type: KSCType;
    public Name: string;
    public Value: object;
    
    public constructor(name: string);
    begin
      Self.Name:=name;
      &Type := _object;
      &Value := nil;
    end;
    
    public function GetType(): KSCType;
    begin
      Result:=&Type;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=&Type.ToString;
    end;
  end;
  
  ///Действие, не возвращающее значений
  KSCAction = class(KSCObject)
    public &Type := KSCType._action;
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
    public &Type := KSCType._function;
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
  
  KSCInt32 = class(KSCObject)
    public Value: System.Int32 = 0;
    
    public constructor (name: string; a: System.Int32);
    begin
      &Type := KSCType._int32;
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  KSCInt64 = class(KSCObject)
    public Value: System.Int64 = 0;
    
    public constructor (name: string; a: System.Int64);
    begin
      &Type := KSCType._int64;
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value.ToString;
    end;
  end;
  
  KSCString = class(KSCObject)
    public Value: string = '';
    
    public constructor (name: string; a: string);
    begin
      &Type := KSCType._string;
      Self.Name:=name;
      Value:=a;
    end;
    
    public function ToString(): string; override;
    begin
      Result:=Value;
    end;
  end;
  
  KSCSingle = class(KSCObject)
    public Value: System.Single = 0;
    
    public constructor (name: string; a: System.Single);
    begin
      &Type := KSCType._single;
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
  Compilator = static class
    public static function GetParse(s: string): string;
    begin
      
    end;
    
    public static procedure AnalizeNames(s: string);
    begin
      var ss:=s.Remove(#13#10).Split(';');
      if ss<>nil then
      for var i:=0 to ss.Length-1 do
      begin
        if ss[i].Any(x -> x='=') and (ss[i].Any(x -> x=':')) and (not (ss[i].ToLower.Contains('var'))) then
        begin
          var sss:=ss[i].ToWords(':= '.ToArray);
          var id:=-1;
          for var k:=0 to Names.Count-1 do
          begin
            if sss[0].ToLower=Names[k].Name then id:=k;
          end;
          if id>=0 then
          begin
            case Names[id].Type of
              _object: raise new System.Exception;
              _int32:
              begin
                Names[id]:=new KSCInt32(sss[0],StrToInt(sss[1]));
              end;
              _int64:
              begin
                Names[id]:=new KSCInt64(sss[0],int64.Parse(sss[1]));
              end;
              _single:
              begin
                Names[id]:=new KSCSingle(sss[0],StrToFloat(sss[1]));
              end;
              _string:
              begin
                Names[id]:=new KSCString(sss[0],sss[1]);
              end;
            end;
          end;
        end;
        if ss[i].Left(3)='var' then
        begin
          var sss:=ss[i].ToWords(':= '.ToArray);
          sss[1]:=sss[1].ToLower;
          var a: KSCObject;
          var f:=false;
          for var k:=0 to ss[i].Length-1 do
          begin
            if Copy(ss[i],k,2)=':=' then f:=true;
          end;
          if not f then
          begin
            case sss[2].ToLower of
              'object','':
              begin
                Names.Add(new KSCObject(sss[1]));
              end;
              'int32':
              begin
                if sss.Length>3 then
                Names.Add(new KSCInt32(sss[1],StrToInt(sss[3])))
                else Names.Add(new KSCInt32(sss[1],0));
              end;
              'int64':
              begin
                if sss.Length>3 then
                Names.Add(new KSCInt64(sss[1],StrToInt(sss[3])))
                else Names.Add(new KSCInt64(sss[1],0));
              end;
              'string':
              begin
                if sss.Length>3 then
                Names.Add(new KSCString(sss[1],ss[i].ToWords('=')[1]))
                else Names.Add(new KSCString(sss[1],''));
              end;
              'single':
              begin
                if sss.Length>3 then
                Names.Add(new KSCSingle(sss[1],StrToFloat(ss[i].ToWords('=')[1])))
                else Names.Add(new KSCSingle(sss[1],0));
              end;
            end;
          end
          else
          begin
            var tp: KSCType;
            var _s1: int64;
            var _s2: System.Int32;
            var _s3: System.Single;
            if System.Single.TryParse(sss[2],_s3) then tp:=_single
              else
              if System.Int32.TryParse(sss[2],_s2) then tp:=_int32
                else
                if System.Int64.TryParse(sss[2],_s1) then tp:=_int64
                  else tp:=_string;
            case tp of
              _object:
              begin
                Names.Add(new KSCObject(sss[1]));
              end;
              _int32:
              begin
                Names.Add(new KSCInt32(sss[1],_s2));
              end;
              _int64:
              begin
                Names.Add(new KSCInt64(sss[1],_s1));
              end;
              _string:
              begin
                Names.Add(new KSCString(sss[1],sss[2]));
              end;
              _single:
              begin
                Names.Add(new KSCSingle(sss[1],_s3));
              end;
            end;
          end;
        end
        else
        begin
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
              var id: integer;
              for var k:=0 to Names.Count-1 do
                if sss[1].ToLower.Contains(names[k].Name) then
                begin
                  sss[1]:=sss[1].ToLower.Replace(names[k].Name,names[k].ToString);
                  if not f then f:=true;
                  cnt+=1;
                  id:=k;
                end;
              if ((f) and (cnt>1)) or (sss[1].Any(x -> (x='+') or (x='-') or (x='*') or (x='/'))) then
              begin
                write((new DataTable()).Compute(sss[1],''));
              end
              else if (f) then
              begin
                write(Names[id].ToString);
              end
              else write(sss[1].Replace('/n',NewLine));
            end;
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