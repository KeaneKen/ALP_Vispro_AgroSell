ALP Vispro — Full Project

This repository contains the ALP Vispro AgroSell application: a Flutter frontend client and a Laravel backend API. The project enables product listing, pre-orders, cart/checkout flows, order history, and real-time messaging between Mitra and BumDES.

## Contents

- `Backend/` — Laravel API, migrations, seeders, and server-side services
- `Frontend/` — Flutter application (mobile/web), assets, and UI viewmodels

## Tech Stack

- Frontend: Flutter (Dart), ChangeNotifier / Provider pattern
- Backend: PHP (Laravel), Eloquent ORM
- Database: SQLite (local dev), MySQL/Postgres supported via `.env`
- Realtime: Soketi / Pusher-compatible broadcasting

## Quick Start (Local Development)

Prerequisites:

- PHP 8.1+ and Composer
- Flutter SDK and required platform toolchains
- Node.js / npm (optional)

1) Backend

   - Copy and configure environment:

     ```powershell
     cd Backend
     copy .env.example .env
     ```

   - Install PHP dependencies and prepare the application:

     ```bash
     composer install
     php artisan key:generate
     ```

   - Configure DB in `.env` (SQLite recommended for quick dev):

     ```text
     DB_CONNECTION=sqlite
     DB_DATABASE=/full/path/to/database.sqlite
     ```

   - Run migrations and seeders:

     ```bash
     php artisan migrate
     php artisan db:seed --class=PanganSeeder
     ```

   - Start the backend API:

     ```bash
     php artisan serve
     ```

2) Frontend

   - From repository root:

     ```bash
     cd Frontend
     flutter pub get
     flutter run
     ```

   - Build release binaries:

     ```bash
     flutter build apk --release
     flutter build ios --release
     ```

## Configuration & Environment

- Backend environment values live in `Backend/.env` and control database, mail, and broadcasting settings.
- Frontend API base URLs are configured in the app code; search for `baseUrl` or inspect repository helpers in `Frontend/lib/`.
- Ensure that the image filenames referenced by the backend (seeders) match the frontend assets under `Frontend/assets/images/`.

## Project Structure (high level)

- `Backend/`
  - `app/` — Laravel application code and models
  - `config/`, `database/`, `routes/` — framework configuration and migrations
  - `database/seeders/PanganSeeder.php` — populates product data (idempotent)
- `Frontend/`
  - `lib/` — source code (viewmodels, views, core utilities)
  - `assets/images/` — static product and placeholder images

## Common Commands

- Backend:

  ```bash
  composer install
  php artisan migrate --seed
  php artisan serve
  ```

- Frontend:

  ```bash
  flutter pub get
  flutter analyze
  flutter run
  ```

## Testing

- Backend: `./vendor/bin/phpunit` (or `php artisan test`)
- Frontend: `flutter test`

## Best Practices & Notes

- Seeder idempotence: `PanganSeeder` uses `updateOrCreate` to avoid duplicate key errors.
- Debounce rapid UI actions: the frontend includes a `Debouncer` utility to prevent request storms on frequent interactions (e.g., cart quantity adjustments).
- Asset syncing: keep `idFoto_Pangan` values in seed data aligned with `Frontend/assets/images/` filenames to avoid missing images.

## Troubleshooting

- If the frontend cannot connect to the API, verify the backend is running (`php artisan serve`) and that the `baseUrl` in the app points to the correct host/port.
- Seeder UNIQUE constraint errors: run `php artisan migrate:fresh --seed` for a local reset.
- Image 403 errors: confirm storage symlink (`php artisan storage:link`) and web server permissions for `storage/`.

## Contribution

- Fork the repository, use feature branches, include tests for behavior changes, and open pull requests with clear descriptions.

## License & Support

- See repository root for license details. For questions, contact the maintainers listed in project metadata.
