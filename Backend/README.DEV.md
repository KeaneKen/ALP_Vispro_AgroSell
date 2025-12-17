ALP Vispro — Backend (Laravel)

This document provides a concise developer-oriented guide for the Laravel backend powering the ALP Vispro AgroSell platform.

## Overview

The backend exposes a RESTful API for managing products (`pangan`), shopping carts, pre-orders, payments, transaction history, and real-time messaging between Mitra and users. It is implemented using Laravel and follows standard framework conventions.

## Requirements

- PHP 8.1+ (8.2 recommended)
- Composer
- A database: SQLite (recommended for quick local dev), MySQL or PostgreSQL for production
- Node.js/npm (optional for asset building)

## Quick Start (Local)

1. Copy `.env.example` to `.env` and adjust the settings:

   ```powershell
   copy .env.example .env
   ```

2. Install dependencies:

   ```bash
   composer install
   ```

3. Generate application key:

   ```bash
   php artisan key:generate
   ```

4. Configure DB in `.env`. For SQLite (local dev):

   ```env
   DB_CONNECTION=sqlite
   DB_DATABASE=/full/path/to/database.sqlite
   ```

5. Run migrations and seeders:

   ```bash
   php artisan migrate
   php artisan db:seed --class=PanganSeeder
   ```

6. Serve the app:

   ```bash
   php artisan serve
   ```

## Development Notes

- Seeder: `database/seeders/PanganSeeder.php` is idempotent and uses `updateOrCreate` to avoid duplicate primary-key errors.
- Storage: use `php artisan storage:link` to expose uploaded files via the `public` disk.
- Broadcasting: configure `config/broadcasting.php` and `soketi.json` when enabling realtime features.

## Testing

Run the PHPUnit suite:

```bash
./vendor/bin/phpunit
```

## Useful Artisan Commands

- `php artisan migrate:fresh --seed` — reset database and seed
- `php artisan queue:work` — process background jobs
- `php artisan tinker` — interactive console

## API Notes

- Authentication uses Laravel Sanctum. Protected endpoints expect a Bearer token.
- Standardized response format: `success`, `data`, `message`.
- Ensure asset filenames produced by the seeder match frontend asset files under `assets/images/`.

## Troubleshooting

- If seeding fails with UNIQUE constraint errors, run migrations fresh or remove conflicting records. The provided seeder is designed to be safe for repeated runs.
- For DB connection issues, verify `.env` settings and confirm database user privileges.

## Contribution Guidelines

- Create small, focused pull requests with tests for critical logic.
- Follow existing conventions for migrations, controllers, and repositories.

## License & Support

- See repository root for license information.
- For questions, contact the project maintainers.
