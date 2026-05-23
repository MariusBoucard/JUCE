; ============================================================
;  BallzzyDelay — Inno Setup Installer Script
;  Author  : Marius
;  Created : 2026
; ============================================================

#define AppName      "BallzzyDelay"
#define AppVersion   "1.0"
#define AppPublisher "Marius"
#define AppExeName   "BallzzyDelay.exe"

; ---- Source folder where your .exe lives --------------------
; Adjust this path if you move the built binary.
#define SourceDir "C:\Users\Marius\Documents\JUCE\cmake-build-release-visual-studio\projects\delayVue\BallzzyDelay_artefacts\Release\Standalone"
#define VST3Dir       "C:\Users\Marius\Documents\JUCE\cmake-build-release-visual-studio\projects\delayVue\BallzzyDelay_artefacts\Release\VST3"

[Setup]
; Basic identity
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL=https://ballzzyDsp.operationpioneer.dedyn.io
AppSupportURL=https://ballzzyDsp.operationpioneer.dedyn.io
AppUpdatesURL=https://ballzzyDsp.operationpioneer.dedyn.io

; Where the app will be installed on the user's machine
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}

; Output — the finished installer .exe will appear here
OutputDir=C:\Users\Marius\Desktop\installer_output
OutputBaseFilename=BallzzyDelay_Setup_v{#AppVersion}

; Visuals
;SetupIconFile={#SourceDir}\BallzzyDelay.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern

; Require Windows 10 or later (JUCE standalone apps need it)
MinVersion=10.0

; Ask for admin rights so we can write to Program Files
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

; ---- Optional: add more languages by uncommenting lines below
; Name: "french";  MessagesFile: "compiler:Languages\French.isl"
; Name: "german";  MessagesFile: "compiler:Languages\German.isl"

[Tasks]
; Offer a desktop shortcut during install (ticked by default)
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; \
    GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Messages]
WelcomeLabel1=Welcome to the [name] Setup Wizard
WelcomeLabel2=This will install [name] [ver] on your computer.%n%nBallzzyDelay is a creative delay audio plugin built with JUCE.%n%nYou can choose to install the Standalone app, the VST3 plugin, or both.%n%nClick Next to continue, or Cancel to exit.
SelectDirLabel3=Setup will install the Standalone app into the following folder.%n%nThe VST3 plugin will always be placed in the standard location:%n  C:\Program Files\Common Files\VST3%n%nClick Browse to change the Standalone destination, then click Next.
FinishedLabel=Setup has finished installing [name] on your computer.%n%nEnjoy making music!

; ============================================================
;  TASKS — user picks what to install via checkboxes
; ============================================================
[Tasks]

; --- Components (mutually exclusive group header) ------------
Name: "standalone"; \
    Description: "Standalone application  (launches like a regular program)"; \
    GroupDescription: "Components to install:"; \
    Flags: checkedonce

Name: "vst3"; \
    Description: "VST3 plugin  (loads inside your DAW — Ableton, Reaper, Cubase…)"; \
    GroupDescription: "Components to install:"; \
    Flags: checkedonce

; --- Extra shortcuts ----------------------------------------
Name: "desktopicon"; \
    Description: "Create a &desktop shortcut for the Standalone app"; \
    GroupDescription: "Additional shortcuts:"; \
    Flags: unchecked; \
    Check: IsTaskSelected('standalone')
    
[Files]
; ---- Main executable ----------------------------------------
Source: "{#SourceDir}\{#AppExeName}"; \
  DestDir: "{app}"; \
  Flags: ignoreversion;   \
  Tasks: standalone


; ---- VST3 bundle (only if user ticked "vst3") ---------------
; .vst3 is a FOLDER on Windows — we copy it recursively
; into the standard DAW scan path: C:\Program Files\Common Files\VST3\
Source: "{#VST3Dir}\BallzzyDelay.vst3\*"; \
    DestDir: "{commoncf64}\VST3\BallzzyDelay.vst3"; \
    Flags: ignoreversion recursesubdirs createallsubdirs; \
    Tasks: vst3

; ---- If your build produced any extra DLLs / assets next to
;      the .exe, add them here. Examples:
;
; Source: "{#SourceDir}\*.dll";    DestDir: "{app}"; Flags: ignoreversion recursesubdirs
; Source: "{#SourceDir}\assets\*"; DestDir: "{app}\assets"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Start-menu shortcut
Name: "{group}\{#AppName}";         Filename: "{app}\{#AppExeName}"
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"

; Desktop shortcut (only if the user ticked the task above)
Name: "{autodesktop}\{#AppName}"; \
    Filename: "{app}\{#AppExeName}"; \
    Tasks: desktopicon

[Run]
; Offer to launch the app right after installation finishes
Filename: "{app}\{#AppExeName}"; \
    Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; \
    Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Clean up any loose files the app may have written to its own folder
Type: filesandordirs; Name: "{app}"
Type: filesandordirs; Name: "{commoncf64}\VST3\BallzzyDelay.vst3"
