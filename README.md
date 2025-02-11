# Movie Browser App

The Movie Browser App is a Flutter application that allows users to browse a list of popular movies retrieved from the TMDb API, search for movies by name, view detailed information about a single movie, and favorite movies for offline storage.

## Features

- Browse a list of popular or trending movies
- Search for movies by name
- View detailed information about a single movie
- Favorite movies and store them offline using sqflite
- Persistent favorites across app restarts
- Pull-to-refresh functionality for both movie list and favorites list
- Error handling for network issues and no results

## Installation

To install the APK on a physical device:

1. Download the APK file (TheMovieDB Search.apk) from the releases section (Initial release v1.0.0+1)
2. On your device, open the file manager and locate the APK file.
3. Tap on the APK file to start the installation process.
4. You may need to enable installation from unknown sources in your device settings. Other security measures may also affect the installation so please check and disable.

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- TMDb API Key: [Get an API Key](https://www.themoviedb.org/documentation/api)

### Clone the Repository

```sh
git clone https://github.com/ryandalida/movieSearchTMDB_template.git
cd movieSearchTMDB_template

TODO:
There is still something wrong with the persistence of favorites list. It doesn't go across app restarts. Although the actual database file stores the movies, the data is actually inserted if you look at the file manually (DB browser). However the list still gets reset when app is restarted.