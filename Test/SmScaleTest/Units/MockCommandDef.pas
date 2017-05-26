unit MockCommandDef;

interface

uses
  // This
  CommandDef;

type
  { TMockCommandDefs }

  TMockCommandDefs = class(TCommandDefs)
  public
    procedure SaveToFile(const FileName: string); override;
    procedure LoadFromFile(const FileName: string); override;
  end;

implementation

{ TMockCommandDefs }

procedure TMockCommandDefs.LoadFromFile(const FileName: string);
begin

end;

procedure TMockCommandDefs.SaveToFile(const FileName: string);
begin

end;

end.
