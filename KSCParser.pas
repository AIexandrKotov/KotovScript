unit KSCParser;
{$reference 'System.Data.dll'}
uses System.Data, Types;

function CutFromText(s: string; delim1, delim2: string): string;
begin
  var a, b: integer;
  a:=s.IndexOf(delim1);
  b:=s.IndexOf(delim2);
  Result := Copy(s,a+delim1.Length+1,b-a-delim1.Length);
end;

function OutOfContext(s: string; delim1, delim2: string): string;
begin
  var a, b: integer;
  a:=s.IndexOf(delim1);
  b:=s.LastIndexOf(delim2);
  Result := Copy(s,a+delim1.Length,b-a-delim1.Length);
end;

function OutOfContext(s: string; delim1, delim2: char): string;
begin
  var a, b: integer;
  a:=s.IndexOf(delim1);
  b:=s.LastIndexOf(delim2);
  Result := Copy(s,a+2,b-a-1);
end;

function OutOfContext(self: string; delim1, delim2: string): string; extensionmethod := OutOfContext(self,delim1,delim2);

function OutOfContext(self: string; delim1, delim2: char): string; extensionmethod := OutOfContext(self,delim1,delim2);

function Contains(s: string; s2: string): boolean;
begin
  Result:=false;
  for var i:=1 to s.Length do
  begin
    if Copy(s,i,s2.Length) = s2 then Result:=true;
  end;
end;

function Parse(s: string): object;
begin
  Result:=(new System.Data.DataTable).Compute(s,'');
  //Result:
end;

function Parse(a: sequence of KSCObject; s: string): object;
begin
  var rslt:=s;
  if a<>nil then
  foreach var x in a do
    if x.Name.Length>0 then rslt:=rslt.Replace(x.Name,x.ToString);
  Result:=Parse(rslt);
end;

begin
  
end.