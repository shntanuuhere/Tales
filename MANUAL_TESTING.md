# Tales App Manual Testing Checklist

## Installation and Startup
- [ ] App installs correctly on Android
- [ ] App installs correctly on iOS
- [ ] App launches without crashes
- [ ] Splash screen displays correctly
- [ ] App transitions smoothly to the home screen

## Home Screen
- [ ] Wallpaper grid loads correctly
- [ ] Images load with proper resolution
- [ ] Scrolling is smooth
- [ ] Pull-to-refresh works
- [ ] Infinite scrolling loads more wallpapers
- [ ] Category tabs display correctly
- [ ] Switching between categories works
- [ ] Search icon is visible and functional

## Navigation
- [ ] Bottom navigation bar is visible
- [ ] Home tab works
- [ ] Categories tab works
- [ ] Favorites tab works
- [ ] Settings tab works
- [ ] Navigation between tabs is smooth

## Categories Screen
- [ ] All categories are displayed
- [ ] Category images load correctly
- [ ] Tapping a category shows wallpapers for that category
- [ ] Back button returns to categories list

## Wallpaper Detail Screen
- [ ] Wallpaper loads in full resolution
- [ ] Photographer name is displayed
- [ ] Download button works
- [ ] Set wallpaper button works
- [ ] Favorite button works
- [ ] Share button works
- [ ] Back button returns to previous screen

## Wallpaper Setting (Android)
- [ ] Set as home screen option works
- [ ] Set as lock screen option works
- [ ] Set as both option works
- [ ] Success message appears after setting

## Wallpaper Saving (iOS)
- [ ] Save to Photos option works
- [ ] Instructions for setting wallpaper appear
- [ ] Success message appears after saving
- [ ] Open Photos button works

## Favorites
- [ ] Adding to favorites works
- [ ] Removing from favorites works
- [ ] Favorites persist after app restart
- [ ] Favorites screen shows all favorited wallpapers
- [ ] Empty state shows when no favorites

## Search
- [ ] Search bar accepts input
- [ ] Search results appear for valid queries
- [ ] No results message for invalid queries
- [ ] Search history is saved
- [ ] Clear search works

## Settings
- [ ] All settings options are displayed
- [ ] Dark mode toggle works
- [ ] Notification settings work
- [ ] Cache clearing works
- [ ] About section displays app info

## Offline Mode
- [ ] App shows offline indicator when no connection
- [ ] Previously loaded wallpapers are accessible offline
- [ ] Appropriate error messages for actions requiring connection
- [ ] App reconnects automatically when connection restored

## Performance
- [ ] App loads quickly
- [ ] Transitions are smooth
- [ ] No lag when scrolling through wallpapers
- [ ] Image loading is optimized
- [ ] Memory usage is reasonable

## Error Handling
- [ ] Appropriate error messages for API failures
- [ ] Retry options for failed operations
- [ ] No uncaught exceptions
- [ ] Graceful degradation when features unavailable

## Cross-Platform Consistency
- [ ] UI looks consistent on Android and iOS
- [ ] All features work on both platforms
- [ ] Platform-specific behaviors are implemented correctly
- [ ] Adaptive UI for different screen sizes

## Accessibility
- [ ] Text is readable at different font sizes
- [ ] Color contrast meets accessibility standards
- [ ] Screen reader compatibility
- [ ] Touch targets are appropriately sized

## Permissions
- [ ] Storage permission request works (Android)
- [ ] Photo library permission request works (iOS)
- [ ] App functions properly when permissions granted
- [ ] Appropriate messaging when permissions denied

## Security
- [ ] API keys are not exposed
- [ ] Network requests use HTTPS
- [ ] No sensitive data stored unencrypted
- [ ] App works with certificate pinning enabled

## Localization
- [ ] All text is properly localized
- [ ] Date formats are appropriate for locale
- [ ] RTL layout works if supported
- [ ] No hardcoded strings visible to users

## Edge Cases
- [ ] App handles device rotation
- [ ] App handles interruptions (calls, notifications)
- [ ] App recovers from background state
- [ ] App handles low memory conditions
- [ ] App handles slow network conditions
