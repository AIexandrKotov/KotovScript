unit LightParser;

function GetBetweenString(self: string; delimiter: string): string; extensionmethod;
begin
  var a:=self.IndexOf(delimiter);
  var b:=self.LastIndexOf(delimiter);
  Result:=Copy(self,a+1+delimiter.Length,b-a-delimiter.Length);
end;

function GetBetweenString(self: string; start, finish: string): string; extensionmethod;
begin
  var a:=self.IndexOf(start);
  var b:=self.LastIndexOf(finish);
  Result:=Copy(self,a+1+start.Length,b-a-finish.Length);
end;

function DeleteExtraSpaces(self: string): string; extensionmethod;
begin
  var sb:=new StringBuilder();
  var InternalString := false;
  for var i:=1 to self.Length do
  begin
    if self[i]='''' then
      if InternalString then InternalString:=false else InternalString:=true;
    if ((i>1) and ((not ((self[i-1]=' ') and (self[i]=' '))) and (not (InternalString)))) or (i=1) then sb+=self[i]; 
  end;
  Result:=sb.ToString;
end;

begin

end.