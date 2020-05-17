; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "DAX Studio"
#define myAppMajor
#define myAppMinor
#define myAppRevision
#define myAppBuild
#define MyAppVersionFull ParseVersion('..\release\DaxStudio.exe', myAppMajor, myAppMinor, myAppRevision, myAppBuild)
#define MyAppVersion GetFileVersion('..\release\DaxStudio.exe')
#define MyAppPublisher "Dax Studio"
#define MyAppURL "https://daxstudio.org"
#define MyAppExeName "DaxStudio.exe"
; Calculated Constants
#define MyAppFileVersion StringChange(MyAppVersion, ".", "_")
#define use_dotnetfx471
;#define use_sql2012sp1amo
;#define use_sql2012sp1adomdclient
;#define use_sql2016amo
;#define use_sql2016adomdclient

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{CE2CEA93-9DD3-4724-8FE3-FCBF0A0915C1}

#ifdef Preview
AppName={#MyAppName} {#myAppMajor}.{#myAppMinor}.{#myAppRevision} ({#Preview})
#else
AppName={#MyAppName} {#myAppMajor}.{#myAppMinor}.{#myAppRevision}
#endif

AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
UseSetupLdr=Yes

LicenseFile=..\license.rtf

OutputBaseFilename=DaxStudio_{#myAppMajor}_{#myAppMinor}_{#myAppRevision}_setup
OutputDir=..\package
Compression=lzma
SolidCompression=yes
VersionInfoVersion={#MyAppVersion}                                      
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}
VersionInfoCompany={#MyAppURL}

SetupIconFile=DaxStudio2.ico
WizardImageFile=WizardImageFile.bmp
WizardSmallImageFile=WizardSmallImageFile.bmp

PrivilegesRequiredOverridesAllowed=dialog commandline
ArchitecturesAllowed=x86 x64
ArchitecturesInstallIn64BitMode=x64 

DisableDirPage=auto
DisableProgramGroupPage=auto
ChangesAssociations=yes
UninstallDisplayIcon={app}\daxstudio.exe

[Messages]
; define wizard title and tray status msg
; both are normally defined in innosetup's default.isl (install folder)
#ifdef Preview
SetupWindowTitle={#MyAppName} {#myAppMajor}.{#myAppMinor}.{#myAppRevision} {#Preview}
#else
SetupWindowTitle={#MyAppName} {#myAppMajor}.{#myAppMinor}.{#myAppRevision}
#endif

[Languages]
;Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "en"; MessagesFile: "compiler:Default.isl"
;Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\release\DaxStudio.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: Core
Source: "..\release\bin\DaxStudio.vsto"; DestDir: "{app}\bin"; Flags: ignoreversion; Components: Core
Source: "..\release\bin\DaxStudio.dll"; DestDir: "{app}\bin"; Flags: ignoreversion; Components: Core
Source: "..\release\bin\DaxStudio.dll.manifest"; DestDir: "{app}\bin"; Flags: ignoreversion; Components: Core
Source: "..\release\*"; DestDir: "{app}"; Flags: replacesameversion recursesubdirs createallsubdirs ignoreversion; Components: Core; Excludes: "*.pdb,*.xml,DaxStudio.vshost.*,*.config,DaxStudio.dll,DaxStudio.exe,DaxStudio.vsto"

;Standalone configs
Source: "..\release\DaxStudio.exe.config"; DestDir: "{app}"; Flags: ignoreversion; Components: Core;
;Excel Addin configs
Source: "..\release\bin\DaxStudio.dll.xl2010.config"; DestDir: "{app}\bin"; DestName: "DaxStudio.dll.config"; Flags: ignoreversion; Components: Excel; Check: IsExcel2010Installed
Source: "..\release\bin\DaxStudio.dll.config"; DestDir: "{app}\bin"; Flags: ignoreversion; Components: Excel; Check: Not IsExcel2010Installed
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

; TODO - ngen DaxStudio
;Filename: {win}\Microsoft.NET\Framework64\v4.0.30319\ngen.exe Parameters: "install ""{app}\{#MyAppExeName}"""; StatusMsg: Optimizing performance for your system ...; Flags: runhidden; Check: CheckFramework;

;[UninstallRun
;Filename: {win}\Microsoft.NET\Framework64\v4.0.30319\ngen.exe Parameters: "install ""{app}\{#MyAppExeName}"""; StatusMsg: Removing native images and dependencies ...; Flags: runhidden; Check: CheckFramework; 

[Run]
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"
;Filename: "eventcreate"; Parameters: "/ID 1 /L APPLICATION /T INFORMATION  /SO DaxStudio /D ""DaxStudio Installed"""; WorkingDir: "{sys}"; Flags: runascurrentuser runhidden; StatusMsg: "Registering DaxStudio Eventlog Source"; Components: Core
;Filename: {code:GetV4NetDir}ngen.exe; Parameters: "install ""{app}\{#MyAppExeName}"""; StatusMsg: Optimizing performance for your system ...; Flags: runhidden; 
;Check: CheckFramework;

#include "scripts\products.iss"
#include "scripts\products\stringversion.iss"
#include "scripts\products\winversion.iss"
#include "scripts\products\fileversion.iss"
#include "scripts\products\dotnetfxversion.iss"
#include "scripts\products\excelversion.iss"
#include "scripts\products\dotnetfx47.iss"
#include "scripts\products\dotnetassembly.iss"


[UninstallRun]
Filename: {code:GetV4NetDir}ngen.exe; Parameters: "uninstall ""{app}\{#MyAppExeName}""";  StatusMsg: Removing native images and dependencies ...; Flags: runhidden; 
;Check: CheckFramework; 

[Types]
Name: "full"; Description: "Full Install"
Name: "standalone"; Description: "DaxStudio Core"
Name: "custom"; Description: "Custom"; Flags: iscustom

[Registry]
Root: "HKA"; Subkey: "Software\DaxStudio"; Flags: uninsdeletekey; Components: Core; Permissions: users-read
Root: "HKA"; Subkey: "Software\DaxStudio"; ValueType: string; ValueName: "ExcelBitness"; ValueData: "64Bit"; Flags: uninsdeletekey; Components: Core; Permissions: users-read; Check: Is64BitExcelFromRegisteredExe
Root: "HKA"; Subkey: "Software\DaxStudio"; ValueType: string; ValueName: "ExcelBitness"; ValueData: "32Bit"; Flags: uninsdeletekey; Components: Core; Permissions: users-read; Check: Is32BitExcelFromRegisteredExe

;Excel x86 Addin Keys - All Users
Root: "HKA32"; Subkey: "Software\DaxStudio"; ValueType: string; ValueName: "Path"; ValueData: """{app}\{#MyAppExeName}"""; Flags: uninsdeletekey; Components: Excel; Check: Is32BitExcelFromRegisteredExe
Root: "HKA32"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio.ExcelAddIn"; ValueType: string; ValueName: "Description"; ValueData: "Dax Studio Excel Add-In"; Flags: uninsdeletekey; Components: Excel; Check: Is32BitExcelFromRegisteredExe
Root: "HKA32"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio.ExcelAddIn"; ValueType: string; ValueName: "FriendlyName"; ValueData: "Dax Studio Excel Add-In"; Flags: uninsdeletekey; Components: Excel; Check: Is32BitExcelFromRegisteredExe
Root: "HKA32"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio.ExcelAddIn"; ValueType: string; ValueName: "Manifest"; ValueData: "{code:SwapSlashes|file:///{app}\bin\DaxStudio.vsto|vstolocal}"; Flags: uninsdeletekey; Components: Excel; Check: Is32BitExcelFromRegisteredExe
Root: "HKA32"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio.ExcelAddIn"; ValueType: dword; ValueName: "LoadBehavior"; ValueData: "3"; Flags: uninsdeletekey; Components: Excel; Check: Is32BitExcelFromRegisteredExe
;Excel x64 Addin keys - All Users
Root: "HKA64"; Subkey: "Software\DaxStudio"; ValueType: string; ValueName: "Path"; ValueData: """{app}\{#MyAppExeName}"""; Flags: uninsdeletekey; Components: Excel; Check: Is64BitExcelFromRegisteredExe
Root: "HKA64"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio.ExcelAddIn"; ValueType: string; ValueName: "Description"; ValueData: "Dax Studio Excel Add-In"; Flags: uninsdeletekey; Components: Excel; Check: Is64BitExcelFromRegisteredExe
Root: "HKA64"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio.ExcelAddIn"; ValueType: string; ValueName: "FriendlyName"; ValueData: "Dax Studio Excel Add-In"; Flags: uninsdeletekey; Components: Excel; Check: Is64BitExcelFromRegisteredExe
Root: "HKA64"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio.ExcelAddIn"; ValueType: string; ValueName: "Manifest"; ValueData: "{code:SwapSlashes|file:///{app}\bin\DaxStudio.vsto|vstolocal}"; Flags: uninsdeletekey; Components: Excel; Check: Is64BitExcelFromRegisteredExe
Root: "HKA64"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio.ExcelAddIn"; ValueType: dword; ValueName: "LoadBehavior"; ValueData: "3"; Flags: uninsdeletekey; Components: Excel; Check: Is64BitExcelFromRegisteredExe

;add file association for .dax files
Root: "HKA"; Subkey: "Software\Classes\.dax"; ValueType: string; ValueData: "DAX file"; Flags: uninsdeletekey
Root: "HKA"; Subkey: "Software\Classes\DAX file"; ValueType: string; ValueData: "DAX Query File"; Flags: uninsdeletekey
Root: "HKA"; Subkey: "Software\Classes\DAX file\Shell\Open\Command"; ValueType: string; ValueData: """{app}\DaxStudio.exe"" -file ""%1"""; Flags: uninsdeletekey
Root: "HKA"; Subkey: "Software\Classes\DAX file\DefaultIcon"; ValueType: string; ValueData: "{app}\DaxStudio.exe,0"; Flags: uninsdeletevalue

;Clean up beta Excel x86 Addin Keys
;Root: "HKLM32"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio"; ValueType: none; Flags: deletekey dontcreatekey; Components: Excel; Check: Is32BitExcelFromRegisteredExe
;Clean up beta Excel x64 Addin keys
;Root: "HKLM64"; Subkey: "Software\Microsoft\Office\Excel\Addins\DaxStudio"; ValueType: none; Flags: deletekey dontcreatekey; Components: Excel; Check: Is64BitExcelFromRegisteredExe
;Clean up unused registry values
;Root: "HKCU"; Subkey: "Software\DaxStudio"; ValueType: none; Flags: deletevalue; ValueName: "ShowPreReleaseNotifications";

; Remove all users settings on uninstall
Root: "HKCU"; Subkey: "Software\DaxStudio"; ValueType: none; Flags: uninsdeletekey


[CustomMessages]
win_sp_title=Windows %1 Service Pack %2

[Components]
Name: "Excel"; Description: "Excel Addin"; Types: full
Name: "Core"; Description: "DaxStudio Core (includes connectivity to SSAS Tabular)"; Types: full standalone custom; Flags: fixed
;Name: "ASAzureSupport"; Description: "Ensures that the pre-requisites for Analysis Services Azure are installed"

; Make sure that local copies of the Excel files do not exist
[InstallDelete]
Type: files; Name: "{app}\Microsoft.Excel.Amo.dll"
Type: files; Name: "{app}\Microsoft.Excel.AdomdClient.dll"
Type: filesandordirs; Name: "{app}\*.dll"
Type: filesandordirs; Name: "{app}\*.exe"
Type: filesandordirs; Name: "{app}\*.vsto"
Type: filesandordirs; Name: "{app}\*.manifest"
Type: filesandordirs; Name: "{app}\*.config"

Type: filesandordirs; Name: "{app}\ar"
Type: filesandordirs; Name: "{app}\bg"
Type: filesandordirs; Name: "{app}\ca"
Type: filesandordirs; Name: "{app}\ca-ES"
Type: filesandordirs; Name: "{app}\cs"
Type: filesandordirs; Name: "{app}\cs-CZ"
Type: filesandordirs; Name: "{app}\da"
Type: filesandordirs; Name: "{app}\de"
Type: filesandordirs; Name: "{app}\de-DE"
Type: filesandordirs; Name: "{app}\el"
Type: filesandordirs; Name: "{app}\en"
Type: filesandordirs; Name: "{app}\es"
Type: filesandordirs; Name: "{app}\es-ES"
Type: filesandordirs; Name: "{app}\et"
Type: filesandordirs; Name: "{app}\eu"
Type: filesandordirs; Name: "{app}\fi"
Type: filesandordirs; Name: "{app}\fr"
Type: filesandordirs; Name: "{app}\fr-FR"
Type: filesandordirs; Name: "{app}\gl"
Type: filesandordirs; Name: "{app}\he"
Type: filesandordirs; Name: "{app}\hi"
Type: filesandordirs; Name: "{app}\hi-IN"
Type: filesandordirs; Name: "{app}\hr"
Type: filesandordirs; Name: "{app}\hu"
Type: filesandordirs; Name: "{app}\id"
Type: filesandordirs; Name: "{app}\it"
Type: filesandordirs; Name: "{app}\it-IT"
Type: filesandordirs; Name: "{app}\ja"
Type: filesandordirs; Name: "{app}\ja-JP"
Type: filesandordirs; Name: "{app}\kk"
Type: filesandordirs; Name: "{app}\ko"
Type: filesandordirs; Name: "{app}\lt"
Type: filesandordirs; Name: "{app}\lv"
Type: filesandordirs; Name: "{app}\ms"
Type: filesandordirs; Name: "{app}\nl"
Type: filesandordirs; Name: "{app}\nl-BE"
Type: filesandordirs; Name: "{app}\nl-NL"
Type: filesandordirs; Name: "{app}\no"
Type: filesandordirs; Name: "{app}\pl"
Type: filesandordirs; Name: "{app}\pt"
Type: filesandordirs; Name: "{app}\pt-BR"
Type: filesandordirs; Name: "{app}\pt-PT"
Type: filesandordirs; Name: "{app}\ro"
Type: filesandordirs; Name: "{app}\ru"
Type: filesandordirs; Name: "{app}\ru-RU"
Type: filesandordirs; Name: "{app}\sk"
Type: filesandordirs; Name: "{app}\sl"
Type: filesandordirs; Name: "{app}\sr-Cyrl"
Type: filesandordirs; Name: "{app}\sr-Latn"
Type: filesandordirs; Name: "{app}\sv"
Type: filesandordirs; Name: "{app}\th"
Type: filesandordirs; Name: "{app}\tr"
Type: filesandordirs; Name: "{app}\uk"
Type: filesandordirs; Name: "{app}\vi"
Type: filesandordirs; Name: "{app}\zh-CHS"
Type: filesandordirs; Name: "{app}\zh-CHT"
Type: filesandordirs; Name: "{app}\zh-Hans"
Type: filesandordirs; Name: "{app}\zh-Hant"

[Code]
#include "scripts/clihelp.iss"


//If there is a command-line parameter "skipdependencies=true", don't check for them }
function ShouldInstallDependencies(): Boolean;
begin
  Result := True
  if ExpandConstant('{param:skipdependencies|false}') <> 'false' then begin
    Result := False;
  end;
end;

var maxCommonSsasAssemblyVersion: string;

function GetV4NetDir(version: string) : string;
var 
  regkey, regval  : string;
begin

    // in case the target is 3.5, replace 'v4' with 'v3.5'
    // for other info, check out this link 
    // https://stackoverflow.com/questions/199080/how-to-detect-what-net-framework-versions-and-service-packs-are-installed
    regkey := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'

    RegQueryStringValue(HKLM, regkey, 'InstallPath', regval);

    Result := regval;
end; 

function SwapSlashes(const path:String):String;
var
   tmp:String;
begin
   tmp := path;
   StringChange(tmp, '\','/');
   Result:=tmp;
end;

//convert String from REG_BINARY to Pascal String
function ConvertToString(AString:AnsiString):String;
var
 i : Integer;
 iChar : Integer;
 outString : String;
begin
 outString :='';
 for i := 6 to (Length(AString)/2-1) do
 begin
  iChar := Ord(AString[i*2+1]); //get int value
  outString := outString + Chr(iChar);
 end;

 Result := outString;
end;

// check that DaxStudio is not in the "hard" disabled addins list and remove it if it is
procedure CleanDisabledItems;
var
  I: Integer;
  J: Integer;
  RegKeys: array[1..3] of string;
  RegKeyCnt: Integer;
  Names: TArrayOfString;
  ResultStr: AnsiString;
  keyName: String;
begin
  RegKeys[1] := 'Software\Microsoft\Office\14.0\Excel\Resiliency\DisabledItems';    // Excel 2010
  RegKeys[2] := 'Software\Microsoft\Office\15.0\Excel\Resiliency\DisabledItems';    // Excel 2013
  RegKeys[3] := 'Software\Microsoft\Office\16.0\Excel\Resiliency\DisabledItems';    // Excel 2016
  RegKeyCnt := 3; //GetArrayLength(RegKeys);

  // for each version of Excel
  //for I := 1 to RegKeyCnt do
  for I := 1 to GetArrayLength(RegKeys) do
  begin
    If  RegKeyExists(HKEY_CURRENT_USER, RegKeys[I]) then
    begin  
      if RegGetValueNames(HKEY_CURRENT_USER, RegKeys[I], Names) then
      begin
        keyName := '';
        // loop through any disabled add-ins and delete
        // any keys that reference Dax Studio
        for J := 0 to GetArrayLength(Names)-1 do
        begin
          RegQueryBinaryValue(HKEY_CURRENT_USER, RegKeys[I], Names[J], ResultStr)
          keyName := Lowercase(ConvertToString(ResultStr));
          //MsgBox('List of values:'#13#10#13#10 + S, mbInformation, MB_OK);
          if Pos( 'daxstudio.vsto', keyName) > 0 then
              RegDeleteValue(HKEY_CURRENT_USER, RegKeys[i], Names[J])
        end;
      end else
      begin
        // add any code to handle failure here
      end;
    end;

  end;
  
end;

// var ExcelMode: TInputOptionWizardPage;
// procedure GetExcelMode;
// begin
//    ExcelMode := CreateInputOptionPage(wpSelectComponents,
//     'Excel Addin', 'How would you like the Excel Addin registered',
//     'Please specify how you would like the Excel Addin registered.',
//     True, False);
//   ExcelMode.Add('All Users (requires Admin rights to change)');
//   ExcelMode.Add('Current User Only (enable from the Options menu in DAX Studio)');
//   // default to All Users
//   ExcelMode.SelectedValueIndex := 0
// end;

// function IsExcelAllUsers: Boolean;
// begin
//   Result := ExcelMode.SelectedValueIndex = 0;
// end;

// function IsExcelCurrentUser: Boolean;
// begin
//   Result := ExcelMode.SelectedValueIndex = 1;
// end;
        
function GetMaxCommonSsasAssemblyVersion(): String;
begin
    Result := maxCommonSsasAssemblyVersion;
end;

// function ShouldSkipPage(PageID: Integer): Boolean;
// begin

//   { Skip pages that shouldn't be shown }
//   if (PageID = ExcelMode.ID) and Not IsComponentSelected('Excel') then
//     Result := True
//   else
//     Result := False;
// end;


procedure InitializeWizard;
var
	i: Integer;
begin
	// Check for help switch passed on installer command line
	if paramcount() > 0 then
		for i:=1 to paramcount() do
			if (Lowercase(Copy(ParamStr(i), 1, 2)) = '/?') OR ((Length(ParamStr(i)) = 2) AND (Lowercase(Copy(ParamStr(i), 1, 2)) = '/h')) OR (Lowercase(Copy(ParamStr(i), 1, 5)) = '/help') then
				DisplayHelp();


  { Create the pages }

  // GetExcelMode();
end;


function InitializeSetup(): boolean;
begin
                     
  // clear DaxStudio from Excel Add-ins hard disabled items
  try 
    Log('Clearing Disabled items from Excel Add-in registry location');
    CleanDisabledItems();
  except
    // Catch the exception, show it, and continue
    ShowExceptionMessage;
  end;

	//init windows version
	try 
    Log('Checking Windows Version');
    initwinversion();
  except
    // Catch the exception, show it, and continue
    ShowExceptionMessage;
  end;


  
  //  Log('Checking the maximum SSAS assembly versions');
//  maxCommonSsasAssemblyVersion := GetMaxCommonSsasAssemblyVersionInternal();
//  Log('Max SSAS assembly versions ' + maxCommonSsasAssemblyVersion);
//  msgbox(GetMaxCommonSsasAssemblyVersion(), mbInformation,MB_OK);

//  if IsExcel2010Installed() then begin
//      msgbox('hello', mbInformation,MB_OK);
//  end;

//  if IsAssemblyInstalled('Microsoft.AnalysisServices', '11.0.0.0' ) then begin
//      msgbox('amo ok',mbInformation, MB_OK);
//  end  else begin
//      msgbox('amo NOT ok',mbInformation, MB_OK);
//  end;

//  if IsAssemblyInstalled('Microsoft.AnalysisServices.AdomdClient', '11.0.0.0' ) then begin
//      msgbox('adomd ok',mbInformation, MB_OK);
//  end  else begin
//      msgbox('adomd NOT ok',mbInformation, MB_OK);
//  end;
  
#ifdef use_msi20
	msi20('2.0');
#endif
#ifdef use_msi31
	msi31('3.1');
#endif
#ifdef use_msi45
	msi45('4.5');
#endif

 

if ShouldInstallDependencies() then
  Log('Checking for Dependencies')
else
  Log('WARNING: Skipping Dependency checks due to /skipdependencies=true');

// if no .netfx 4.0 is found, install the client (smallest)
#ifdef use_dotnetfx40
  Log('Checking if .Net 4.0 is installed');
	if (not netfxinstalled(NetFx40Client, '') and not netfxinstalled(NetFx40Full, '')) and ShouldInstallDependencies() then
		dotnetfx40client();
#endif

#ifdef use_dotnetfx45
    if ShouldInstallDependencies() then begin
      Log('Checking if .Net 4.5 is installed');
      dotnetfx45(0); // min allowed version is .netfx 4.5.0
    end;
#endif

#ifdef use_dotnetfx471 
    if ShouldInstallDependencies() then begin
      Log('Checking if .Net 4.7.1 is installed');
      dotnetfx47(1); // min allowed version is .netfx 4.7.1
    end;
#endif


#ifdef use_vc2010
	vcredist2010();
#endif

	Result := true;
end;


// procedure CurPageChanged(CurPageID: Integer);
// begin
// Log('Processing custom page actions for ' + IntToStr(CurPageID));
//   if CurPageID = wpReady then begin
//      if IsExcelCurrentUser then Log('Installing Excel add-in for CurrentUser');
//      If IsExcelAllUsers then Log('Installing Excel add-in for AllUsers');
//   end;
// end;


// Check if Excel is x86 or x64
const
  // Constants for GetBinaryType return values.
  SCS_32BIT_BINARY = 0;
  SCS_64BIT_BINARY = 6;
  // There are other values that GetBinaryType can return, but we're
  // not interested in them.

// Declare Win32 function  
function GetBinaryType(lpApplicationName: AnsiString; var lpBinaryType: Integer): Boolean;
external 'GetBinaryTypeA@kernel32.dll stdcall';

function Is64BitExcelFromRegisteredExe(): Boolean;
var
  excelPath: String;
  binaryType: Integer;
begin
  Result := False; // Default value - assume 32-bit unless proven otherwise.
  // RegQueryStringValue second param is '' to get the (default) value for the key
  // with no sub-key name, as described at
  // https://stackoverflow.com/questions/913938/
  if IsWin64() and RegQueryStringValue(HKEY_LOCAL_MACHINE,
      'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\excel.exe',
      '', excelPath) then begin
    // We've got the path to Excel.
    try
      if GetBinaryType(excelPath, binaryType) then begin
        Result := (binaryType = SCS_64BIT_BINARY);
      end;
    except
      // Ignore - better just to assume it's 32-bit than to let the installation
      // fail.  This could fail because the GetBinaryType function is not
      // available.  I understand it's only available in Windows 2000
      // Professional onwards.
    end;
  end;
end;

function Is32BitExcelFromRegisteredExe(): boolean;
begin
  Result := NOT Is64BitExcelFromRegisteredExe();
end;


function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  //sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);

  //Msgbox('The following uninstall strig was found' + #13#10 + 
  //    sUnInstallString, mbInformation, MB_OK);
  
  Result := sUnInstallString;
end;


/////////////////////////////////////////////////////////////////////
function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;


/////////////////////////////////////////////////////////////////////
function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    StringChange(sUninstallString, ' /I', ' /x');
    sUnInstallString := sUninstallString + ' /quiet /norestart'
    //MsgBox('About to run: ' + sUninstallString, mbInformation, MB_OK);
    if Exec('>', sUnInstallString,'', SW_SHOW, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;


/////////////////////////////////////////////////////////////////////
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      UnInstallOldVersion();
    end;
  end;
  if (CurStep=ssPostInstall) then begin
    Log('Clearing AutoSave Folder'); 
    DelTree(ExpandConstant('{userappdata}\DaxStudio\AutoSaveFiles\*.*'), False,True,False);
  end;
end;

