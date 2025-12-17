ALP Vispro — Frontend (Flutter)

This Flutter application is the client for the ALP Vispro AgroSell platform. It provides the user-facing experience for browsing products, placing pre-orders and orders, viewing order history, and interacting with Mitra/BumDES services.

## Tech Stack

- Flutter 3.x / 4.x
- Dart 3.x
- State management: ChangeNotifier / Provider (project-specific viewmodels)
- Assets: images located under `assets/images/`

## Prerequisites

- Install Flutter SDK (stable channel) and configure your platform toolchain:
  - https://docs.flutter.dev/get-started/install
- Ensure a compatible Dart SDK is available (shipped with Flutter)

## Setup (Local Development)

1. Open a terminal at the project root and fetch dependencies:

   ```bash
   cd Frontend
   flutter pub get
   ```

2. Ensure the backend API is running and reachable. By default, the app expects an API base URL configured in the app. Update the base URL if necessary (see Configuration below).

3. Run the app (debug on device or emulator):

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

- API base URL and other environment-specific settings are defined in the app code. Search for `api`, `baseUrl`, or the repository's environment/config helper files in `lib/` to adjust endpoints for development or production.
- Asset filenames used by the backend must match the files included in `assets/images/`. The backend seeder writes image names (e.g., `cabe 1.jpg`); if images are missing or renamed, the app falls back to default placeholder images.

## Project Structure (high level)

- `lib/` — application source code
  - `core/` — shared utilities, models, theme
  - `shared/` — common widgets and views (dashboard, catalog, cart, product detail)
  - `mitra/` — mitra-specific screens and viewmodels
  - `bumdes/` — bumdes-specific screens
  - `assets/` — static images used by the app

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

- Asset not found / image missing: confirm the filename returned by the backend matches a file under `assets/images/` and that `pubspec.yaml` includes `assets/images/`.
- Render overflow on small screens: the project uses responsive layouts and overflow handling, but if you encounter issues check widget constraints and Text overflow usage.

## Notes for Developers

- The app uses ViewModel classes (ChangeNotifier) to separate UI from logic. Inspect `lib/*/viewmodel/` to find data-fetching and transformation logic.
- When changing backend routes or response shapes, update the corresponding repositories/viewmodels to avoid runtime parsing errors.

## Contribution

- Fork the repository, work on a feature branch, and submit a pull request. Include tests for new behavior when appropriate.

## License

- See top-level repository license or consult the project owners.
