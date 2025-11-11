# Reviewer Guide - MovieFlix

## Quick Start for Reviewers

This guide helps you quickly evaluate the MovieFlix iOS application.

## 1. Initial Setup (2 minutes)

### Get TMDB API Key
1. Visit: https://www.themoviedb.org/settings/api
2. Sign in or create a free account
3. Request an API key (Developer option)
4. Copy the API Key (v3 auth)

### Configure Project
1. Open `MovieFlix.xcodeproj` in Xcode
2. Navigate to `MovieFlix/Config.swift`
3. Replace `YOUR_API_KEY_HERE` with your API key
4. Build and Run (⌘R)

## 2. Features to Test (10 minutes)

### Home Screen (UIKit) ✓

| Feature | How to Test | Expected Result |
|---------|------------|-----------------|
| Popular Movies | Launch app | Grid of movies with images, titles, dates, ratings |
| Infinite Scroll | Scroll to bottom | More movies load automatically |
| Pull to Refresh | Pull down from top | List refreshes, returns to page 1 |
| Search | Tap search, type "Avengers" | Results appear as you type |
| Search Scroll | Scroll in search results | More search results load |
| Favorite Toggle | Tap heart icon on any movie | Icon fills/unfills, persists on scroll |
| Skeleton Loader | Pull to refresh or first load | Gray shimmer placeholders appear |

### Detail Screen (SwiftUI) ✓

| Feature | How to Test | Expected Result |
|---------|------------|-----------------|
| Navigation | Tap any movie | Detail screen opens |
| Movie Info | View detail screen | Title, genres, date, runtime, rating visible |
| Favorite | Tap heart icon | Toggles favorite status |
| Description | Scroll down | Movie overview/description shown |
| Cast | Scroll to cast section | Circular profile images, names, characters |
| Reviews | Scroll to reviews | Up to 2 reviews displayed |
| Similar Movies | Scroll to bottom | Horizontal scrollable movie list |
| Share Button | Look at top-right | Share icon (if movie has homepage) |
| Share Function | Tap share icon | iOS share sheet appears |

### Persistence ✓

| Feature | How to Test | Expected Result |
|---------|------------|-----------------|
| Favorite Persistence | 1. Mark movie as favorite<br>2. Kill app<br>3. Relaunch | Favorite status retained |

## 3. Code Review Focus Areas (15 minutes)

### Architecture
- **File:** All files
- **Check:** Clean MVVM structure, proper separation of concerns
- **Location:** Models/, Views/, ViewControllers/, Managers/

### UIKit Implementation
- **File:** `HomeViewController.swift`
- **Check:** Infinite scroll, pull-to-refresh, search with debouncing
- **Lines:** 150-180 (infinite scroll), 80-100 (search debouncing)

### SwiftUI Implementation
- **File:** `MovieDetailView.swift`
- **Check:** SwiftUI views, @Published properties, ObservableObject
- **Lines:** Full file demonstrates SwiftUI proficiency

### Networking
- **File:** `NetworkManager.swift`
- **Check:** Generic request handler, error handling, thread safety
- **Lines:** 60-100 (generic performRequest method)

### Parallel API Calls
- **File:** `MovieDetailView.swift` (MovieDetailViewModel)
- **Check:** DispatchGroup usage, separate calls for reviews/similar
- **Lines:** 180-220 (loadMovieDetails method)
- **Important:** Reviews and similar movies NOT using append_to_response

### Graceful Degradation
- **File:** `MovieDetailView.swift`
- **Check:** Screen loads even if reviews/similar movies fail
- **Lines:** 180-220 (non-critical data handling)

### Image Caching
- **File:** `ImageLoader.swift`
- **Check:** NSCache implementation, Combine usage
- **Lines:** Full file

### Skeleton Loading
- **File:** `SkeletonView.swift`
- **Check:** Both UIKit and SwiftUI implementations
- **Lines:** Full file

### Favorites Persistence
- **File:** `FavoritesManager.swift`
- **Check:** UserDefaults, Set-based storage
- **Lines:** Full file

## 4. Assignment Requirements Verification

### Core Requirements ✓

