# VideoDownloaderApp Windows Installer Build Script

param(
    [string]$Configuration = "Release",
    [string]$Version = "1.0.0",
    [string]$OutputDir = "dist"
)

Write-Host "Building VideoDownloaderApp Windows Installer..." -ForegroundColor Green

# Set paths
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$PublishDir = Join-Path $ProjectRoot "bin\$Configuration\net8.0\win-x64\publish"
$InstallerDir = Join-Path $ProjectRoot "installers\windows"
$OutputPath = Join-Path $ProjectRoot $OutputDir

# Create output directory
New-Item -ItemType Directory -Force -Path $OutputPath | Out-Null

# Step 1: Build and publish the application
Write-Host "Publishing application..." -ForegroundColor Yellow
Set-Location $ProjectRoot
dotnet publish -c $Configuration -r win-x64 --self-contained -p:PublishSingleFile=false -o $PublishDir

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to publish application"
    exit 1
}

# Step 2: Build dependency installer
Write-Host "Building dependency installer..." -ForegroundColor Yellow
Set-Location $InstallerDir

# Create a simple project file for the dependency installer
$DependencyProjectContent = @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <PublishSingleFile>true</PublishSingleFile>
    <SelfContained>true</SelfContained>
    <RuntimeIdentifier>win-x64</RuntimeIdentifier>
  </PropertyGroup>
</Project>
"@

$DependencyProjectContent | Out-File -FilePath "DependencyInstaller.csproj" -Encoding UTF8

# Build the dependency installer
dotnet publish DependencyInstaller.csproj -c $Configuration -o . --self-contained -p:PublishSingleFile=true

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build dependency installer"
    exit 1
}

# Step 3: Build MSI with WiX (if available)
Write-Host "Building MSI installer..." -ForegroundColor Yellow
$WixPath = "${env:ProgramFiles(x86)}\WiX Toolset v4\bin"
if (-not (Test-Path $WixPath)) {
    $WixPath = "${env:ProgramFiles}\WiX Toolset v4\bin"
}

if (Test-Path $WixPath) {
    $env:PATH += ";$WixPath"
    
    # Compile WiX source
    wix build VideoDownloaderApp.wxs -d PublishDir=$PublishDir -d Version=$Version -o "$OutputPath\VideoDownloaderApp-$Version.msi"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "MSI installer created successfully!" -ForegroundColor Green
    } else {
        Write-Warning "Failed to build MSI installer"
    }
} else {
    Write-Warning "WiX Toolset not found. Skipping MSI creation."
    Write-Host "To create MSI installers, install WiX Toolset v4 from https://wixtoolset.org/" -ForegroundColor Yellow
}

# Step 4: Build NSIS installer
Write-Host "Building NSIS installer..." -ForegroundColor Yellow

# Create NSIS script
$NsisScript = @"
!define APP_NAME "VideoDownloaderApp"
!define APP_VERSION "$Version"
!define APP_PUBLISHER "VideoDownloaderApp Team"
!define APP_URL "https://github.com/videodownloaderapp"
!define APP_EXECUTABLE "VideoDownloaderApp.exe"

!include "MUI2.nsh"

Name "`${APP_NAME}"
OutFile "$OutputPath\VideoDownloaderApp-$Version-Setup.exe"
InstallDir "`$PROGRAMFILES64\`${APP_NAME}"
InstallDirRegKey HKLM "Software\`${APP_NAME}" "InstallDir"
RequestExecutionLevel admin

