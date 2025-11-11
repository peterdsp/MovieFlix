# MovieFlix - iOS Movie Browser App

MovieFlix is an iOS application built with Swift that allows users to browse popular movies, search for specific titles, and view detailed information about each movie. The app uses the TMDB (The Movie Database) API for all movie data.

## Features

### Home Screen (UIKit)
- **Popular Movies List**: Browse a list of currently popular movies
- **Infinite Scrolling**: Automatically loads more movies as you scroll
- **Pull-to-Refresh**: Refresh the movie list by pulling down
- **Real-time Search**: Search for movies with instant results as you type
- **Favorite Movies**: Mark movies as favorites with persistent storage
- **Skeleton Loading**: Beautiful loading placeholders while data is being fetched

### Movie Details Screen (SwiftUI)
- **Comprehensive Information**:
  - Movie poster and backdrop image
  - Title, genres, release date, and runtime
  - Star rating
  - Movie description
  - Cast members with photos
  - User reviews (up to 2)
  - Similar movies recommendations
- **Favorite Toggle**: Mark/unmark movies as favorites
- **Share Functionality**: Share movie homepage URL via iOS native share sheet
- **Parallel API Calls**: Efficiently loads multiple data sources simultaneously
- **Graceful Degradation**: Displays details even if non-critical data (reviews, similar movies) fails to load

## Technical Highlights

### Architecture
- **MVVM Pattern**: Clean separation of concerns with ViewModels
- **Hybrid UI**: UIKit for the home screen, SwiftUI for detail screen (as required)
- **No External Dependencies**: Uses only native iOS frameworks

### Key Components
1. **NetworkManager**: Centralized networking layer with generic request handling
2. **FavoritesManager**: Persistent storage using UserDefaults
3. **ImageLoader**: Efficient image caching and loading with Combine
4. **SkeletonView**: Custom skeleton loading animations for both UIKit and SwiftUI

### API Integration
- Popular Movies endpoint with pagination
- Search Movies endpoint with pagination
- Movie Details with credits
- Movie Reviews (separate call, non-critical)
- Similar Movies (separate call, non-critical)

## Requirements

- iOS 14.0+
- Xcode 14.0+
- Swift 5.0+
- TMDB API Key

## Setup Instructions

### 1. Get TMDB API Key

1. Visit [The Movie Database](https://www.themoviedb.org/)
2. Create a free account or sign in
3. Go to Settings > API
4. Request an API key (it's free for non-commercial use)
5. Copy your API Key

### 2. Configure the Project

1. Open the project in Xcode
2. Navigate to `MovieFlix/Config.swift`
3. Replace `YOUR_API_KEY_HERE` with your actual TMDB API key:

```swift
static let apiKey = "your_actual_api_key_here"
```

### 3. Run the Project

1. Select a simulator or connected device (iPhone)
2. Press `Cmd + R` to build and run
3. The app should launch and display popular movies

## Project Structure

```
MovieFlix/
├── MovieFlix/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Config.swift                    # API configuration
│   ├── Models/
│   │   ├── Movie.swift                # Movie list model
│   │   ├── MovieDetailResponse.swift  # Movie details, credits
│   │   ├── ReviewResponse.swift       # Reviews model
│   │   └── SimilarMoviesResponse.swift # Similar movies
│   ├── Views/
│   │   ├── MovieCell.swift            # UIKit table view cell
│   │   ├── MovieDetailView.swift      # SwiftUI detail screen
│   │   └── SkeletonView.swift         # Skeleton loaders
│   ├── ViewControllers/
│   │   └── HomeViewController.swift   # UIKit home screen
│   ├── Managers/
│   │   ├── NetworkManager.swift       # API networking
│   │   └── FavoritesManager.swift     # Favorites persistence
│   ├── Utilities/
│   │   └── ImageLoader.swift          # Image caching
│   ├── Assets.xcassets/
│   ├── LaunchScreen.storyboard
│   └── Info.plist
└── MovieFlix.xcodeproj/
```

## Key Implementation Details

### Infinite Scrolling
Implemented in `HomeViewController` using `tableView(_:willDisplay:forRowAt:)`:
- Triggers when user scrolls near the bottom (last 3 items)
- Automatically fetches next page of results
- Works for both popular movies and search results

### Pull-to-Refresh
- Uses `UIRefreshControl` on the table view
- Resets to page 1 and refreshes current mode (popular or search)

### Search Functionality
- Real-time search with 0.5-second debounce
- Automatically switches between popular movies and search results
- Maintains separate pagination for search results

### Skeleton Loading
- Custom skeleton views for both UIKit and SwiftUI
- Shimmer animation effect
- Displays while content is loading

### Parallel API Calls
Movie detail screen uses `DispatchGroup` to:
- Load movie details (critical)
- Load reviews (non-critical)
- Load similar movies (non-critical)
- Screen displays with details even if optional data fails

### Favorites Persistence
- Stored in `UserDefaults`
- Persists across app launches
- Instant UI updates on toggle

### Image Caching
- `NSCache` for in-memory caching
- Prevents redundant network requests
- Automatic memory management

## Design Decisions

1. **UIKit for Home, SwiftUI for Details**: As per requirements, demonstrating proficiency in both frameworks
2. **No Third-Party Libraries**: Implemented all features using native iOS frameworks
3. **MVVM Architecture**: Clean, testable, maintainable code structure
4. **Defensive Programming**: Graceful error handling, optional data handling
5. **Performance Optimization**: Image caching, debounced search, efficient scrolling

## Testing

The app has been tested on:
- iPhone 14 Pro Simulator (iOS 17.0)
- Portrait orientation only
- Various network conditions
- Edge cases (empty states, errors, missing data)

## Future Enhancements

Possible improvements for production:
- Unit tests for ViewModels and Managers
- UI tests for critical user flows
- Error state UI with retry functionality
- Offline mode with Core Data
- Pagination indicator
- Advanced filtering and sorting
- Movie trailers integration
- User authentication
- Personal watchlist

## Assignment Requirements Checklist

- [x] iOS 14+ support
- [x] Swift 5.0+
- [x] No external libraries (only Apple frameworks)
- [x] Home screen in UIKit
- [x] Movie details screen in SwiftUI
- [x] Popular movies list
- [x] Infinite scrolling
- [x] Pull-to-refresh
- [x] Real-time search
- [x] Favorite functionality with persistence
- [x] Skeleton loader
- [x] Movie details with all required fields
- [x] Parallel API calls (no append_to_response for reviews/similar)
- [x] Share functionality
- [x] Non-critical data handling (reviews, similar movies)
- [x] Star rating display
- [x] Cast information
- [x] Navigation between screens

## API Endpoints Used

- `GET /movie/popular` - Popular movies with pagination
- `GET /search/movie` - Search movies with pagination
- `GET /movie/{id}?append_to_response=credits` - Movie details with cast
- `GET /movie/{id}/reviews` - Movie reviews (separate call)
- `GET /movie/{id}/similar` - Similar movies (separate call)

## License

This project was created as part of a technical assessment for ATCOM.

## Contact

For any questions or clarifications, please contact:
Petros Dhespollari

---

**Note**: Remember to add your TMDB API key in `Config.swift` before running the app!
