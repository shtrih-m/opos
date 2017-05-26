unit duSemaphore;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  Semaphore;

type
  { ElectronicJournal }

  TduSemaphore = class(TTestCase)
  published
    procedure CheckRelease;
    procedure CheckSemaphore;
  end;

implementation

{ TduSemaphore }

procedure TduSemaphore.CheckRelease;
var
  Item1: TSemaphore;
begin
  Item1 := TSemaphore.Create;
  try
    Item1.Open('Device1');
    CheckEquals(WAIT_OBJECT_0, Item1.WaitFor(0));
    Item1.Release;

    try
      Item1.Release;
      Fail('Item1.Release');
    except
    
    end;
  finally
    Item1.Free;
  end;
end;

procedure TduSemaphore.CheckSemaphore;
var
  Item1: TSemaphore;
  Item2: TSemaphore;
begin
  Item1 := TSemaphore.Create;
  Item2 := TSemaphore.Create;
  try
    Item1.Open('Device1');
    CheckEquals(WAIT_OBJECT_0, Item1.WaitFor(0));

    Item2.Open('Device1');
    CheckEquals(WAIT_TIMEOUT, Item2.WaitFor(0));

    Item1.Release;
    CheckEquals(WAIT_OBJECT_0, Item2.WaitFor(0));

    CheckEquals(WAIT_TIMEOUT, Item1.WaitFor(0));
    Item2.Release;
    CheckEquals(WAIT_OBJECT_0, Item1.WaitFor(0));

  finally
    Item1.Free;
    Item2.Free;
  end;
end;

(*
initialization
  RegisterTest('', TduSemaphore.Suite);
*)

end.
