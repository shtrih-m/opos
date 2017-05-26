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

Set Wrapper = WScript.CreateObject("OPOS.Wrapper")
Wrapper.Server = Driver
Wrapper.pInteger = 0
Wrapper.pString = "1;1;1"
Result = Wrapper.DirectIO(15)
if Result <> 0 Then
  text = "DirectIO method failed, " + Str(Result)
  MsgBox text, 16, "Error"
  return 
end If
pString = Wrapper.pString
text = "Read table result: DirectIO(15, 0, '1;1;1') = " + pString
MsgBox text, 0, "DirectIO test"