@echo off
setlocal enabledelayedexpansion
:: Get the directory of the script
set "SCRIPT_DIR=%~dp0"
:: Remove trailing backslash
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Set console color to Cyan text on Black background
color 0B

cls
echo.
echo  _   _             _                                      
echo ^| \ ^| ^|           ^| ^|                                     
echo ^|  \^| ^|_   _  ____^| ^|_ ___ _ __ _ __ ___   ___   ___  _ __  
echo ^| . ` ^| ^| ^| ^|/ ___^| __/ _ \ '__^| '_ ` _ \ / _ \ / _ \^| '_ \ 
echo ^| ^|\  ^| ^|_^| ^| (___^| ^|^|  __/ ^|  ^| ^| ^| ^| ^| ^| (_) ^| (_) ^| ^| ^| ^|
echo ^|_^| \_^|\__, ^|\____^|\__\___^|_^|  ^|_^| ^|_^| ^|_^|\___/ \___/^|_^| ^|_^|
echo        __/ ^|                                              
echo       ^|___/                                               
echo.

if not exist "%SCRIPT_DIR%\wow.exe" (
    echo ERROR: wow.exe not found in the script directory.
    goto end
)

:check_vanillafixes
if exist "%SCRIPT_DIR%\vanillafixes.exe" (
    goto menu_with_vanillafixes
) else (
    goto menu_without_vanillafixes
)

:menu_with_vanillafixes
echo Choose an option:
echo 1. WoW 1.12 Legion Graphics (FPS Boost)
echo 2. WoW 1.12 Vanilla (FPS Boost)
echo 3. Exit
set /p choice="Enter your choice (1-3): "
if "!choice!"=="1" goto legion_graphics_tweaked
if "!choice!"=="2" goto vanilla_tweaked
if "!choice!"=="3" exit /b 0
echo Invalid choice. Please try again.
goto menu_with_vanillafixes

:menu_without_vanillafixes
echo Choose an option:
echo 1. WoW 1.12 Legion Graphics
echo 2. WoW 1.12 Vanilla
echo 3. Exit
set /p choice="Enter your choice (1-3): "
if "!choice!"=="1" goto legion_graphics
if "!choice!"=="2" goto vanilla
if "!choice!"=="3" exit /b 0
echo Invalid choice. Please try again.
goto menu_without_vanillafixes

:legion_graphics
call :restore_patch_files
call :show_loading_ticker
goto launch_wow

:vanilla
call :move_patch_files
call :show_loading_ticker
goto launch_wow

:legion_graphics_tweaked
call :restore_patch_files
call :show_loading_ticker
set "LAUNCH_EXE=vanillafixes.exe"
goto launch_wow

:vanilla_tweaked
call :move_patch_files
call :show_loading_ticker
set "LAUNCH_EXE=vanillafixes.exe"
goto launch_wow

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
                goto check_vanillafixes
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
            goto check_vanillafixes
        ) else (
            echo Successfully moved %%f
        )
    ) else (
        echo %%f not found in Data folder
    )
)
echo Patch files moved.
exit /b

:show_loading_ticker
<nul set /p "=Loading "
for /l %%i in (1,1,5) do <nul set /p ".=."
echo.
exit /b

:launch_wow
if not defined LAUNCH_EXE set "LAUNCH_EXE=wow.exe"
echo Launching WoW...
start "" "%SCRIPT_DIR%\%LAUNCH_EXE%"
echo.
echo Returning to menu...
timeout /t 5 >nul
set "LAUNCH_EXE="
goto check_vanillafixes

:end
pause
