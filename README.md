# Tales - A Beautiful Wallpaper App

Tales is a modern, lightweight, and elegantly designed wallpaper app built with Flutter using clean architecture principles. It provides a seamless experience for users who want to personalize their devices with high-quality wallpapers.

<p align="center">
  <img src="assets/logo/tales.png" width="120" alt="Tales Logo">
</p>

## Features

### Wallpapers
- Browse high-quality wallpapers from Unsplash API
- Set as home screen or lock screen
- Download for offline use
- Save favorites
- Browse by categories
- Like wallpapers you enjoy

### User Experience
- Beautiful, minimalist design
- Dark and light theme support
- Responsive layout for all devices
- Custom animations and transitions
- Offline support

### Security
- Firebase Authentication
- Secure cloud data storage

## Architecture

The app follows clean architecture principles with a feature-based approach:

```
lib/
  ├── core/                   # Core utilities and common functionality
  │   ├── constants/          # App constants
  │   ├── errors/             # Error handling
  │   ├── network/            # Network utilities
  │   └── utils/              # General utilities
  ├── features/               # Feature modules
  │   ├── wallpapers/         # Wallpaper feature
  │   ├── categories/         # Categories feature
  │   ├── auth/               # Authentication feature
  │   └── settings/           # Settings feature
  ├── data/                   # Data layer
  ├── domain/                 # Domain layer
  ├── presentation/           # Presentation layer
  ├── di/                     # Dependency injection
  └── main.dart               # Entry point
```

For more details on the architecture, see [CODEBASE_STRUCTURE.md](CODEBASE_STRUCTURE.md).

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio or Xcode
- Firebase account

### Installation
1. Clone the repository
   ```bash
   git clone https://github.com/hereco/tales.git
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Set up Firebase
   Follow the instructions in `FIREBASE_SETUP.md`

4. Run the app
   ```bash
   flutter run
   ```

## App Store Links
- [Google Play Store](https://play.google.com/store/apps/details?id=com.hereco.tales)
- [Apple App Store](https://apps.apple.com/app/tales-podcast-notes/id1234567890)

## Tech Stack
- Flutter
- Firebase (Authentication, Firestore)
- Provider for state management
- Get_it for dependency injection
- Clean Architecture principles
- CachedNetworkImage for efficient image loading
- permission_handler for device permissions
- wallpaper_manager_plus for setting wallpapers
- connectivity_plus for network monitoring

## Contributing
Contributions are welcome! Please read `CONTRIBUTING.md` for details on our code of conduct and the process for submitting pull requests.

## License
This project is licensed under the Apache License 2.0 - see the `LICENSE` file for details.

## Privacy Policy
See `PRIVACY_POLICY.md` for information on how user data is handled.

## Contact
For support or inquiries, please contact us at support@herecotales.com

## Acknowledgments
- [Flutter Team](https://flutter.dev/)
- All open-source libraries used in this project
- Our beta testers and early users
