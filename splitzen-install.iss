#define MyAppName "Splitzen"
#define MyAppNameSmall "splitzen"
#define MyAppVersion "0.6.4"
#define MyAppPublisher "Rowan Thorpe"
#define MyURL "http://www.rowanthorpe.com"
#define MyAppURL "http://github.com/rowanthorpe/splitzen"
#define MyAppExeName "splitzen.cmd"
#define MyAppYears "2010,2011,2013"

[Setup]
AllowUNCPath=false
AlwaysShowGroupOnReadyPage=true
AppCopyright=(c) {#MyAppYears} Rowan Thorpe
AppID={{496D5090-DFA2-4B35-AAB5-94BBEC353AEF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
Compression=lzma2/Ultra64
CreateAppDir=true
CreateUninstallRegKey=false
DefaultDirName={userdesktop}\{#MyAppNameSmall}-{#MyAppVersion}
DirExistsWarning=yes
DisableDirPage=yes
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
DisableStartupPrompt=true
Encryption=false
InfoBeforeFile=SOURCES.txt
InternalCompressLevel=Ultra64
LicenseFile=doc\COPYING.txt
MinVersion=,5.0
OutputBaseFilename={#MyAppNameSmall}-{#MyAppVersion}-with_gnuwin32_binaries-setup
OutputManifestFile=manifest.log
PrivilegesRequired=none
RestartIfNeededByRun=false
SetupIconFile=images\{#MyAppNameSmall}-icon.ico
SetupLogging=true
SolidCompression=true
Uninstallable=true
UninstallDisplayName=Uninstall {#MyAppName} {#MyAppVersion}
UninstallLogMode=new
UpdateUninstallLogAppName=false
UsePreviousGroup=false
VersionInfoCompany={#MyURL}
VersionInfoCopyright=(c) {#MyAppYears} Rowan Thorpe
VersionInfoDescription=Drag-n-drop file splitter to arbitrary sizes.
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}
VersionInfoTextVersion={#MyAppVersion}
VersionInfoVersion={#MyAppVersion}.0

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "basque"; MessagesFile: "compiler:Languages\Basque.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: desktopicon; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Dirs]
Name: "{app}"
Name: "{app}\bin"
Name: "{app}\doc"

[Files]
Source: bin\splitzen.cmd; DestDir: "{app}\bin"; Flags: IgnoreVersion
Source: bin\head.cmd; DestDir: "{app}\bin"; Flags: IgnoreVersion
Source: bin\libiconv2.dll; DestDir: "{app}\bin"; Flags: IgnoreVersion
Source: bin\libintl3.dll; DestDir: "{app}\bin"; Flags: IgnoreVersion
Source: bin\sha1sum.exe; DestDir: "{app}\bin"; Flags: IgnoreVersion
Source: bin\split.exe; DestDir: "{app}\bin"; Flags: IgnoreVersion
Source: bin\tail.cmd; DestDir: "{app}\bin"; Flags: IgnoreVersion
Source: doc\CHANGES.txt; DestDir: "{app}\doc"; Flags: IgnoreVersion
Source: doc\COPYING.txt; DestDir: "{app}\doc"; Flags: IgnoreVersion
Source: doc\splitzen-EXAMPLECOMPUTERNAME.conf; DestDir: "{app}\doc"; Flags: IgnoreVersion
Source: doc\TODO.txt; DestDir: "{app}\doc"; Flags: IgnoreVersion
Source: README.txt; DestDir: {app}; Flags: IgnoreVersion isreadme; 
Source: SOURCES.txt; DestDir: "{app}"; Flags: IgnoreVersion

[Messages]
WinVersionTooLowError={#MyAppName} version {#MyAppVersion} requires Windows NT or later.

[Icons]
Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\bin\{#MyAppExeName}"; Parameters: --; WorkingDir: "{app}"; Tasks: desktopicon
Name: "{userdesktop}\{#MyAppName} (non-interactive)"; Filename: "{app}\bin\{#MyAppExeName}"; Parameters: --non-interactive --; WorkingDir: "{app}"; Tasks: desktopicon

[_ISTool]
UseAbsolutePaths=false

[Run]
Filename: "{app}\bin\{#MyAppNameSmall}.cmd"; Parameters: --non-interactive

[InnoIDE_Settings]
LogFileOverwrite=false
UseRelativePaths=true

[UninstallDelete]
Name: {app}\bin\splitzen-*.conf; Type: files;
