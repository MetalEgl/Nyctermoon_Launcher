@echo off
setlocal enabledelayedexpansion
:: Get the directory of the script
set "SCRIPT_DIR=%~dp0"
:: Remove trailing backslash
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
echo WoW Launcher
echo.
if not exist "%SCRIPT_DIR%\wow.exe" (
    echo ERROR: wow.exe not found in the script directory.
    goto end
)
:menu
echo Choose an option:
echo 1. WoW 1.12 Legion Graphics
echo 2. WoW 1.12 Vanilla
echo 3. WoW 1.12 Legion Graphics (Tweaked)
echo 4. WoW 1.12 Vanilla (Tweaked)
echo 5. Exit
set /p choice="Enter your choice (1-5): "
if "!choice!"=="1" goto legion_graphics
if "!choice!"=="2" goto vanilla
if "!choice!"=="3" goto legion_graphics_tweaked
if "!choice!"=="4" goto vanilla_tweaked
if "!choice!"=="5" exit /b 0
echo Invalid choice. Please try again.
goto menu

:legion_graphics
call :restore_patch_files
goto launch_wow

:vanilla
call :move_patch_files
goto launch_wow

:legion_graphics_tweaked
if exist "%SCRIPT_DIR%\vanillafixes.exe" (
    call :restore_patch_files
    set "LAUNCH_EXE=vanillafixes.exe"
    goto launch_wow
) else (
    echo vanillafixes.exe not found. This option is currently unavailable.
    pause
    goto menu
)

:vanilla_tweaked
if exist "%SCRIPT_DIR%\vanillafixes.exe" (
    call :move_patch_files
    set "LAUNCH_EXE=vanillafixes.exe"
    goto launch_wow
) else (
    echo vanillafixes.exe not found. This option is currently unavailable.
    pause
    goto menu
)

:restore_patch_files
echo Checking and restoring patch files if needed...
if not exist "%SCRIPT_DIR%\Data" mkdir "%SCRIPT_DIR%\Data"
for %%f in (Patch-4.mpq Patch-5.mpq Patch-6.mpq) do (
    if not exist "%SCRIPT_DIR%\Data\%%f" (
        if exist "%SCRIPT_DIR%\Data\Interface\%%f" (
            echo Moving %%f from Interface to Data folder...
            move "%SCRIPT_DIR%\Data\Interface\%%f" "%SCRIPT_DIR%\Data\"
            if errorlevel 1 (
                echo Failed to move %%f
                pause
                goto menu
            ) else (
                echo Successfully moved %%f
            )
        ) else (
            echo %%f not found in Data or Interface folder.
        )
    ) else (
        echo %%f already in Data folder.
    )
)
echo Patch files check complete.
exit /b

:move_patch_files
echo Moving patch files...
if not exist "%SCRIPT_DIR%\Data\Interface" mkdir "%SCRIPT_DIR%\Data\Interface"
for %%f in (Patch-4.mpq Patch-5.mpq Patch-6.mpq) do (
    if exist "%SCRIPT_DIR%\Data\%%f" (
        echo Moving %%f to Interface folder...
        move "%SCRIPT_DIR%\Data\%%f" "%SCRIPT_DIR%\Data\Interface\"
        if errorlevel 1 (
            echo Failed to move %%f
            pause
            goto menu
        ) else (
            echo Successfully moved %%f
        )
    ) else (
        echo %%f not found in Data folder
    )
)
echo Patch files moved.
exit /b

:launch_wow
if not defined LAUNCH_EXE set "LAUNCH_EXE=wow.exe"
echo Launching WoW...
start "" "%SCRIPT_DIR%\%LAUNCH_EXE%"
if errorlevel 1 (
    echo Failed to launch WoW. Please check your installation.
) else (
    echo WoW launched successfully.
)
echo.
echo Returning to menu...
timeout /t 5 >nul
set "LAUNCH_EXE="
goto menu

:end
pause

