# Event Finder iOS App

This project is an Event Finder iOS app built using Swift and SwiftUI. The app allows users to search for event information, ticketing details, save events as favorites, and share event details on social media. The backend service is powered by a Node.js script hosted on a cloud service.

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [Swift/SwiftUI Highlights](#swiftswiftui-highlights)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Usage](#usage)

## Features

- Event search with autocomplete suggestions
- Filter events by category, distance, and location
- Auto-detect user location option
- Display event details (artist, venue, genre, price, and ticket availability)
- Save events as favorites and manage them locally
- Share event details on Twitter and Facebook
- Interactive map to display event venues
- Fully responsive UI with smooth navigation and data updates
- Asynchronous HTTP requests to fetch event data from the backend

## Technologies Used

- **Swift**
- **SwiftUI**
- **CocoaPods** for dependency management
- **SF Symbols** for icons
- **Google Maps SDK** for displaying event venues on maps
- **Kingfisher** for image downloading and caching
- **Alamofire** for HTTP networking
- **UserDefaults** for local storage of favorites
- **Xcode 14.2**

## Project Structure

The project follows the Model-View-Controller (MVC) design pattern.
```
EventFinderApp/ ├── Models/ │ └── Event.swift ├── Views/ │ ├── SearchView.swift │ ├── EventDetailsView.swift │ ├── ArtistTabView.swift │ └── VenueTabView.swift ├── Controllers/ │ └── EventController.swift ├── Assets/ │ └── SF Symbols and Images └── Utilities/ └── NetworkManager.swift
```

## Swift/SwiftUI Highlights

### 1. SwiftUI-Based UI

- **Search Form**: Utilized `TextField`, `Picker`, and `Toggle` for input fields. Implemented validation checks to ensure proper input before submitting a search request.
- **Auto-detect Location**: The app features a toggle to auto-detect the user's location, using `ipInfo` API for fetching the current location.
- **Event List**: Search results are displayed as a list using `List` in SwiftUI, with each list item showing event name, venue, and date.
- **Event Details**: Detailed views for each event are implemented using `NavigationLink` to present event information, artist details, and venue location across three tabs.
  
### 2. Navigation and TabView

- **Navigation**: Implemented `NavigationView` and `NavigationLink` to handle transitions between views (e.g., from search results to event details).
- **Tabs**: Each event has three main sections (Event Info, Artist Info, Venue Info) accessible through a `TabView`, with each tab displaying relevant information.

### 3. Image Handling with Kingfisher

- **Event Images**: Leveraged `Kingfisher` to download and cache images asynchronously, ensuring smooth performance and reduced memory usage.

### 4. Local Storage

- **Favorites Management**: Stored users' favorite events locally using `UserDefaults`. Events are saved and removed from favorites by toggling a button in the event details view.
  
### 5. Asynchronous Networking with Alamofire

- **Event Search**: Implemented asynchronous API calls to the Node.js backend using `Alamofire`. The app fetches event data based on user input and updates the UI accordingly.
- **Loading Spinners**: Used `ProgressView` to indicate loading states during API requests, ensuring a smooth user experience.

### 6. Apple Maps Integration

- **Venue Map**: The venue tab provides a "Show Venue on Map" button that opens the venue's location in Apple Maps using the `MapView` from the Google Maps SDK.

### 7. Animations and Transitions

- **Toast Messages**: Implemented custom toast notifications to confirm when events are added or removed from favorites, using SwiftUI's `overlay` capabilities.
- **ScrollViews**: Event details and other sections feature scrollable content for displaying long text information.

### 8. Error Handling

- **Graceful Error Handling**: Incorporated error messages for cases like failed network requests or invalid search inputs, ensuring the app does not crash and provides helpful feedback.

## Screenshots

### Search Screen
![search screen](https://drive.google.com/uc?export=view&id=1JsQJgN5FFjsBaNaL_ZGQaOCAhPs1bD5J)

### Typed Event Suggestions
![Typed Event Suggestions](https://drive.google.com/uc?export=view&id=1FUSMz4MqSi0yKBivBE7ir0E1ozKH6E4a)

### Search Result
![search screen](https://drive.google.com/uc?export=view&id=13DyPoCzFBpnn1vgmrV5swrJQexO9DgYn)

### Event Information
![Event Info](https://drive.google.com/uc?export=view&id=17zLaptnhzXTx6tNQDa0G2BRu7tIk3JOf)


### Event Information
![Event Info](https://drive.google.com/uc?export=view&id=17zLaptnhzXTx6tNQDa0G2BRu7tIk3JOf)

### Artist Information
![Artist Information](https://drive.google.com/uc?export=view&id=1xi36zSA6byKvnL1XScr8GhNbToviO9FC)


### Venue Information
![Venue Information](https://drive.google.com/uc?export=view&id=1ZSMDoIREJbyRykqBKe54FDii0nATBzCW)

### Venue on Apple Maps
![Venue maps](https://drive.google.com/uc?export=view&id=16ZLiFjesYBfFGMPoGVe5ujqXvVwEuohW)

## Installation

To run this project, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/Sudo-Swapnil/EventSpotterIOS.git
    ```
2. Install dependencies using CocoaPods:
    ```
    pod install
    ```
3. Open the project in Xcode:
    ```
    open EventFinderApp.xcworkspace
    ```
4. Run the project on the iOS Simulator or a connected device.


## Usage
1. Search for events by keyword, category, distance, or location.
2. View event details, including artist and venue information.
3. Save favorite events and manage them locally.
4. Share events on social media.
5. Explore venues on an interactive map.