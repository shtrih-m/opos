[CustomMessages]
; Russian
ru.AppName="ШТРИХ-М: OPOS драйвер фискального регистратора"
ru.AppVerName="ШТРИХ-М: OPOS драйвер фискального регистратора ${version2}"
ru.AppPublisher=ШТРИХ-М
ru.AppCopyright="Copyright, 2018 ШТРИХ-М"
ru.VersionInfoCompany="ШТРИХ-М"
ru.VersionInfoDescription="OPOS драйвер фискального регистратора"
; English
en.AppName="SHTRIH-M: OPOS fiscal printer driver"
en.AppVerName="SHTRIH-M: OPOS fiscal printer driver ${version2}"
en.AppPublisher=SHTRIH-M
en.AppCopyright="Copyright, 2018 SHTRIH-M"
en.VersionInfoCompany="SHTRIH-M"
en.VersionInfoDescription="OPOS fiscal printer driver"
[Setup]
AppName= {cm:AppName}
AppVerName= {cm:AppVerName}
AppPublisher= {cm:AppPublisher}
AppCopyright= {cm:AppCopyright}
VersionInfoCompany= {cm:VersionInfoCompany}
VersionInfoDescription= {cm:VersionInfoDescription}

AppVersion=${version2}
AppPublisherURL=http://www.shtrih-m.ru
AppSupportURL=http://www.shtrih-m.ru
AppUpdatesURL=http://www.shtrih-m.ru
AppContact=т.(495) 787-6090
AppReadmeFile=History.txt
;Версия
VersionInfoTextVersion="${version}"
VersionInfoVersion=${version}
DefaultDirName= {pf}\OPOS\SHTRIH-M\
DefaultGroupName=OPOS\SHTRIH-M\
UninstallDisplayIcon= {app}\Uninstall.exe
UsePreviousLanguage=No
AllowNoIcons=Yes
OutputDir="."
[Setup]
OutputBaseFilename=Setup
[Components]
Name: "main"; Description: "Driver files"; Types: full compact custom; Flags: fixed
Name: "source"; Description: "Samples and source code"; 
[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
[Files]
; Version history
Source: "History.txt"; DestDir: "{app}"; Flags: ignoreversion; components: main;
; Localization params
Source: "Setup\locales\SmFiscalPrinter.mo"; DestDir: "{app}\locale\en\LC_MESSAGES\"; Flags: 32bit; Components: main
Source: "Setup\Locales\ru\locale.ini"; DestDir: "{userappdata}\SHTRIH-M\OposShtrih"; DestName: "locale.ini"; Flags: 32bit; Components: main; Languages: ru
Source: "Setup\Locales\en\locale.ini"; DestDir: "{userappdata}\SHTRIH-M\OposShtrih"; DestName: "locale.ini"; Flags: 32bit; Components: main; Languages: en
; Logo files
Source: "Setup\Logo\*.*"; DestDir: "{app}\Bin\Logo"; Flags: ignoreversion; components: main;
; Drivers
Source: "Setup\zint.dll"; DestDir: "{app}\Bin"; Flags: ignoreversion; components: main;
Source: "Setup\zlib1.dll"; DestDir: "{app}\Bin"; Flags: ignoreversion; components: main;
Source: "Setup\libpng15.dll"; DestDir: "{app}\Bin"; Flags: ignoreversion; components: main;
Source: "Bin\SmScale.dll"; DestDir: "{app}\Bin"; Flags: ignoreversion regserver; components: main;
Source: "Bin\SmFiscalPrinter.dll"; DestDir: "{app}\Bin"; Flags: ignoreversion regserver; components: main;
;Source: "Bin\SmFiscalPrinter.RUS"; DestDir: "{app}\Bin"; Flags: ignoreversion; components: main;
; Print server
Source: "Bin\SmFptrSrv.exe"; DestDir: "{app}\Bin"; Flags: ignoreversion; components: main;
; Configuration utility
Source: "Bin\OposConfig.exe"; DestDir: "{app}\Bin"; Flags: ignoreversion; components: main;
; Test utility
Source: "Bin\OposTest.exe"; DestDir: "{app}\Bin"; Flags: ignoreversion; components: main;
Source: "Setup\Models.xml"; DestDir: "{app}\Bin"; Flags: ignoreversion; components: main;
Source: "Setup\Commands.xml"; DestDir: "{app}\Bin"; Flags: ignoreversion; components: main;
; Source code
Source: "Source\Script\*"; DestDir: "{app}\Source\Script"; Flags: createallsubdirs recursesubdirs; components: source;
Source: "Source\Opos\*"; DestDir: "{app}\Source\Opos"; Flags: createallsubdirs recursesubdirs; Excludes: "*.svn,*.exe,*.dll,*.dcu,*.rsm,*.xml";	components: source;
Source: "Source\OposTest\*"; DestDir: "{app}\Source\OposTest"; Flags: createallsubdirs recursesubdirs; Excludes: "*.svn,*.exe,*.dll,*.dcu,*.rsm,*.xml";	 components: source;
Source: "Source\OposConfig\*"; DestDir: "{app}\Source\OposConfig"; Flags: createallsubdirs recursesubdirs; Excludes: "*.svn,*.exe,*.dll,*.dcu,*.rsm,*.xml";	components: source; 
Source: "Source\SmFiscalPrinter\*"; DestDir: "{app}\Source\SmFiscalPrinter"; Flags: createallsubdirs recursesubdirs; Excludes: "*.svn,*.exe,*.dll,*.dcu,*.rsm,*.xml";	components: source;
Source: "Source\SmScale\*"; DestDir: "{app}\Source\SmScale"; Flags: createallsubdirs recursesubdirs; Excludes: "*.svn,*.exe,*.dll,*.dcu,*.rsm,*.xml";	components: source;
Source: "Source\Shared\*"; DestDir: "{app}\Source\Shared"; Flags: createallsubdirs recursesubdirs; Excludes: "*.svn,*.exe,*.dll,*.dcu,*.rsm,*.xml";	components: source;
Source: "Source\SmFptrSrv\*"; DestDir: "{app}\Source\SmFptrSrv"; Flags: createallsubdirs recursesubdirs; Excludes: "*.svn,*.exe,*.dll,*.dcu,*.rsm,*.xml";	components: source;
[Icons]
Name: "{group}\Version history"; Filename: "{app}\History.txt"; WorkingDir: "{app}";
Name: "{group}\Opos setup"; Filename: "{app}\Bin\OposConfig.exe"; WorkingDir: "{app}";
Name: "{group}\Opos test"; Filename: "{app}\Bin\OposTest.exe"; WorkingDir: "{app}";
Name: "{group}\Uninstall"; Filename: "{uninstallexe}"
[Registry]
; FiscalPrinter default device
Root: HKLM; Subkey: "SOFTWARE\OLEforRetail\ServiceOPOS\FiscalPrinter\SHTRIH-M-OPOS-1"; ValueType: string; ValueName: ""; ValueData: "OposShtrih.FiscalPrinter"; Flags: uninsdeletevalue;
; CashDrawer default device
Root: HKLM; Subkey: "SOFTWARE\OLEforRetail\ServiceOPOS\CashDrawer\SHTRIH-M-OPOS-1"; ValueType: string; ValueName: ""; ValueData: "OposShtrih.CashDrawer"; Flags: uninsdeletevalue;
Root: HKLM; Subkey: "SOFTWARE\OLEforRetail\ServiceOPOS\CashDrawer\SHTRIH-M-OPOS-1"; ValueType: string; ValueName: "FptrDeviceName"; ValueData: "SHTRIH-M-OPOS-1"; Flags: uninsdeletevalue;
; Scale
Root: HKLM; Subkey: "SOFTWARE\OLEforRetail\ServiceOPOS\Scale\SHTRIH-M-OPOS-1"; ValueType: string; ValueName: ""; ValueData: "OposShtrih.Scale"; Flags: uninsdeletevalue;
[UninstallDelete]
Type: files; Name: "{app}\*.log"
[Run]
Filename: "{app}\Bin\SmFptrSrv.exe"; Parameters: "/regserver"; Flags: nowait;












