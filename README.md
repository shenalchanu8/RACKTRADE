# RACKTRADE

A modern Flutter shopping app for clothing and lifestyle products. The app includes onboarding, login/register screens, product browsing, product details, favorites, cart checkout, order success, order history, profile, and light/dark mode support.

## Features

- Product catalog loaded from `assets/data/products.json`
- Home page with categories, featured products, search, and product cards
- Product detail page with size/color selection and cart actions
- Favorites page
- Cart page with checkout flow
- Address and payment checkout screens
- Order success screen and order history
- Profile page with logged-in user details and theme toggle
- Light mode and dark mode using `ThemeProvider`
- Local persistence with `shared_preferences`

## Tech Stack

- Flutter
- Dart SDK `>=3.0.0 <4.0.0`
- Provider for state management
- Shared Preferences for local storage
- Google Fonts
- Carousel Slider
- Smooth Page Indicator
- Flutter Rating Bar

## Project Structure

```text
lib/
  config/       App colors, themes, and theme helpers
  models/       Product, cart item, and order models
  providers/    App state providers
  screens/      App screens and flows
  utils/        Utility helpers
  widgets/      Shared UI widgets

assets/
  data/         Product JSON data
  icons/        Category icons
  images/       Logo and onboarding images
```

## Prerequisites

Install these before running the project:

- Flutter SDK
- Dart SDK, included with Flutter
- Android Studio or Visual Studio Code
- Android emulator, physical Android device, Chrome, or Windows desktop target

Check your Flutter setup:

```bash
flutter doctor
```

## Setup

1. Open a terminal in the project folder:

```bash
cd C:\Users\HP\Desktop\IonixPosFinal\RACKTRADE\urban_threads
```

2. Get dependencies:

```bash
flutter pub get
```

3. Verify the project:

```bash
flutter analyze
```

4. Optional: run tests:

```bash
flutter test
```

## Run The App

List available devices:

```bash
flutter devices
```

Run on the default connected device:

```bash
flutter run
```

Run on Chrome:

```bash
flutter run -d chrome
```

Run on Windows desktop:

```bash
flutter run -d windows
```

Run on a specific Android device:

```bash
flutter run -d <device-id>
```

## Build

Build Android APK:

```bash
flutter build apk --release
```

Build Android App Bundle:

```bash
flutter build appbundle --release
```

Build web:

```bash
flutter build web --release
```

Build Windows:

```bash
flutter build windows --release
```

## Assets And Product Data

The app uses local assets declared in `pubspec.yaml`:

```yaml
assets:
  - assets/images/
  - assets/icons/
  - assets/data/products.json
```

If you add new images, icons, or data files, update `pubspec.yaml` when needed and run:

```bash
flutter pub get
```

Product data is stored in:

```text
assets/data/products.json
```

## State Management

The app registers providers in `lib/main.dart`:

- `AuthProvider`
- `ThemeProvider`
- `CartProvider`
- `OrderProvider`
- `FavoriteProvider`
- `ProductProvider`

Theme mode is controlled from the Profile page and saved locally with `shared_preferences`.

## Useful Commands

Format code:

```bash
dart format lib test
```

Analyze code:

```bash
flutter analyze
```

Clean build output:

```bash
flutter clean
flutter pub get
```

Upgrade dependencies:

```bash
flutter pub upgrade
```

## Troubleshooting

If dependencies are missing:

```bash
flutter pub get
```

If assets do not appear:

```bash
flutter clean
flutter pub get
flutter run
```

If no device is found:

```bash
flutter devices
flutter doctor
```

If Windows desktop is not enabled:

```bash
flutter config --enable-windows-desktop
```

If web is not enabled:

```bash
flutter config --enable-web
```

## Notes

- Keep product image paths and URLs valid in `assets/data/products.json`.
- Do not remove asset declarations from `pubspec.yaml`.
- Run `flutter analyze` before submitting changes.
