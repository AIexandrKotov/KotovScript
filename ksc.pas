uses KSCParser, Types, KTX;

const
  ModuleName = 'KSC Kotov Scrypt';
  Version: record Major, Minor, Build: integer; end = (Major: 1; Minor: 0; Build: 3);
  function StrVersion := $'{Version.Major}.{Version.Minor}.{Version.Build}';
  function StrFull := $'{ModuleName} {StrVersion}';

type
  SequenceType<T> = sequence of T;

  Compiler = static class
    public static Names: List<KSCObject>;
    public static Tree: List<object>;
    
    public static CompileFileName: string := 'Program1.ksc';
    public static CompileFile: string;
    
    public static procedure TreeAdd(var s: string);
    begin
      if (Contains(s,'begin')) and (Contains(s,'end')) then
      begin
        var k := KSCParser.CutFromText(CompileFile,'begin','end');
        TreeAdd(k);
      end
      else Tree.Add(s);
    end;
    
    public static procedure CompileTree();
    begin
      Tree := new List<Object>;
      if (Contains(CompileFile,'begin')) and (Contains(CompileFile,'end.')) then
      begin
        var k := KSCParser.CutFromText(CompileFile,'begin','end.');
        TreeAdd(k);
      end else raise new System.Exception;
    end;
    
    public static procedure StartCompiling();
    begin
      CompileFile := ReadAllText(CompileFileName,Encoding.UTF8);
      CompileTree();
      System.Console.BackgroundColor:=KTX.Black;
      System.Console.ForegroundColor:=KTX.Gray;
      Console.Clear;
      Console.SetBufferSize(KTX.Console.Width,200);
      writeln($'{ModuleName} -> {CompileFileName}');
    end;
    
    public static function IsDeclare(s: string): integer;
    begin
      Result:=-1;
      for var i:=0 to Names.Count-1 do
      begin
        if Names[i].Name = s then
        begin
          Result:=i;
          break;
        end;
      end;
    end;
    
    public static procedure DeclareVariable(s: string);
    begin
      var SplitStr := s.ToWords(' :='.ToArray);
      
      var IsTyped := not ((SplitStr.Length=3) and (not IsTypeName(SplitStr[2])));
      var IsAssigned := (not IsTyped) or ((IsTyped) and (SplitStr.Length>3));
      
      var VarName: string := SplitStr[1];
      var VarType: string := IsTyped ? SplitStr[2] : 'null';
      var VarValue: string := IsAssigned ? (IsTyped ? SplitStr[3] : SplitStr[2]) : 'null';
      
      if IsDeclare(VarName) >= 0 then raise new System.Exception('Переменная {VarName} уже существует');
      
      var rightid := IsDeclare(VarValue);
      if rightid >= 0 then VarValue := Names[rightid].ToString else VarValue := KSCParser.Parse(Names,VarValue).ToString;
      
      if IsTyped then
        if IsAssigned then Names.Add(Types.GetVariable(VarName,VarValue,Types.StrToType(VarType)))
          else Names.Add(Types.GetNullVariable(VarName,Types.StrToType(VarType)))
        else Names.Add(Types.GetAutoVariable(VarName,VarValue));
    end;
    
    public static procedure AssignVariable(s: string);
    begin
      var SplitStr := s.ToWords(' :='.ToArray);
      
      var VarName: string := SplitStr[0];
      var VarValue: string := SplitStr[1];
      
      var leftid := IsDeclare(VarName);
      var rightid := IsDeclare(VarValue);
      if leftid = -1 then raise new System.Exception($'Переменная {VarName} не объявлена');
      if rightid >= 0 then VarValue := Names[rightid].ToString else VarValue := KSCParser.Parse(Names,VarValue).ToString;
      
      //Names[leftid].SetValue(VarValue);
      Names[leftid] := GetVariable(Names[leftid].Name,KSCParser.Parse(Names,VarValue).ToString,Names[leftid].GetType);
    end;
    
    public static procedure Destruct(s: string);
    begin
      var VarName := s.ToWords[1];
      
      if IsDeclare(VarName) = -1 then raise new System.Exception($'Нельзя удалить несуществующую переменную {VarName}');
      
      var id := -1;
      
      for var i:=0 to Names.Count-1 do
      begin
        if Names[i].Name = VarName then
        begin
          id := i; break;
        end;
      end;
      
      Names.RemoveAt(id);
    end;
    
    public static procedure Method(s: string);
    begin
      var MethodArg := s.OutOfContext('(',')');
      var MethodName := Copy(s,1,s.IndexOf('('));
      
      case MethodName.ToLower.Remove(' ') of
        'write': write(KSCParser.Parse(Names,MethodArg));
        'writeln': writeln(KSCParser.Parse(Names,MethodArg));
        'readln':
        begin
          var id := -1;
          
          for var i:=0 to Names.Count-1 do
          begin
            if Names[i].Name = MethodArg then
            begin
              id := i; break;
            end;
          end;
          
          if id = -1 then raise new System.Exception($'Переменной {MethodArg} не существует')
            else //Names[id].SetValue(KSCParser.Parse(Names,ReadLnString).ToString);
                 Names[id] := GetVariable(Names[id].Name,KSCParser.Parse(Names,ReadLnString).ToString,Names[id].GetType);
        end;
      end;
    end;
    
    public static procedure CompileString(CCS: string);
    begin
      var Declaration := CCS.ToWords.Contains('var');
      var Destruction := CCS.ToWords.Contains('destruct');
      var Assignation := (KSCParser.Contains(CCS.ToLower,':=')) and (not Declaration);
      var IsAction := (not Declaration) and (not Assignation);
      
      if Destruction then Destruct(CCS);
      if Declaration then DeclareVariable(CCS);
      if Assignation then AssignVariable(CCS);
      if IsAction then Method(CCS);
    end;
    
    public static procedure CompileLine(o: object);
    begin
      match o with
        string(var CCS):
        begin
          var CS := CCS.Split(';');
          for var i:=0 to CS.Length-1 do CompileString(CS[i]);
        end;
        SequenceType<object>(var oo): foreach var x in oo do CompileLine(x);
      end;
    end;
    
    public static procedure Compile();
    begin
      StartCompiling;
      Names := new List<KSCObject>;
      var CompileList := CompileFile.Remove(NewLine).Remove('	').Split(';');
      for var i:=0 to Tree.Count-1 do
      //for var i:=0 to CompileList.Length-11 do
      begin
        CompileLine(Tree[i]);
        //CompileLine(CompileList[i]);
      end;
      Names := nil;
    end;
  end;

