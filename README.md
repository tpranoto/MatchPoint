# MatchPoint

Group 7 project for CPSC 5250:
- Nomi Sodnombayar
- Timothy Pranoto

## Getting Started

The project requires Foursquare API in `.env` and SHA-1/SHA-256 fingerprints in `sharedDev.keystore`
to run.

## Current Progress

### 1st Milestone:
- Research feasibility of APIs - Done
    - Google People API - Done
    
        instead of using it, we are using Firebase Auth.
    - Google Places API (and Google Maps API in general) -- Done

        instead of using it, we use Foursquare Place API since it provides us more specific data that we need.
    - Google Geolocation API (and Google Maps API in general) -- Done
    
        instead of using it, we are using 2 library from pub.dev:   geolocator: ^13.0.2 & geocoding: ^3.0.0.
    - Firebase for database and Firebase Cloud Messaging for push notifications -- Done
        
         We are using firestore for our database.
- Sport facility finder with categorizations -- In Progress
    - Create view of list of facilities -- Done
    - Add categorizations of sports filtering -- Done
    - Connect to actual database
    
        we have not save the data to database and currently just fetching data from API.
- Set up database -- Done
    - Set up Firebase project -- Done
    - Set up firebase in our app -- Done
- User profile -- Done
    - reate view of user profile page -- Done
    - Connect to actual database -- Done

### 2nd Milestone:
- Sports facility information -- In Progress
    - Create view of detailed page of facility
    - Add a widget to navigation to court reservation with empty function
    - Connect to actual database
- User login -- Done
    - Create API key from Google People API -- Done
    
        we use Firebase Auth instead with same functionality.
    - Connect application to API -- Done
    - Create view of login page -- Done
- Court reservations
    - Create a view of courts + time slots of facilities.
    - Connect created page to detailed facility page.
    - Connect to actual database
### 3rd Milestone:
- Ratings of facilities
    - Create widgets like ratings to be added to list page and ratings + comments to be added to detailed page.
    - Create widget to handle adding new ratings and comments.
    - Connect to actual database
- Notifications
    - Create token from FCM
    - Create widget to handle pushing notifications.
