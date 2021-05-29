# Foobar

FootballMojo is an app for football livescore and news. Using this app you can follow your favourite team and leagues. This app is purely built in flutter with firebase as the backend.
All the football scores are fetched from [Api-Football](https://www.api-football.com/) and news are fetched from [Bing News Search API](https://www.microsoft.com/en-us/bing/apis/bing-news-search-api).

## Architecture
This app uses **MVVM** architecture. **Models** contains data coming from different apis and firebase. **Views** represent different UI/Screens of the app. **View Models** integrates data/state with the UI(Provider is used to create viewmodels and handle state of the app).

## Structure of the codebase
**Commons/** - This directory all the common widgets which are used in multiple screens.

**models/** - This directory contains different models used in the app.

**Provider/** - This directory contains different providers for the app.

**screens/** - This directory individual screens of the app. 

**services/** - This directory contains all the services contained in the app. Services are used to handle business logic like fetching scores nad news, handling authentication, checking network connectivity etc. Services helps to extract business logic away from UI.

**widgets/** - This directory all the larger widgets which are jut used in a particular screen.

## External Services
**Apis** - Api-Football and Azure Cognitive Services News api.

**Firebase auth** - Used for user authentication.

**Firestore** - Used to store user favourite teams for syncing purposes. And Firebase Cloud Messaging token to send notifcations based on user preferences.

**Firebase remote config** - Used to store configs like newApiKey, scoreApiKey, newsUrl, scoreUrl etc. remotely. Firebase remote config allows to change config on the fly without the need for updating the app.

**Firebase Cloud Messaging** - Used to send notification about user favourite team.

**Firebase analytics** - Used to get analytics about the app usage.

## Setup
Create an account on [Api-Football](https://www.api-football.com/) and [Azure Cognitive Services](https://azure.microsoft.com/en-in/services/cognitive-services/) and get your api-key.
Before running the project, you have to setup enviroment your environment. For that create an **secret.dart** file in **lib/** directory. The content of the file should be following:
```dart
final int season = 2020;
final String newsApiKey = 'YOUR AZURE COGNITIVE SERVICES API KEY';
final String scoreApiKey = 'YOUR API-FOOTBALL API KEY';
final String newsUrl = "YOUR AZURE COGNITIVE SERVICES NEWS URL"; //Similar to https://username.cognitiveservices.azure.com/bing/v7.0/news/search
final String scoreUrl = "https://v3.football.api-sports.io/";
final String xRapidApiHost = "X RAPID API HOST OTHERWISE EMPTY STRING";
```
Create same key-value pair in Firebase Remote config as above.
![Firebase remote config](https://res.cloudinary.com/doy9hqxr1/image/upload/v1622277835/Screenshot_2021-05-29_at_13.59.03_moziwt.png)

## Install all the required packages
FIrst, install all the required packages using following commands:
```bash
flutter pub get
```

## Run the project
Run the app in debug mode:
```bash
flutter run
```
You can also run the app in release mode:
```bash
flutter run --release
```

## Create a release build

You can create a release build of the project by running following command:

```bash
flutter build apk --release
```
Your generated apk is located in the directory **build/app/outputs/apk/release/**.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Get this app on Play store
<a href="https://play.google.com/store/apps/details?id=com.footballmojo"><img alt="Get it on Google Play" src="https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png" height=60px /></a>