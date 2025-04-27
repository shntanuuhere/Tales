# Tales App Release Instructions

This document provides instructions for building and releasing the Tales app to the Google Play Store and Apple App Store.

## Prerequisites

- Flutter SDK installed and updated to the latest stable version
- Android Studio with Android SDK installed
- Xcode (for iOS builds)
- Google Play Developer account
- Apple Developer account (for iOS releases)
- Firebase project set up

## Building for Android

### Generate a signed App Bundle

1. Ensure you have the keystore file at `android/keystore/tales_keystore.jks`
2. Set the environment variables for the keystore password:
   ```
   export KEYSTORE_PASSWORD=tales_keystore_password
   export KEY_ALIAS=tales_key
   export KEY_PASSWORD=tales_key_password
   ```
3. Build the app bundle:
   ```
   flutter build appbundle --release
   ```
4. The app bundle will be generated at `build/app/outputs/bundle/release/app-release.aab`

### Generate a signed APK (optional)

1. Build the APK:
   ```
   flutter build apk --release
   ```
2. The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`

## Building for iOS

1. Open the iOS project in Xcode:
   ```
   open ios/Runner.xcworkspace
   ```
2. Select the appropriate team and signing certificate
3. Build the app:
   ```
   flutter build ios --release
   ```
4. Archive the app in Xcode:
   - Select Product > Archive
   - Follow the prompts to upload to App Store Connect

## Submitting to Google Play Store

1. Log in to the [Google Play Console](https://play.google.com/console)
2. Select the Tales app
3. Go to Production > Create new release
4. Upload the app bundle (.aab file)
5. Fill in the release notes from `metadata/release_notes.txt`
6. Submit for review

## Submitting to Apple App Store

1. Log in to [App Store Connect](https://appstoreconnect.apple.com)
2. Select the Tales app
3. Create a new version
4. Fill in the release notes from `metadata/release_notes.txt`
5. Upload the build from Xcode or using Transporter
6. Submit for review

## Post-Release Tasks

1. Tag the release in Git:
   ```
   git tag -a v1.0.2 -m "Version 1.0.2"
   git push origin v1.0.2
   ```
2. Monitor crash reports in Firebase Crashlytics
3. Collect user feedback
4. Plan the next update

## Troubleshooting

If you encounter issues during the build process:

1. Clean the build:
   ```
   flutter clean
   ```
2. Get dependencies:
   ```
   flutter pub get
   ```
3. Try building again

For signing issues, verify that the keystore file is in the correct location and the passwords are set correctly.
