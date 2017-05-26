Set Driver = WScript.CreateObject("OPOS.FiscalPrinter")
Result = Driver.Open("SHTRIH-M-OPOS-1")
if Result <> 0 then
  text = "Open method failed, " + Result
  MsgBox text, 16, "Error"
  return 
end If
Result = Driver.ClaimDevice(0)
if Result <> 0 then
  text = "ClaimDevice method failed, " + Result
  MsgBox text, 16, "Error"
  return 
end If
Driver.DeviceEnabled = True
Result = Driver.DirectIO(9, 2, "Bold string")

Dim pString
pString = "No value"
Result = Driver.DirectIO(15, 0, "1;1;1")
if Result <> 0 then
  text = "DirectIO method failed, " + Str(Result)
  MsgBox text, 16, "Error"
  return 
end If
text = "Read table result: DirectIO(15, 0, '1;1;1') = " + pString
MsgBox text, 0, "DirectIO test"


