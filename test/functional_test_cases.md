# Functional Test Cases for Tales App

## Wallpaper Browsing

### TC-F-001: Browse Wallpapers
1. Launch the app
2. Navigate to the Wallpapers screen
3. Verify wallpapers are displayed in a grid
4. Scroll down to load more wallpapers
5. Verify more wallpapers are loaded

**Expected Result**: Wallpapers should load and display correctly. Scrolling should load more wallpapers.

### TC-F-002: Filter Wallpapers by Category
1. Launch the app
2. Navigate to the Categories screen
3. Select a category
4. Verify wallpapers related to the selected category are displayed

**Expected Result**: Only wallpapers from the selected category should be displayed.

### TC-F-003: Search Wallpapers
1. Launch the app
2. Tap on the search icon
3. Enter a search term
4. Verify search results are displayed

**Expected Result**: Wallpapers matching the search term should be displayed.

## Wallpaper Details

### TC-F-004: View Wallpaper Details
1. Launch the app
2. Select a wallpaper
3. Verify wallpaper details screen opens
4. Check that photographer name, category, and resolution are displayed

**Expected Result**: Wallpaper details should be displayed correctly.

### TC-F-005: Download Wallpaper
1. Launch the app
2. Select a wallpaper
3. Tap on the download button
4. Verify download progress is displayed
5. Verify download completion notification

**Expected Result**: Wallpaper should download successfully and be saved to the device.

### TC-F-006: Set Wallpaper
1. Launch the app
2. Select a wallpaper
3. Tap on the set wallpaper button
4. Select an option (home screen, lock screen, or both)
5. Verify success message

**Expected Result**: Wallpaper should be set as the device wallpaper according to the selected option.

### TC-F-007: Add to Favorites
1. Launch the app
2. Select a wallpaper
3. Tap on the favorite button
4. Navigate to the Favorites screen
5. Verify the wallpaper is in the favorites list

**Expected Result**: Wallpaper should be added to favorites and appear in the favorites list.

### TC-F-008: Remove from Favorites
1. Launch the app
2. Navigate to the Favorites screen
3. Select a wallpaper
4. Tap on the favorite button to unfavorite
5. Verify the wallpaper is removed from the favorites list

**Expected Result**: Wallpaper should be removed from favorites.

## Navigation

### TC-F-009: Navigate Between Screens
1. Launch the app
2. Navigate to each main screen (Wallpapers, Categories, Favorites)
3. Verify correct screen is displayed
4. Use back button to return to previous screens

**Expected Result**: Navigation between screens should work correctly.

### TC-F-010: Open and Close Drawer
1. Launch the app
2. Swipe from left edge or tap hamburger icon to open drawer
3. Verify drawer opens with all menu items
4. Tap outside drawer or back button to close
5. Verify drawer closes

**Expected Result**: Drawer should open and close correctly.

## Settings and Preferences

### TC-F-011: Toggle Theme
1. Launch the app
2. Open the drawer
3. Tap on the theme toggle icon
4. Verify theme changes between light and dark

**Expected Result**: App theme should toggle between light and dark mode.

### TC-F-012: View Privacy Policy
1. Launch the app
2. Open the drawer
3. Tap on Privacy Policy
4. Verify privacy policy screen opens with content

**Expected Result**: Privacy policy should be displayed correctly.

### TC-F-013: View About Information
1. Launch the app
2. Open the drawer
3. Tap on About
4. Verify about dialog opens with app information

**Expected Result**: About dialog should display correct app information.

### TC-F-014: Send Feedback
1. Launch the app
2. Open the drawer
3. Tap on Send Feedback
4. Enter feedback text
5. Submit feedback
6. Verify success message

**Expected Result**: Feedback should be submitted successfully.

### TC-F-015: Manage Cache
1. Launch the app
2. Open the drawer
3. Tap on Cache Settings
4. View cache information
5. Clear cache
6. Verify cache is cleared

**Expected Result**: Cache information should be displayed and cache should be cleared when requested.

## Error Handling

### TC-F-016: Handle Network Errors
1. Enable airplane mode or disconnect from network
2. Launch the app
3. Verify offline indicator is displayed
4. Attempt to browse wallpapers
5. Verify appropriate error message or offline content

**Expected Result**: App should handle network errors gracefully and display offline content when available.

### TC-F-017: Handle API Errors
1. Launch the app
2. Modify API key to be invalid (for testing purposes)
3. Restart the app
4. Attempt to browse wallpapers
5. Verify appropriate error message

**Expected Result**: App should handle API errors gracefully and display appropriate error messages.

### TC-F-018: Handle Permission Errors
1. Launch the app
2. Deny storage permission when prompted
3. Attempt to download a wallpaper
4. Verify appropriate error message

**Expected Result**: App should handle permission errors gracefully and display appropriate error messages.
