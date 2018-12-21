unit Exceptions;

type
  KSCException = class(System.Exception)
    public constructor Create(message: string);
    begin
      inherited Create(message);
    end;
    
    public constructor Create(message: string; id: integer);
    begin
      inherited Create($'KSCException {message} at {id}');
    end;
  end;

begin

end.