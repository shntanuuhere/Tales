# Tales App Manual Testing Checklist

## Installation and Setup

- [ ] App installs correctly on a clean device
- [ ] App launches without crashes
- [ ] Splash screen displays correctly
- [ ] Initial permissions are requested appropriately
- [ ] App works correctly on first launch without internet connection

## Core Functionality

### Wallpaper Browsing

- [ ] Wallpapers load correctly on the home screen
- [ ] Infinite scrolling works to load more wallpapers
- [ ] Wallpaper thumbnails display with correct aspect ratio
- [ ] Tapping a wallpaper opens the detail screen
- [ ] Pull-to-refresh updates the wallpaper list

### Categories

- [ ] Categories screen displays all categories
- [ ] Category thumbnails load correctly
- [ ] Tapping a category shows wallpapers from that category
- [ ] "All" category shows wallpapers from all categories
- [ ] Categories work correctly in offline mode

### Wallpaper Details

- [ ] Wallpaper displays in full screen
- [ ] Photographer name and category are displayed
- [ ] Download button works correctly
- [ ] Set wallpaper options work correctly
- [ ] Favorite button toggles correctly
- [ ] Info button shows correct wallpaper information
- [ ] Unsplash attribution is displayed correctly

### Favorites

- [ ] Adding to favorites works correctly
- [ ] Favorites persist after app restart
- [ ] Removing from favorites works correctly
- [ ] Favorites screen displays all favorited wallpapers
- [ ] Empty state is displayed when no favorites exist

### Downloads

- [ ] Downloaded wallpapers are saved correctly
- [ ] Downloads screen shows all downloaded wallpapers
- [ ] Downloaded wallpapers can be viewed offline
- [ ] Downloaded wallpapers can be set as device wallpaper
- [ ] Downloaded wallpapers can be shared

## UI/UX

- [ ] App follows Material Design guidelines
- [ ] Dark mode works correctly
- [ ] Light mode works correctly
- [ ] Theme switching is smooth
- [ ] Animations are smooth and not jarring
- [ ] Loading indicators display appropriately
- [ ] Error states are handled gracefully
- [ ] Empty states are displayed appropriately
- [ ] Text is readable on all screens
- [ ] UI is responsive on different screen sizes
- [ ] UI adapts correctly to orientation changes

## Navigation

- [ ] Bottom navigation works correctly
- [ ] Drawer opens and closes smoothly
- [ ] All drawer menu items work correctly
- [ ] Back button behavior is consistent
- [ ] Deep linking works correctly (if implemented)
- [ ] Navigation history is preserved correctly

## Network and Offline Functionality

- [ ] App works correctly on WiFi
- [ ] App works correctly on mobile data
- [ ] App shows offline indicator when offline
- [ ] Previously viewed content is available offline
- [ ] App recovers gracefully when connection is restored
- [ ] App optimizes data usage on metered connections

## Performance

- [ ] App starts quickly
- [ ] Scrolling is smooth
- [ ] Image loading is optimized
- [ ] Memory usage is reasonable
- [ ] Battery usage is reasonable
- [ ] App remains responsive during intensive operations
- [ ] App doesn't overheat the device

## Security

- [ ] API key is stored securely
- [ ] Certificate pinning works correctly
- [ ] Sensitive data is encrypted
- [ ] App doesn't expose sensitive information in logs
- [ ] Privacy policy is accessible
- [ ] App respects user permissions

## Compatibility

- [ ] App works on Android 8.0+
- [ ] App works on iOS 13.0+ (if applicable)
- [ ] App works on different device manufacturers
- [ ] App works with different system font sizes
- [ ] App works with system dark mode

## Localization and Accessibility

- [ ] All text is properly localized
- [ ] App supports right-to-left languages (if applicable)
- [ ] App works with screen readers
- [ ] App has sufficient color contrast
- [ ] Touch targets are large enough
- [ ] App works with keyboard navigation

## Edge Cases

- [ ] App handles device rotation correctly
- [ ] App handles interruptions (calls, notifications) gracefully
- [ ] App handles low storage space gracefully
- [ ] App handles low memory conditions gracefully
- [ ] App handles slow network conditions gracefully
- [ ] App handles unexpected API responses gracefully

## Final Verification

- [ ] All critical and major bugs are fixed
- [ ] App meets all store requirements
- [ ] App has appropriate content rating
- [ ] App has privacy policy
- [ ] App has terms of service
- [ ] App attribution is correct
- [ ] App version and build number are correct
- [ ] App icon and splash screen are correct
- [ ] App name and description are correct
