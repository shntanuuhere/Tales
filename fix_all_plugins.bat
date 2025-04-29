@echo off
echo Fixing Android namespace issues in Flutter plugins...

REM List of plugins that might need fixing
set PLUGINS=image_gallery_saver-1.7.1 wallpaper_manager_plus-1.0.0

for %%p in (%PLUGINS%) do (
    set PLUGIN_PATH=%USERPROFILE%\AppData\Local\Pub\Cache\hosted\pub.dev\%%p\android
    
    if exist "!PLUGIN_PATH!" (
        echo Checking plugin: %%p
        
        REM Check if build.gradle exists
        if exist "!PLUGIN_PATH!\build.gradle" (
            echo Backing up original build.gradle...
            copy "!PLUGIN_PATH!\build.gradle" "!PLUGIN_PATH!\build.gradle.bak"
            
            REM Check if namespace is already defined
            findstr /C:"namespace" "!PLUGIN_PATH!\build.gradle" > nul
            if errorlevel 1 (
                echo Adding namespace to %%p...
                
                REM Extract package name from AndroidManifest.xml
                for /f "tokens=2 delims==' " %%a in ('findstr /C:"package=" "!PLUGIN_PATH!\src\main\AndroidManifest.xml"') do (
                    set PACKAGE=%%a
                    set PACKAGE=!PACKAGE:"=!
                    set PACKAGE=!PACKAGE:>=!
                    
                    echo Found package: !PACKAGE!
                    
                    REM Add namespace to build.gradle
                    (
                        echo.
                        echo android {
                        echo     namespace '!PACKAGE!'
                        echo     // Rest of android config...
                    ) > temp.txt
                    
                    REM Replace android { with our new content
                    powershell -Command "(Get-Content '!PLUGIN_PATH!\build.gradle') -replace 'android \{', (Get-Content temp.txt -Raw) | Set-Content '!PLUGIN_PATH!\build.gradle'"
                    del temp.txt
                )
            ) else (
                echo Namespace already defined in %%p
            )
        ) else (
            echo build.gradle not found for %%p
        )
    ) else (
        echo Plugin path not found: !PLUGIN_PATH!
    )
)

echo Fixes applied!
echo Now run 'flutter clean' and try building again.
