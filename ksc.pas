uses KSCParser, Types;

type
  Compiler = static class
    public static Names: List<KSCObject>;
    
    public static CompileFileName: string;
    public static CompileFile: string;
    
    public static procedure StartCompiling();
    begin
      CompileFile := ReadAllText(CompileFileName,Encoding.UTF8);
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
      
      Names[leftid].SetValue(VarValue);
    end;
    
    public static procedure Method(s: string);
    begin
      var MethodArg := s.OutOfContext('(',')');
      var MethodName := Copy(s,1,s.IndexOf('('));
      
      case MethodName.ToLower of
        'write': write(KSCParser.Parse(Names,MethodArg));
        'writeln': writeln(KSCParser.Parse(Names,MethodArg));
      end;
    end;
    
    public static procedure Compile();
    begin
      StartCompiling;
      Names := new List<KSCObject>;
      var CompileList := CompileFile.Remove(NewLine).Split(';');
      for var i:=0 to CompileList.Length-1 do
      begin
        var CCS := CompileList[i];
        
        var Declaration := CCS.ToWords.Contains('var');
        var Assignation := (KSCParser.Contains(CCS.ToLower,':=')) and (not Declaration);
        var IsAction := (not Declaration) and (not Assignation);
        
        if Declaration then DeclareVariable(CCS);
        if Assignation then AssignVariable(CCS);
        if IsAction then Method(CCS);
      end;
      Names := nil;
    end;
  end;

begin
  Compiler.CompileFileName:='Program1.ksc';
  Compiler.Compile();
end.