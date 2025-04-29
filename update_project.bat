@echo off
echo Updating Tales App...

echo.
echo Step 1: Cleaning the project
flutter clean

echo.
echo Step 2: Getting dependencies
flutter pub get

echo.
echo Step 3: Checking for issues
flutter analyze

echo.
echo Step 4: Building debug APK
flutter build apk --debug

echo.
echo Update completed!
echo If you encountered any issues, please refer to the UPDATE_INSTRUCTIONS.md file.
