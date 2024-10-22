# Swappy
DISABLED: Due to workflow limited free quota on actions at 75% currently.
\
\
[![Deploy Flutter Web to Firebase Hosting on merge](https://github.com/11Arnau46/pin/actions/workflows/firebase-hosting-merge.yml/badge.svg)](https://github.com/11Arnau46/pin/actions/workflows/firebase-hosting-merge.yml)
[![Build Flutter Android APK](https://github.com/11Arnau46/pin/actions/workflows/buildAPK.yml/badge.svg)](https://github.com/11Arnau46/pin/actions/workflows/buildAPK.yml)
[![Build Flutter iOS App for Simulator](https://github.com/11Arnau46/pin/actions/workflows/buildiOS.yml/badge.svg)](https://github.com/11Arnau46/pin/actions/workflows/buildiOS.yml) \
\
Swappy is a cross-platform Flutter app that allows users to exchange clothes. Available on iOS, Android, and the Web, Swappy makes it easy to swap fashion items with people in your community or around the world. Whether you want to update your wardrobe or give a new life to pre-loved clothes, Swappy is the go-to app for sustainable fashion.

## Features
- **Browse Clothes**: Explore various clothing items available for exchange.
- **Easy Exchange**: Find matches and swap clothes with others nearby or globally.
- **Wishlist**: Save items you’d like to exchange later.
- **Notifications**: Get notified when someone is interested in your clothes.
- **Profile**: Customize your user profile and manage your swaps.

## Platforms Supported
- **iOS**
- **Android**
- **Web**

## Getting Started

This project is built using Flutter, a UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. 

### Prerequisites
Ensure you have Flutter installed on your machine. You can follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install) to set up Flutter on your system.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/11Arnau46/swappy.git
   cd swappy

## Useful Commands

Here are some commonly used Flutter commands to help manage your project:

### Managing dependencies in pubspec.yaml file

**Fetch dependencies**:
```bash
  flutter pub get
```
**Update dependencies**:
```bash
  flutter pub upgrade
```

**Get outdated dependencies**
```bash
  flutter pub outdated
```
### Building app for platforms

**Build APK for Android dependencies**:
```bash
  flutter build apk --release
```
**Build app for iOS**:
```bash
  flutter build ios --release
  flutter build ios --simulator 
```
(SECOND ONE since our app isn't signed with an apple developer certificate $$) \
\
**Build for the Web:**
```bash
  flutter build web --release
```
### How to run
**Run the app on a specific device (chrome...)**
```bash
  flutter run -d <device_id>
  flutter run -d chrome --web-port 8080
```
It must run on a specific port in localhost or address for googleSignIn to work.
Authorized addresses https://localhost:8080 && https://swappy-pin.web.app.
The default command opens a different port each time, so googleSignIn won't work.

### Firebase
**Log in:**
```bash
  firebase login
```
**Deploy website**
```bash
  firebase deploy --only hosting
```
Technically, pushing to main and passing the workflow Firebase deploy to the web and hosting will deploy the website.
However all workflows are disabled now so website deployment must be done executing this command.

### Mix
**Analyze flutter**
```bash
  flutter analyze
```
**Format Dart code**
```bash
  flutter format .
```
**Clean build files**
```bash
  flutter clean
```

**Get flutter version**
```bash
  flutter --version
```
**Verify flutter installation**
```bash
  flutter doctor
```


## TODO
Final readme.md file for the project must have
- [ ] Add app screenshots/Designs
- [ ] Update features (more detailed project specifications)
- [ ] Add right platforms supported (see in the end, macOS, windows, linux)
- [ ] Translate to Spanish (app and readme.md supports 3 languages)
- [ ] Add installation instructions




  




