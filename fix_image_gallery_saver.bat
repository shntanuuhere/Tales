@echo off
echo Fixing image_gallery_saver plugin...

set PLUGIN_PATH=%USERPROFILE%\AppData\Local\Pub\Cache\hosted\pub.dev\image_gallery_saver-1.7.1\android

if not exist "%PLUGIN_PATH%" (
    echo Plugin path not found: %PLUGIN_PATH%
    exit /b 1
)

echo Backing up original build.gradle...
if exist "%PLUGIN_PATH%\build.gradle" (
    copy "%PLUGIN_PATH%\build.gradle" "%PLUGIN_PATH%\build.gradle.bak"
)

echo Copying fixed build.gradle...
copy "android\image_gallery_saver_fix\build.gradle" "%PLUGIN_PATH%\build.gradle"

echo Fix applied successfully!
echo Now run 'flutter clean' and try building again.
