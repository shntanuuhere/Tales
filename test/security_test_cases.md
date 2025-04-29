# Security Test Cases for Tales App

## API Key Security

### TC-S-001: Verify API Key Storage
1. Install the app
2. Use a file explorer or debugging tool to examine app storage
3. Search for the Unsplash API key in plain text
4. Check shared preferences, databases, and files

**Expected Result**: API key should not be found in plain text in any storage location.

### TC-S-002: Verify API Key Protection in Network Requests
1. Install the app
2. Set up a proxy tool (e.g., Charles Proxy, Fiddler)
3. Configure the device to use the proxy
4. Launch the app and browse wallpapers
5. Capture and examine network requests

**Expected Result**: API key should be properly included in requests but not exposed in URLs.

### TC-S-003: Verify API Key Rotation
1. Change the API key in the secure storage
2. Restart the app
3. Browse wallpapers
4. Verify the app uses the new API key

**Expected Result**: App should use the updated API key without requiring reinstallation.

## Certificate Pinning

### TC-S-004: Verify Certificate Pinning Implementation
1. Set up a proxy tool with SSL interception
2. Configure the device to trust the proxy's certificate
3. Launch the app
4. Attempt to browse wallpapers
5. Observe if the app rejects the connection

**Expected Result**: App should reject the connection due to certificate pinning.

### TC-S-005: Verify Certificate Pinning Bypass in Debug Mode
1. Build the app in debug mode
2. Set up a proxy tool with SSL interception
3. Configure the device to trust the proxy's certificate
4. Launch the app
5. Attempt to browse wallpapers

**Expected Result**: App should allow the connection in debug mode for development purposes.

### TC-S-006: Verify Certificate Pinning with Valid Certificate
1. Build the app in release mode
2. Launch the app without any proxy
3. Attempt to browse wallpapers

**Expected Result**: App should establish a secure connection and load wallpapers.

## Secure Storage

### TC-S-007: Verify Secure Storage Encryption
1. Install the app
2. Use the app to store sensitive information (e.g., API key)
3. Use a root-enabled device or emulator
4. Attempt to access the secure storage location
5. Examine the stored data

**Expected Result**: Stored data should be encrypted and not readable in plain text.

### TC-S-008: Verify Secure Storage Access Control
1. Install the app
2. Use a different app or ADB shell
3. Attempt to access the secure storage location used by the app

**Expected Result**: Other apps or processes should not be able to access the secure storage.

### TC-S-009: Verify Secure Storage Persistence
1. Install the app
2. Use the app to store sensitive information
3. Force stop the app
4. Restart the app
5. Verify the sensitive information is still available

**Expected Result**: Sensitive information should persist across app restarts.

## Data Protection

### TC-S-010: Verify Wallpaper Download Security
1. Download a wallpaper using the app
2. Check the storage location of the downloaded wallpaper
3. Verify the permissions on the file

**Expected Result**: Downloaded wallpapers should be stored in a location accessible only to the app or in shared media storage with appropriate permissions.

### TC-S-011: Verify Favorites Data Protection
1. Add several wallpapers to favorites
2. Use a file explorer or debugging tool
3. Locate the favorites data storage
4. Examine the data protection mechanisms

**Expected Result**: Favorites data should be stored securely with appropriate access controls.

### TC-S-012: Verify Cache Security
1. Use the app to browse wallpapers
2. Locate the cache storage
3. Examine the cache protection mechanisms

**Expected Result**: Cache should be stored with appropriate access controls and not contain sensitive information.

## Network Security

### TC-S-013: Verify HTTPS Usage
1. Set up a network monitoring tool
2. Launch the app
3. Browse wallpapers
4. Capture and examine network traffic

**Expected Result**: All network communication should use HTTPS.

### TC-S-014: Verify Network Error Handling
1. Enable airplane mode
2. Launch the app
3. Attempt to browse wallpapers
4. Observe error handling

**Expected Result**: App should handle network errors gracefully without exposing sensitive information.

### TC-S-015: Verify API Response Validation
1. Set up a proxy tool
2. Intercept and modify API responses
3. Send malformed or unexpected data
4. Observe how the app handles the modified responses

**Expected Result**: App should validate API responses and handle unexpected data gracefully.

## Authentication and Authorization

### TC-S-016: Verify Firebase Authentication
1. Sign in to the app using Firebase authentication
2. Examine the authentication token storage
3. Verify token expiration handling
4. Test token refresh mechanism

**Expected Result**: Authentication tokens should be stored securely and refreshed appropriately.

### TC-S-017: Verify Access Control
1. Sign in with different user accounts
2. Attempt to access user-specific data
3. Verify that users can only access their own data

**Expected Result**: App should enforce proper access control based on user authentication.

### TC-S-018: Verify Logout Functionality
1. Sign in to the app
2. Log out
3. Verify that authentication tokens are removed
4. Attempt to access authenticated features

**Expected Result**: After logout, authentication tokens should be removed and authenticated features should be inaccessible.

## Privacy

### TC-S-019: Verify Privacy Policy Accessibility
1. Launch the app
2. Navigate to the privacy policy
3. Verify the privacy policy is accessible and readable

**Expected Result**: Privacy policy should be easily accessible and readable.

### TC-S-020: Verify Data Collection Consent
1. Install the app for the first time
2. Observe if consent for data collection is requested
3. Verify that consent preferences are stored

**Expected Result**: App should request consent for data collection and respect user preferences.

### TC-S-021: Verify Analytics Opt-Out
1. Navigate to settings
2. Locate analytics opt-out option
3. Disable analytics
4. Verify that analytics data is not collected

**Expected Result**: App should provide an option to opt out of analytics and respect this preference.
