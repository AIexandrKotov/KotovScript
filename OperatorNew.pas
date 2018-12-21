unit OperatorNew;

{$string_nullbased+}

///Определяет, содержит ли строка оператор new
function Contains(s: string): boolean;
const
  _operatornew = 'new';
begin
  Result:=false;
  var ss:=s.ToLower;
  for var i:=0 to s.Length-1 do
  begin
    if Copy(ss,i,_operatornew.Length)=_operatornew then Result:=true;
  end;
end;

{$string_nullbased-}

begin

end.