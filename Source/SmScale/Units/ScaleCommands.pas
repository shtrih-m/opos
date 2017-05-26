unit ScaleCommands;

interface

uses
  // This
  CommandDef, CommandParam, M5ScaleTypes;

procedure SetDefaultCommands(Commands: TCommandDefs);

implementation

procedure SetDefaultCommands(Commands: TCommandDefs);
var
  Command: TCommandDef;
begin
  Commands.Clear;
  // 07h
  Command := Commands.Add($07, S_COMMAND_07h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Mode', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 08h
  Command := Commands.Add($08, S_COMMAND_08h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Key code', 1, PARAM_TYPE_INT);
  // 09h
  Command := Commands.Add($09, S_COMMAND_09h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Mode', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 11h
  Command := Commands.Add($11, S_COMMAND_11h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Mode', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Weight', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Tare', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'ItemType', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Quantity', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Price', 3, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Amount', 3, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'LastKey', 1, PARAM_TYPE_INT);
  // 12h
  Command := Commands.Add($12, S_COMMAND_12h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Mode', 1, PARAM_TYPE_INT);
  // 14h
  Command := Commands.Add($14, S_COMMAND_14h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Port', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'BaudRate', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Timeout', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 15h
  Command := Commands.Add($15, S_COMMAND_15h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Port', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'BaudRate', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Timeout', 1, PARAM_TYPE_INT);
  // 16h
  Command := Commands.Add($16, S_COMMAND_16h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'NewPassword', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 30h
  Command := Commands.Add($30, S_COMMAND_30h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 31h
  Command := Commands.Add($31, S_COMMAND_31h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 32h
  Command := Commands.Add($32, S_COMMAND_32h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Tare weight', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 33h
  Command := Commands.Add($33, S_COMMAND_33h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'ItemType', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Quantity', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Price', 3, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 3Ah
  Command := Commands.Add($3A, S_COMMAND_3Ah);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Flags', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Weight', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Tare', 2, PARAM_TYPE_INT);
  // 70h
  Command := Commands.Add($70, S_COMMAND_70h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Number', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Weight', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 71h
  Command := Commands.Add($71, S_COMMAND_71h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Number', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Weight', 2, PARAM_TYPE_INT);
  // 72h
  Command := Commands.Add($72, S_COMMAND_72h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 73h
  Command := Commands.Add($73, S_COMMAND_73h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Channel number', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Point number', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Point status', 1, PARAM_TYPE_INT);
  // 74h
  Command := Commands.Add($74, S_COMMAND_74h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // 75h
  Command := Commands.Add($75, S_COMMAND_75h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Value', 4, PARAM_TYPE_INT);
  // 90h
  Command := Commands.Add($90, S_COMMAND_90h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Key code', 1, PARAM_TYPE_INT);
  // E5h
  Command := Commands.Add($E5, S_COMMAND_E5h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Channel count', 1, PARAM_TYPE_INT);
  // E6h
  Command := Commands.Add($E6, S_COMMAND_E6h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Channel number', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // E7h
  Command := Commands.Add($E7, S_COMMAND_E7h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Enable/Disable', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // E8h
  Command := Commands.Add($E8, S_COMMAND_E8h);
  Commands.AddParam(Command.InParams, 'Channel number', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Flags', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Decimal point', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Power', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'MaxWeight', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'MinWeight', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'MaxTare', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Range1', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Range2', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Range3', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Discreteness1', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Discreteness2', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Discreteness3', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Discreteness4', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'PointCount', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'CalibrationsCount', 1, PARAM_TYPE_INT);
  // E9h
  Command := Commands.Add($E9, S_COMMAND_E9h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Number', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Flags', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Decimal point', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Power', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'MaxWeight', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'MinWeight', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'MaxTare', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Range1', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Range2', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Range3', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Discreteness1', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Discreteness2', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Discreteness3', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'Discreteness4', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'PointCount', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.InParams, 'CalibrationsCount', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // EAh
  Command := Commands.Add($EA, S_COMMAND_EAh);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Channel number', 1, PARAM_TYPE_INT);
  // EFh
  Command := Commands.Add($EF, S_COMMAND_EFh);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // F0h
  Command := Commands.Add($F0, S_COMMAND_F0h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // F1h
  Command := Commands.Add($F1, S_COMMAND_F1h);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // F2h
  Command := Commands.Add($F2, S_COMMAND_F2h);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'CRC', 2, PARAM_TYPE_INT);
  // F3h
  Command := Commands.Add($F3, S_COMMAND_F3h);
  Commands.AddParam(Command.InParams, 'Password', 4, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Voltage5', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Voltage12', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'VoltageX', 2, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'VoltageFlags', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'VoltageX1', 1, PARAM_TYPE_INT);
  // F8h
  Command := Commands.Add($F8, S_COMMAND_F8h);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  // FCh
  Command := Commands.Add($FC, S_COMMAND_FCh);
  Commands.AddParam(Command.OutParams, 'Result code', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'MajorType', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'MinorType', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'MajorVersion', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'MinorVersion', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Model', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Language', 1, PARAM_TYPE_INT);
  Commands.AddParam(Command.OutParams, 'Name', 40, PARAM_TYPE_STR);
end;

end.
