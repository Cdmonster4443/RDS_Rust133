@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Run as Administrator!
    pause
    exit /b 1
)

echo Adding Windows Defender exclusions...
set "GAME_DIR=%~dp0"
if "%GAME_DIR:~-1%"=="\" set "GAME_DIR=%GAME_DIR:~0,-1%"
powershell -Command "Add-MpPreference -ExclusionPath '%GAME_DIR%' -ErrorAction SilentlyContinue; Add-MpPreference -ExclusionProcess 'RustClient.exe' -ErrorAction SilentlyContinue"

echo Applying integrity and security settings...
bcdedit /set testsigning off
bcdedit /set nointegritychecks off
bcdedit /set debug off
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d 1 /f

echo.
echo Done! Please restart your computer.
pause