begin
  var Main := new Block();
  while Main do
  begin
    Main.Reload;
      Console.DrawOn(1,1,KTX.StrFull);
      Console.DrawOn(1,2,StrFull);
      
      Console.SetCursorPosition(1,4);
      Console.Draw(FileExists(Compiler.CompileFileName) ? Console.ColorFore : Console.ColorDisable,'(1) Скомпилировать');
      Console.SetFontStandard;
      Console.DrawOn(1,5,$'(2) Изменить имя входного файла (сейчас: {Compiler.CompileFileName})');
      Console.DrawOn(1,6,'(0) Выйти');
    Main.Read;
    
    case Main.Input of
      string('1'):
      begin
        Console.Clear;
        try
          Compiler.Compile();
        except
          on e: System.Exception do writeln(e);
        end;
        writeln; System.Console.ReadKey;
        
        System.Console.BackgroundColor:=Console.ColorBack;
        Console.SetFontStandard;
      end;
      string('2'):
      begin
        var Rename := new Block();
        while Rename do
        begin
          Rename.Reload;
          
          Console.DrawOn(1,1,'Введите существующее имя файла');
          Console.DrawOn(1,2,'Для отменые введите 0');
          
          Rename.Read;
          
          if FileExists(Rename.Input) then Compiler.CompileFileName := Rename.Input;
          if Rename.Input = '0' then Rename.Close;
        end;
      end;
      string('0'): Main.Close;
    end;
  end;
end.