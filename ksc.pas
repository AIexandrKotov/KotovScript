uses KSCParser, Types, Exceptions, LightParser, KTX;

type
  PolysemyFoundException = class(KSCException)
    const s = 'Обнаружена запрещённая многозначная конструкция';
  end;
  DeclareWithFewArguments = class(KSCException)
    const s = 'Неправильное объявление переменной';
  end;

type  
  Compiler = static class
    public static CompileFileName: string := 'Program1.ksc';
    public static CompileFile: string;
    
    public static Names := new List<KSCObject>;
    
    public static procedure LoadCompile(fname: string);
    begin
      CompileFile:=ReadAllText(fname,Encoding.UTF8);
    end;
    
    public static
      IsDeclareConstruction,
      IsAssignConstruction,
      IsArrayDeclare,
      IsArrayAssign,
      IsMethod: boolean;
      
    public static procedure ReloadIses;
    begin
      IsDeclareConstruction := false;
      IsAssignConstruction := false;
      IsArrayDeclare := false;
      IsArrayAssign := false;
      IsMethod := false;
    end;
    
    public static function Declared(name: string): boolean;
    begin
      Result := Names.Count(x -> x.Name=name) > 0;
    end;
    
    public static procedure DeclareConstruction(s: string);
    begin
      var s1:=s.Split(' :'.ToArray);
      
      //var a: int32;
      //var b: int32 := 100;
      //var c: int32 := b;
      //var d := 100;
      //var e := e;
      
      if (s1=nil) or (s1.Length<3) then raise new DeclareWithFewArguments(DeclareWithFewArguments.s);
      
      var VariableName := s1[1];
      var VariableType: System.Type;
      var VariableValue: string;
      var UnTyped := false;
      if IsType(s1[2]) then VariableType := ParseType(s1[2]) else UnTyped:=true;
      if IsAssignConstruction then
        if UnTyped then VariableValue := KSCParser.Parse(Names.ToArray,s1[3])
          else VariableValue:=KSCParser.Parse(Names.ToArray,s1[4]);
      if UnTyped then Names.Add(Types.DeclareAndAssign(VariableName,typeof(KSCAutoType),VariableValue))
        else Names.Add(Types.DeclareAndAssign(VariableName,VariableType,VariableValue));
      
    end;
    
    public static procedure Compile();
    begin
      System.Console.BackgroundColor:=KTX.Black;
      System.Console.ForegroundColor:=KTX.Gray;
      Console.Clear;
      var CompileList := CompileFile.Remove(NewLine).DeleteExtraSpaces.Split(';');
      for var i:=0 to CompileList.Length-1 do
      begin
        try
          {$region Compiler}
          var CurrentCompileString := CompileList[i];
          IsDeclareConstruction := CurrentCompileString.Contains('var');
          IsAssignConstruction := CurrentCompileString.Contains(':=');
          IsArrayDeclare := CurrentCompileString.Contains('array of');
          IsArrayAssign := (CurrentCompileString.Contains('arr(')) and ((IsDeclareConstruction) or (IsAssignConstruction));
          IsMethod := (CurrentCompileString.Contains('(')) and (not CurrentCompileString.Contains(' ('));
          
          if IsDeclareConstruction then DeclareConstruction(CurrentCompileString);
          {$endregion}
        except
          on e: KSCException do raise new KSCException(e.message,i);
        end;
      end;
      Names.Clear;
    end;
  end;

begin
  Console.SetTitle('ksc.exe');
  var Main := new Block();
  while Main do
  begin
    Main.Reload;
      Console.DrawOn(1,1,KTX.StrFull);
      
      Console.SetCursorPosition(1,3);
      Console.Draw(FileExists(Compiler.CompileFileName) ? Console.ColorFore : Console.ColorDisable,'(1) Скомпилировать');
      Console.SetFontStandard;
      Console.DrawOn(1,4,$'(2) Изменить имя входного файла (сейчас: {Compiler.CompileFileName})');
      Console.DrawOn(1,5,'(0) Выйти');
    Main.Read;
    
    if (Main.Input = '1') and (FileExists(Compiler.CompileFileName)) then
    begin
      Console.Clear; try Compiler.Compile except on e: KSCException do writeln(e); end; writeln; System.Console.ReadKey;
      
      System.Console.BackgroundColor:=Console.ColorBack;
      Console.SetFontStandard;
    end;
    if (Main.Input = '2') then
    begin
      var Rename := new Block();
      while Rename do
      begin
        Rename.Reload;
          Console.DrawOn(1,1,'Введите имя существующего файла');
          Console.DrawOn(1,2,'Для отмены введите 0');
        Rename.Read;
        
        if FileExists(Rename.Input) then
        begin
          Compiler.CompileFileName:=Rename.Input;
          Rename.Close;
        end;
        if Rename.Input = '0' then Rename.Close;
      end;
    end;
    if Main.Input = '0' then Main.Close;
  end;
end.