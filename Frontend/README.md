ALP Vispro — Frontend (Flutter)

This Flutter application is the client for the ALP Vispro AgroSell platform. It provides the user-facing experience for browsing products, placing pre-orders and orders, viewing order history, and interacting with Mitra/BumDES services.

## Tech Stack

- Flutter (stable)
- Dart 3.x
- State management: ChangeNotifier / Provider (project-specific viewmodels)
- Assets: images located under `assets/images/`

## Prerequisites

- Install Flutter SDK (stable channel) and configure your platform toolchain:
  - https://docs.flutter.dev/get-started/install

## Setup (Local Development)

1. From the project root, fetch dependencies:

   ```bash
   cd Frontend
   flutter pub get
   ```

2. Ensure the backend API is running and reachable. Update the app's base URL if necessary (search for `baseUrl` or the repository's configuration helpers in `lib/`).

3. Run the app on an emulator or device:

   ```bash
   flutter run
   ```

## Build

- Android (release):

  ```bash
  flutter build apk --release
  ```

- iOS (release):

  ```bash
  flutter build ios --release
  ```

## Configuration

- API base URL and other environment-specific settings are defined in the app code. Inspect `lib/` for configuration helpers.
- Asset filenames used by the backend must match the files included in `assets/images/`. If images are missing, the app will fall back to default placeholders.

## Project Structure (high level)

- `lib/` — application source code
  - `core/` — shared utilities, models, theme
  - `shared/` — common widgets and views
  - `mitra/` — mitra-specific screens and viewmodels
  - `bumdes/` — bumdes-specific screens

## Common Commands

- Analyze code:

  ```bash
  flutter analyze
  ```

- Run tests (widget/unit tests):

  ```bash
  flutter test
  ```

## Troubleshooting

- Asset not found / image missing: confirm the backend returns a filename that exists under `assets/images/` and that `pubspec.yaml` includes the assets path.
- Render overflow on small screens: check widget constraints and apply `Flexible`/`Expanded` and `TextOverflow.ellipsis` where appropriate.

## Notes for Developers

- The app uses ViewModel classes (ChangeNotifier) to separate UI from logic. See `lib/*/viewmodel/` for data-fetching and transformation logic.
- When changing backend response shapes, update the matching repositories/viewmodels to avoid runtime parsing errors.

## Contribution

- Fork the repository, create a feature branch, and submit a pull request. Include tests for critical logic.

## License

- See top-level repository license.
ALP Vispro — Frontend (Flutter)

This Flutter application is the client for the ALP Vispro AgroSell platform. It provides the user-facing experience for browsing products, placing pre-orders and orders, viewing order history, and interacting with Mitra/BumDES services.

## Tech Stack

- Flutter (stable)
- Dart 3.x
- State management: ChangeNotifier / Provider (project-specific viewmodels)
- Assets: images located under `assets/images/`

## Prerequisites

- Install Flutter SDK (stable channel) and configure your platform toolchain:
  - https://docs.flutter.dev/get-started/install

## Setup (Local Development)

1. From the project root, fetch dependencies:

   ```bash
   cd Frontend
   flutter pub get
   ```

2. Ensure the backend API is running and reachable. Update the app's base URL if necessary (search for `baseUrl` or the repository's configuration helpers in `lib/`).

3. Run the app on an emulator or device:

   ```bash
   flutter run
   ```

## Build

- Android (release):

  ```bash
  flutter build apk --release
  ```

- iOS (release):

  ```bash
  flutter build ios --release
  ```

## Configuration

- API base URL and other environment-specific settings are defined in the app code. Inspect `lib/` for configuration helpers.
- Asset filenames used by the backend must match the files included in `assets/images/`. If images are missing, the app will fall back to default placeholders.

## Project Structure (high level)

- `lib/` — application source code
  - `core/` — shared utilities, models, theme
  - `shared/` — common widgets and views
  - `mitra/` — mitra-specific screens and viewmodels
  - `bumdes/` — bumdes-specific screens

## Common Commands

- Analyze code:

  ```bash
  flutter analyze
  ```

- Run tests (widget/unit tests):

  ```bash
  flutter test
  ```

## Troubleshooting

- Asset not found / image missing: confirm the backend returns a filename that exists under `assets/images/` and that `pubspec.yaml` includes the assets path.
- Render overflow on small screens: check widget constraints and apply `Flexible`/`Expanded` and `TextOverflow.ellipsis` where appropriate.

## Notes for Developers

- The app uses ViewModel classes (ChangeNotifier) to separate UI from logic. See `lib/*/viewmodel/` for data-fetching and transformation logic.
- When changing backend response shapes, update the matching repositories/viewmodels to avoid runtime parsing errors.

## Contribution

- Fork the repository, create a feature branch, and submit a pull request. Include tests for critical logic.

## License

- See top-level repository license.
# agrosell

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
