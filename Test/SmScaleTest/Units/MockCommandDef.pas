unit MockCommandDef;

interface

uses
  // This
  CommandDef;

type
  { TMockCommandDefs }

  TMockCommandDefs = class(TCommandDefs)
  public
    procedure SaveToFile(const FileName: WideString); override;
    procedure LoadFromFile(const FileName: WideString); override;
  end;

implementation

{ TMockCommandDefs }

procedure TMockCommandDefs.LoadFromFile(const FileName: WideString);
begin

end;

procedure TMockCommandDefs.SaveToFile(const FileName: WideString);
begin

end;

end.
