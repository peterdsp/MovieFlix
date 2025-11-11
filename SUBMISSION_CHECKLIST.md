# MovieFlix - Submission Checklist

## Pre-Submission Checklist

Before submitting your project, please verify the following:

### ✅ Project Configuration

- [x] Xcode project builds successfully
- [x] Deployment target set to iOS 14.0
- [x] Swift version 5.0 or higher
- [x] No external dependencies (only Apple frameworks)
- [x] Bundle identifier configured
- [x] App icon placeholder exists
- [x] LaunchScreen configured

### ✅ Core Features - Home Screen (UIKit)

- [x] Popular movies list displays correctly
- [x] Movie cells show: title, backdrop image, date, rating, favorite button
- [x] Infinite scrolling works (loads more movies when scrolling near bottom)
- [x] Pull-to-refresh functionality works
- [x] Search bar appears and accepts input
- [x] Real-time search works as user types
- [x] Search results support infinite scrolling
- [x] Favorite button toggles correctly
- [x] Favorites persist after app restart

### ✅ Core Features - Detail Screen (SwiftUI)

- [x] Navigation from home to detail works
- [x] Displays: backdrop image, poster, title, genres, date, runtime
- [x] Star rating displays correctly
- [x] Favorite button works on detail screen
- [x] Description/overview displays
- [x] Cast members display with images
- [x] Reviews display (up to 2)
- [x] Similar movies display in horizontal scroll
- [x] Share button appears (when homepage exists)
- [x] Share button hidden (when homepage is null)
- [x] Share functionality works with native iOS share sheet

### ✅ Technical Requirements

- [x] Home screen implemented in UIKit
- [x] Detail screen implemented in SwiftUI
- [x] No append_to_response used for reviews/similar movies
- [x] Reviews and similar movies loaded via separate API calls
- [x] Parallel API calls implemented (DispatchGroup)
- [x] Screen loads even if reviews/similar movies fail
- [x] Skeleton loader implemented and working
- [x] Skeleton loader works in both UIKit and SwiftUI
- [x] Portrait orientation only (landscape disabled)
- [x] No third-party libraries used

### ✅ API Integration

- [x] Popular movies endpoint integrated
- [x] Search movies endpoint integrated
- [x] Movie details endpoint integrated (with append_to_response=credits)
- [x] Movie reviews endpoint integrated (separate call)
- [x] Similar movies endpoint integrated (separate call)
- [x] Pagination works for popular movies
- [x] Pagination works for search results
- [x] API key configured in Config.swift
- [x] Images load from TMDB image CDN

### ✅ Data Persistence

- [x] Favorites saved to UserDefaults
- [x] Favorites persist after app termination
- [x] Favorites load correctly on app launch
- [x] Favorite status synced across screens

### ✅ UI/UX Polish

- [x] Loading indicators during data fetch
- [x] Skeleton views during initial load
- [x] Error handling with user-friendly messages
- [x] Smooth scrolling performance
- [x] Images cached for performance
- [x] No redundant network requests
- [x] Responsive UI during loading

### ✅ Code Quality

- [x] Clean code organization
- [x] Logical folder structure
- [x] Consistent naming conventions
- [x] Proper use of weak self in closures
- [x] Memory management considerations
- [x] Thread-safe UI updates
- [x] Error handling implemented
- [x] Code comments where necessary

### ✅ Documentation

- [x] README.md with setup instructions
- [x] SETUP_GUIDE.md for quick start
- [x] IMPLEMENTATION_SUMMARY.md with technical details
- [x] Code comments for complex logic
- [x] Clear instructions for API key setup

### ✅ Project Files

- [x] .gitignore configured
- [x] Info.plist configured
- [x] LaunchScreen.storyboard
- [x] Assets.xcassets
- [x] All Swift files included
- [x] Xcode project file (.xcodeproj)

## Before Submission

### Step 1: Add Your API Key

**IMPORTANT:** The reviewer will need their own TMDB API key.

1. Open `Config.swift`
2. Ensure the placeholder is clear:
   ```swift
   static let apiKey = "YOUR_API_KEY_HERE"
   ```
3. Include instructions in README (already done ✓)

### Step 2: Test the Project

1. **Clean the project:**
   - Product > Clean Build Folder (Cmd + Shift + K)

2. **Build the project:**
   - Product > Build (Cmd + B)
   - Verify no build errors

3. **Run on simulator:**
   - Select iPhone 14 Pro (or similar)
   - Run the app (Cmd + R)

4. **Test critical features:**
   - Popular movies load
   - Scroll to trigger infinite loading
   - Pull to refresh
   - Search for a movie
   - Tap a movie to view details
   - Toggle favorite status
   - Share a movie (if homepage exists)

### Step 3: Prepare for Submission

Choose one of the following methods:

#### Option A: Private GitHub Repository (Recommended)

1. Create a private GitHub repository
2. Initialize git in the project:
   ```bash
   cd MovieFlix
   git init
   git add .
   git commit -m "Initial commit - MovieFlix iOS app"
   ```
3. Push to GitHub:
   ```bash
   git remote add origin <your-repo-url>
   git push -u origin main
   ```
4. Invite `pavlos.papaiakovou@atcom.gr` as a collaborator

#### Option B: File Upload Service

1. **Archive the project:**
   - Close Xcode
   - Compress the MovieFlix folder
   - Name: `MovieFlix_PetrosDhespollari.zip`

2. **Upload to:**
   - WeTransfer
   - Google Drive
   - Dropbox

3. **Share link with:**
   - `stamatia.karampali@atcom.gr`

### Step 4: Email Submission

**To:** stamatia.karampali@atcom.gr
**CC:** pavlos.papaiakovou@atcom.gr (if appropriate)
**Subject:** MovieFlix iOS Assessment - Petros Dhespollari

**Email Template:**

```
Dear ATCOM Team,

Please find my submission for the iOS Developer position assessment.

Project: MovieFlix - Movie Browser Application

Submission Method: [GitHub Repository / File Upload Service]
Link: [Your link here]

Key Implementation Highlights:
- Home screen built with UIKit
- Detail screen built with SwiftUI
- All required features implemented
- Skeleton loading animations
- Persistent favorites storage
- Parallel API calls for optimal performance

Setup Instructions:
1. Open the project in Xcode
2. Add your TMDB API key to Config.swift
3. Build and run on iOS simulator or device (iOS 14+)

Detailed documentation is included in the README.md file.

Thank you for the opportunity. I look forward to discussing the implementation.

Best regards,
Petros Dhespollari
```

## Final Verification

Run through this checklist one final time:

- [ ] All required features work
- [ ] No build errors or warnings
- [ ] App runs smoothly on simulator
- [ ] Documentation is complete
- [ ] API key placeholder is clear
- [ ] No personal API key committed
- [ ] Project is properly compressed (if using file upload)
- [ ] GitHub repository is private (if using GitHub)
- [ ] Collaborator invited (if using GitHub)
- [ ] Email sent to correct address

## Submission Deadline

**Due:** Sunday, November 16, 2025 - End of Day

Make sure to submit before the deadline!

---

**Good luck with your submission!** 🎬
