# Firebase Setup for Tales App

This guide will help you set up Firebase for the Tales app, which is required for authentication and Firestore database functionality.

## Prerequisites

1. A Google account
2. [Firebase Console](https://console.firebase.google.com/) access

## Setup Steps

### 1. Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Follow the setup wizard to create your project
4. Enable Google Analytics if desired (recommended)

### 2. Register Your App with Firebase

#### For Android:

1. In the Firebase console, click on your project
2. Click the Android icon (⚙️) to add an Android app
3. Enter your package name: `com.hereco.tales` (or your custom package name)
4. Enter a nickname for your app (optional)
5. Enter your SHA-1 key if you plan to use Google Sign-In (recommended)
6. Click "Register app"
7. Download the `google-services.json` file
8. Place the file in the `android/app/` directory of your Flutter project

#### For iOS:

1. In the Firebase console, click on your project
2. Click the iOS icon (⚙️) to add an iOS app
3. Enter your Bundle ID (found in your Xcode project)
4. Enter a nickname for your app (optional)
5. Click "Register app"
6. Download the `GoogleService-Info.plist` file
7. Place the file in the `ios/Runner/` directory of your Flutter project

### 3. Enable Authentication Methods

1. In the Firebase console, go to "Authentication" > "Sign-in method"
2. Enable the authentication methods you want to use:
   - Email/Password
   - Google Sign-In
   - Anonymous
   - Phone (if needed)

### 4. Set Up Firestore Database

1. In the Firebase console, go to "Firestore Database"
2. Click "Create database"
3. Choose either production mode or test mode (you can change this later)
4. Select a location for your database (choose the closest to your users)
5. Click "Enable"

### 5. Set Up Firestore Security Rules

Replace the default security rules with these rules that allow authenticated users to access only their own data:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /notes/{noteId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

## Using the Template

If you don't want to create a Firebase project, you can use the template file for development:

1. Copy `android/app/google-services.json.template` to `android/app/google-services.json`
2. Replace the placeholder values with your actual Firebase project values

## Troubleshooting

- If you encounter build errors, make sure you've placed the configuration files in the correct directories
- Ensure you've added the correct dependencies in your `pubspec.yaml` file
- Check that Firebase is properly initialized in your `main.dart` file

## Notes

- The app is configured to work offline when Firebase is not available
- Notes will sync automatically when the user signs in
- Local notes are preserved even when the user is not signed in