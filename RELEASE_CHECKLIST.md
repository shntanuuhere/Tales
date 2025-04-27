# Tales App Release Checklist

Use this checklist to ensure your app is ready for release to the app stores.

## Firebase Configuration

- [x] Created Firebase project in Firebase Console
- [x] Registered Android app and added google-services.json to android/app/
- [x] Registered iOS app and added GoogleService-Info.plist to ios/Runner/
- [x] Ran FlutterFire CLI to generate firebase_options.dart
- [x] Enabled Email/Password authentication
- [x] Enabled Google Sign-In authentication
- [x] Set up Firestore Database with proper security rules

## App Functionality

- [x] Wallpaper browsing works correctly
- [x] Wallpaper downloading works correctly
- [x] Setting wallpapers as home/lock screen works
- [x] Favorites functionality works correctly
- [x] Categories navigation works correctly
- [x] Dark mode toggle works correctly
- [x] Authentication (login/register) works correctly

## Testing

- [ ] Tested on multiple Android devices/versions
- [ ] Tested on multiple iOS devices/versions (if applicable)
- [x] All widget tests pass
- [ ] Performed manual testing of all features
- [ ] Tested offline functionality
- [ ] Tested with slow network conditions
- [x] Verified app doesn't crash on startup

## Performance

- [x] App launches quickly
- [x] Scrolling is smooth
- [x] Images load efficiently
- [x] No memory leaks detected
- [x] Battery usage is reasonable

## App Store Preparation

- [x] Updated app version in pubspec.yaml (1.0.2+2)
- [x] Created app icon and splash screen
- [ ] Prepared screenshots for app stores
- [x] Wrote compelling app description
- [x] Created privacy policy
- [x] Prepared promotional graphics

## Android Specific

- [x] Configured build.gradle with correct applicationId (com.hereco.tales)
- [x] Set minSdkVersion to 21 or higher (currently 24)
- [x] Generated signed APK/App Bundle
- [ ] Tested signed build on real device

## iOS Specific

- [x] Configured Info.plist with required permissions
- [x] Set up app signing in Xcode
- [ ] Tested on real iOS device
- [x] Verified all required icons are included

## Final Steps

- [x] Removed debug code and logging
- [x] Enabled code obfuscation
- [x] Created ProGuard rules
- [x] Enabled Sentry for crash reporting
- [x] Verified analytics are working correctly
- [x] Created release notes
- [ ] Performed final review of app store listing

Once all items are checked, your app should be ready for submission to the app stores!
