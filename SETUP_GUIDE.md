# Quick Setup Guide - MovieFlix

## Before You Start

You need a TMDB API key to run this application. The API is free for non-commercial use.

## Step 1: Get Your TMDB API Key

1. Go to https://www.themoviedb.org/
2. Sign up for a free account (or sign in if you have one)
3. Go to your account settings: https://www.themoviedb.org/settings/api
4. Click "Request an API Key"
5. Choose "Developer" option
6. Fill in the required information:
   - Application Name: MovieFlix (or any name)
   - Application URL: http://localhost (for testing)
   - Application Summary: iOS movie browser app
7. Accept the terms and submit
8. Copy your **API Key (v3 auth)**

## Step 2: Add Your API Key to the Project

1. Open the project in Xcode
2. Navigate to: `MovieFlix/Config.swift`
3. Find this line:
   ```swift
   static let apiKey = "YOUR_API_KEY_HERE"
   ```
4. Replace `YOUR_API_KEY_HERE` with your actual API key:
   ```swift
   static let apiKey = "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
   ```

## Step 3: Run the App

1. In Xcode, select a simulator or device:
   - Recommended: iPhone 14 Pro or newer
   - Minimum: iOS 14.0+
2. Press `Cmd + R` or click the Play button
3. The app should build and launch
4. You should see a list of popular movies on the home screen

## Troubleshooting

### Problem: "Invalid API Key" error
- **Solution**: Double-check that you copied the entire API key correctly in Config.swift
- Make sure there are no extra spaces or quotes

### Problem: Build fails with missing files
- **Solution**: Make sure all files are included in the Xcode project
- Try cleaning the build folder: Product > Clean Build Folder (Cmd + Shift + K)

### Problem: Simulator won't launch
- **Solution**:
  - Restart Xcode
  - Delete and reinstall the app from the simulator
  - Try a different simulator device

### Problem: Images not loading
- **Solution**:
  - Check your internet connection
  - Make sure the API key is valid
  - Check that the TMDB image service is not blocked

## Testing the Features

Once the app is running, try these features:

1. **Scroll down** - Should load more movies automatically (infinite scroll)
2. **Pull down** - Should refresh the movie list
3. **Tap the search icon** - Search for a movie (e.g., "Avengers")
4. **Tap a movie** - Should show detailed information
5. **Tap the heart icon** - Mark/unmark as favorite
6. **Tap the share icon** (on detail page) - Share movie URL

## Project Structure Overview

```
MovieFlix/
├── Config.swift              ← ADD YOUR API KEY HERE!
├── Models/                   - Data models
├── Views/                    - UI components
├── ViewControllers/          - UIKit screens
├── Managers/                 - Business logic
└── Utilities/                - Helper classes
```

## Support

If you encounter any issues:
1. Check that your API key is valid and correctly added
2. Make sure you're running iOS 14.0 or higher
3. Verify your internet connection
4. Clean and rebuild the project

## API Key Security Note

**Important**: Never commit your API key to a public repository!
- The API key should remain private
- For production apps, use more secure storage methods
- Consider using environment variables or a secrets manager

---

Enjoy exploring movies with MovieFlix! 🎬