!define MUI_ABORTWARNING
!define MUI_ICON "..\..\Resources\logo.png"
!define MUI_UNICON "..\..\Resources\logo.png"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\..\LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Section "MainSection" SEC01
    SetOutPath "`$INSTDIR"
    File /r "$PublishDir\*"
    
    # Install dependencies
    DetailPrint "Installing dependencies..."
    ExecWait '"`$INSTDIR\DependencyInstaller.exe" install-dotnet' `$0
    ExecWait '"`$INSTDIR\DependencyInstaller.exe" install-ytdlp' `$0
    ExecWait '"`$INSTDIR\DependencyInstaller.exe" install-ffmpeg' `$0
    
    # Create shortcuts
    CreateDirectory "`$SMPROGRAMS\`${APP_NAME}"
    CreateShortCut "`$SMPROGRAMS\`${APP_NAME}\`${APP_NAME}.lnk" "`$INSTDIR\`${APP_EXECUTABLE}"
    CreateShortCut "`$DESKTOP\`${APP_NAME}.lnk" "`$INSTDIR\`${APP_EXECUTABLE}"
    
    # Registry entries
    WriteRegStr HKLM "Software\`${APP_NAME}" "InstallDir" "`$INSTDIR"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\`${APP_NAME}" "DisplayName" "`${APP_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\`${APP_NAME}" "UninstallString" "`$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\`${APP_NAME}" "DisplayVersion" "`${APP_VERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\`${APP_NAME}" "Publisher" "`${APP_PUBLISHER}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\`${APP_NAME}" "URLInfoAbout" "`${APP_URL}"
    
    WriteUninstaller "`$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
    Delete "`$INSTDIR\Uninstall.exe"
    RMDir /r "`$INSTDIR"
    
    Delete "`$SMPROGRAMS\`${APP_NAME}\`${APP_NAME}.lnk"
    RMDir "`$SMPROGRAMS\`${APP_NAME}"
    Delete "`$DESKTOP\`${APP_NAME}.lnk"
    
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\`${APP_NAME}"
    DeleteRegKey HKLM "Software\`${APP_NAME}"
SectionEnd
"@

$NsisScript | Out-File -FilePath "installer.nsi" -Encoding UTF8

# Compile NSIS installer
$NsisPath = "${env:ProgramFiles(x86)}\NSIS\makensis.exe"
if (-not (Test-Path $NsisPath)) {
    $NsisPath = "${env:ProgramFiles}\NSIS\makensis.exe"
}

if (Test-Path $NsisPath) {
    & $NsisPath "installer.nsi"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "NSIS installer created successfully!" -ForegroundColor Green
    } else {
        Write-Warning "Failed to build NSIS installer"
    }
} else {
    Write-Warning "NSIS not found. Skipping NSIS installer creation."
    Write-Host "To create NSIS installers, install NSIS from https://nsis.sourceforge.io/" -ForegroundColor Yellow
}

# Step 5: Create portable ZIP package
Write-Host "Creating portable ZIP package..." -ForegroundColor Yellow
$ZipPath = "$OutputPath\VideoDownloaderApp-$Version-Portable.zip"
Compress-Archive -Path "$PublishDir\*" -DestinationPath $ZipPath -Force
Write-Host "Portable ZIP package created: $ZipPath" -ForegroundColor Green

# Cleanup
Remove-Item "DependencyInstaller.csproj" -ErrorAction SilentlyContinue
Remove-Item "installer.nsi" -ErrorAction SilentlyContinue

Write-Host "Windows installer build completed!" -ForegroundColor Green
Write-Host "Output directory: $OutputPath" -ForegroundColor Cyan
Write-Host "Generated files:" -ForegroundColor Cyan
Get-ChildItem $OutputPath -Filter "VideoDownloaderApp-$Version*" | ForEach-Object {
    Write-Host "  $($_.Name)" -ForegroundColor White
}

# Summary
Write-Host "`nBuild Summary:" -ForegroundColor Green
Write-Host "✓ Application published successfully" -ForegroundColor Green
Write-Host "✓ Dependency installer built" -ForegroundColor Green

if (Test-Path "$OutputPath\VideoDownloaderApp-$Version.msi") {
    Write-Host "✓ MSI installer created" -ForegroundColor Green
} else {
    Write-Host "⚠ MSI installer not created (WiX not found)" -ForegroundColor Yellow
}

if (Test-Path "$OutputPath\VideoDownloaderApp-$Version-Setup.exe") {
    Write-Host "✓ NSIS installer created" -ForegroundColor Green
} else {
    Write-Host "⚠ NSIS installer not created (NSIS not found)" -ForegroundColor Yellow
}

Write-Host "✓ Portable ZIP package created" -ForegroundColor Green

Write-Host "`nTo install missing tools:" -ForegroundColor Cyan
Write-Host "- WiX Toolset v4: https://wixtoolset.org/" -ForegroundColor White
Write-Host "- NSIS: https://nsis.sourceforge.io/" -ForegroundColor White
