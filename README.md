# Tales - A Simple and Elegant Notes Taking App

## Overview
Tales is a Flutter-based notes taking application with a clean and intuitive interface. It allows users to create, edit, and organize notes with a beautiful UI and seamless user experience.

## Features
- User authentication (Email/Password, Google Sign-in)
- Create and edit notes
- Biometric authentication for app access
- Dark/Light theme support
- Responsive design for various screen sizes

## Getting Started

### Prerequisites
- Flutter SDK (>=3.3.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase account

### Setup
1. Clone the repository
   ```
   git clone https://github.com/shntanuuhere/tales.git
   cd tales
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Firebase Configuration
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your Firebase project
   - Download the configuration files:
     - For Android: `google-services.json` (place in `android/app/`)
     - For iOS: `GoogleService-Info.plist` (place in `ios/Runner/`)

4. Spotify Integration (Optional)
   - Create a Spotify Developer account and register your app
   - Update the `spotify_auth_service.dart` file with your credentials

5. Run the app
   ```
   flutter run
   ```

## Project Structure
- `lib/main.dart` - Entry point of the application
- `lib/screens/` - UI screens
- `lib/services/` - Service classes for authentication, etc.
- `lib/models/` - Data models
- `lib/providers/` - State management
- `lib/theme/` - App theme configuration
- `lib/widgets/` - Reusable UI components

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- Flutter team for the amazing framework
- All the package authors used in this project