- [x] **iOS 14+**: Check `Info.plist` or project settings
- [x] **Swift 5+**: Check any Swift file
- [x] **No External Libraries**: Check project (no Pods, SPM, Carthage)
- [x] **Home in UIKit**: `HomeViewController.swift`
- [x] **Details in SwiftUI**: `MovieDetailView.swift`

### Features ✓

- [x] **Popular Movies**: Test on launch
- [x] **Infinite Scroll**: Scroll down in home screen
- [x] **Pull-to-Refresh**: Pull down gesture
- [x] **Search**: Type in search bar
- [x] **Favorites**: Tap heart, restart app
- [x] **Skeleton Loader**: Visible during loading

### Detail Screen ✓

- [x] **All Fields Present**: Image, title, genres, date, runtime, rating, description, cast, reviews, similar
- [x] **Share Button**: Visible (when homepage exists)
- [x] **Favorite Toggle**: Works on detail screen
- [x] **Parallel Calls**: Check code in `MovieDetailViewModel.loadMovieDetails()`
- [x] **No append_to_response**: Reviews and similar use separate endpoints
- [x] **Graceful Degradation**: Screen loads without reviews/similar

## 5. Code Quality Checklist

### Best Practices ✓
- [x] `[weak self]` in closures (check NetworkManager callbacks)
- [x] Main thread UI updates (check DispatchQueue.main.async)
- [x] Error handling (check NetworkError enum)
- [x] Memory management (NSCache, proper cleanup)
- [x] Code organization (logical folder structure)

### Performance ✓
- [x] Image caching (ImageLoader)
- [x] Efficient scrolling (cell reuse)
- [x] Debounced search (0.5s delay)
- [x] Parallel requests (DispatchGroup)

## 6. Common Issues & Solutions

### Issue: "Invalid API Key"
- **Cause:** API key not configured
- **Solution:** Check Config.swift has valid TMDB API key

### Issue: Images not loading
- **Cause:** Network/API key issue
- **Solution:** Verify API key, check internet connection

### Issue: Simulator won't launch
- **Solution:** Clean build folder (⌘⇧K), restart Xcode

## 7. Evaluation Criteria

### Technical Implementation (40%)
- Clean architecture
- Proper use of UIKit and SwiftUI
- Networking layer implementation
- Error handling

### Features Completeness (30%)
- All required features work
- Infinite scroll, search, favorites
- Detail screen with all fields
- Share functionality

### Code Quality (20%)
- Best practices
- Memory management
- Performance optimization
- Code organization

### UI/UX (10%)
- Skeleton loading
- Smooth interactions
- Error states
- Visual polish

## 8. Expected Results Summary

### What Works ✓
- Popular movies list with pagination
- Real-time search with pagination
- Pull-to-refresh
- Infinite scrolling (both modes)
- Favorite persistence across launches
- Detail screen with full information
- Parallel API calls (details, reviews, similar)
- Share functionality
- Skeleton loading animations
- Image caching
- Error handling

### Architecture Highlights ✓
- MVVM pattern
- Clean separation of concerns
- Reusable components
- Singleton managers
- Protocol-based delegation
- Generic networking layer

### Performance Features ✓
- Image caching (NSCache)
- Debounced search
- Efficient scrolling
- Parallel API requests
- Memory-conscious design

## 9. Time Estimates

- **Setup & Build:** 2 minutes
- **Feature Testing:** 10 minutes
- **Code Review:** 15 minutes
- **Architecture Review:** 10 minutes
- **Total:** ~35-40 minutes

## 10. Quick Assessment

If you only have 5 minutes:

1. ✓ **Build and run** - Does it work?
2. ✓ **Scroll down** - Infinite scroll working?
3. ✓ **Pull to refresh** - Refresh working?
4. ✓ **Search** - Real-time search working?
5. ✓ **Tap a movie** - Detail screen appears?
6. ✓ **Tap heart** - Favorites working?
7. ✓ **Check code** - Clean architecture?

## Contact

For questions about the implementation:
- **Developer:** Petros Dhespollari
- **Assignment:** ATCOM iOS Developer Position
- **Date:** November 2025

---

**Thank you for reviewing MovieFlix!** 🎬
