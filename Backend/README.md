ALP Vispro — Backend (Laravel)

This repository contains the Laravel-based backend API used by the ALP Vispro frontend Flutter application. It provides product (pangan) management, pre-order and order handling, authentication, and auxiliary services such as seeding and queue processing.

## Overview

The backend exposes a RESTful API for managing products, shopping carts, pre-orders, payments, transaction history, and real-time messaging between Mitra and users. It is implemented using Laravel and follows standard framework conventions.

## Tech Stack

- PHP 8.1+ (8.2 recommended)
- Laravel 9/10/11 (project-compatible)
- SQLite / MySQL / PostgreSQL (configured via `.env`)
- Composer for dependency management
- Soketi / Pusher-compatible config for WebSockets

## Quick Setup (Local Development)

Prerequisites:

- PHP 8.1+
- Composer
- Node.js / npm (optional for asset pipelines)

Steps:

1. Copy the example environment file and configure values:

   - Windows / PowerShell
   ```powershell
   copy .env.example .env
   ```

2. Install PHP dependencies:

   ```bash
   composer install
   ```

3. Generate application key:

   ```bash
   php artisan key:generate
   ```

4. Configure database in `.env` (SQLite is convenient for local development):

   ```text
   DB_CONNECTION=sqlite
   DB_DATABASE=/full/path/to/database.sqlite
   ```

5. Run migrations and seeders:

   ```bash
   php artisan migrate
   php artisan db:seed --class=PanganSeeder
   ```

6. Create storage symlink if needed:

   ```bash
   php artisan storage:link
   ```

7. Start the development server:

   ```bash
   php artisan serve
   ```

## Important Commands

- `php artisan migrate` — run database migrations
- `php artisan db:seed` — run seeders (use `--class` to target one)
- `php artisan queue:work` — process jobs
- `php artisan tinker` — interactive console

## Seeding & Assets

- `database/seeders/PanganSeeder.php` inserts product records and is implemented to be idempotent via `updateOrCreate`.
- Ensure the image filenames returned by the API match the files under the frontend `assets/images/` directory (examples: `cabe 1.jpg`, `padi 1.jpg`).

## WebSockets / Realtime

- Broadcasting configuration is in `config/broadcasting.php` and `soketi.json`. Update `.env` to enable realtime features.

## Testing

- Run PHP unit tests:

  ```bash
  ./vendor/bin/phpunit
  ```

## Troubleshooting

- Unique constraint errors during seeding: the seeder uses `updateOrCreate`, but if conflicts occur run `php artisan migrate:fresh --seed` in local dev.
- Database connection issues: verify `.env` DB settings and that the DB file (for SQLite) is writable.

## Contribution

- Fork, create a feature branch, add tests, and open a pull request. Follow existing code style and migration practices.

## License

- See top-level repository license file.
# Laravel Backend API - Agricultural Product Management System

## Overview

This is a Laravel-based REST API backend for an agricultural product management and marketplace system. The system facilitates connections between agricultural cooperatives (BumDES), business partners (Mitra), companies (Perusahaan), and end users through product listings, shopping cart functionality, payment processing, and real-time chat.

## System Requirements

- PHP 8.2 or higher
- MySQL 8.0 or higher (or MariaDB 10.3+)
- Composer 2.x
- Laravel 11.x

## Database Architecture

### Core Tables

#### 1. Perusahaan (Companies)
- Primary Key: `idPerusahaan` (string)
- Fields: Company name, email, password, address, phone number
- Purpose: Represents partner companies in the system

#### 2. BumDES (Village-Owned Enterprises)
- Primary Key: `idBumDES` (string)
- Fields: Name, email, password, phone number
- Purpose: Represents agricultural cooperatives

#### 3. Mitra (Business Partners)
- Primary Key: `idMitra` (string)
- Foreign Key: `idPerusahaan` (references Perusahaan)
- Fields: Name, email, password, phone number
- Purpose: Represents individual business partners associated with companies

#### 4. Pangan (Agricultural Products)
- Primary Key: `idPangan` (string)
- Foreign Key: `idMitra` (references Mitra)
- Fields: Product name, description, price, photo reference
- Purpose: Product listings created by business partners

#### 5. Cart (Shopping Cart)
- Primary Key: `idCart` (auto-increment)
- Foreign Key: `idPangan` (references Pangan)
- Fields: Purchase quantity
- Purpose: Temporary storage for user product selections

#### 6. Payment (Transactions)
- Primary Key: `idPayment` (auto-increment)
- Foreign Key: `idCart` (references Cart)
- Fields: Total price
- Purpose: Records completed transactions

#### 7. Riwayat (Transaction History)
- Primary Key: `idHistory` (auto-increment)
- Foreign Key: `idPayment` (references Payment)
- Purpose: Maintains historical record of all transactions

#### 8. Chat (Messaging System)
- Primary Key: `idChat` (auto-increment)
- Foreign Keys: `idMitra` (references Mitra), `idUser` (references Users)
- Fields: Message content, sender type, status, timestamps
- Purpose: Facilitates communication between business partners and users
- Status tracking: sent, delivered, read

### Entity Relationships

```
Perusahaan (1) ──── (N) Mitra
Mitra (1) ──── (N) Pangan
Pangan (1) ──── (N) Cart
Cart (1) ──── (1) Payment
Payment (1) ──── (1) Riwayat
Mitra (1) ──── (N) Chat (N) ──── (1) User
```

## Installation

### 1. Clone Repository
```bash
git clone <repository-url>
cd sigma_alp_vispro
```

### 2. Install Dependencies
```bash
composer install
```

### 3. Environment Configuration
Copy the environment file and configure database credentials:
```bash
cp .env.example .env
```

Update the following variables in `.env`:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_alp
DB_USERNAME=root
DB_PASSWORD=your_password
```

### 4. Generate Application Key
```bash
php artisan key:generate
```

### 5. Database Setup

Create the database:
```sql
CREATE DATABASE laravel_alp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Run migrations:
```bash
php artisan migrate
```

### 6. Storage Configuration
Link storage for file uploads:
```bash
php artisan storage:link
```

### 7. Start Development Server
```bash
php artisan serve
```

The API will be available at `http://localhost:8000`

## API Structure

### Base URL
```
Development: http://localhost:8000/api
Production: https://your-domain.com/api
```

### Authentication
This API uses Laravel Sanctum for token-based authentication. Protected endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer {token}
```

### Planned Endpoints

#### Authentication
- `POST /mitra/register` - Register new business partner
- `POST /mitra/login` - Authenticate business partner
- `POST /bumdes/register` - Register new BumDES
- `POST /bumdes/login` - Authenticate BumDES
- `POST /logout` - Revoke authentication token

#### Products (Pangan)
- `GET /pangan` - Retrieve all products
- `GET /pangan/{id}` - Retrieve single product
- `POST /pangan` - Create new product (Mitra only)
- `PUT /pangan/{id}` - Update product (Mitra only)
- `DELETE /pangan/{id}` - Delete product (Mitra only)

#### Shopping Cart
- `GET /cart` - Retrieve user's cart
- `POST /cart/add` - Add item to cart
- `PUT /cart/{id}` - Update cart item quantity
- `DELETE /cart/{id}` - Remove item from cart

#### Payments
- `POST /payment/checkout` - Process payment
- `GET /payment/history` - Retrieve payment history

#### Chat System
- `GET /chat/{idMitra}` - Retrieve chat messages with specific business partner
- `POST /chat/send` - Send new message
- `POST /chat/read/{idChat}` - Mark message as read
- `GET /chat/conversations` - List all active conversations

### Response Format

#### Success Response
```json
{
  "success": true,
  "data": {},
  "message": "Operation successful"
}
```

#### Error Response
```json
{
  "success": false,
  "message": "Error description",
  "data": []
}
```

## CORS Configuration

Cross-Origin Resource Sharing (CORS) is configured to allow requests from frontend applications. Current configuration in `config/cors.php`:

```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],
'allowed_methods' => ['*'],
'allowed_origins' => ['*'],
'allowed_headers' => ['*'],
'supports_credentials' => true,
```

Note: In production, restrict `allowed_origins` to specific domains.

## File Storage

Product images are stored using Laravel's file storage system:
- Storage disk: `public`
- Access path: `storage/app/public`
- Public URL: `http://localhost:8000/storage/{filename}`

## Security Features

1. Password Hashing: All passwords are hashed using bcrypt
2. API Token Authentication: Stateless authentication via Sanctum
3. CSRF Protection: Built-in Laravel CSRF protection
4. SQL Injection Prevention: Eloquent ORM with parameterized queries
5. Mass Assignment Protection: Fillable/guarded properties on models

## Database Indexes

Optimized query performance through strategic indexing:
- `chat` table: Composite index on `(idMitra, idUser)` for conversation lookups
- Foreign key constraints: Automatic indexes on all foreign key columns

## Cascade Deletion

Referential integrity maintained through cascade delete rules:
- Deleting a Perusahaan removes all associated Mitra
- Deleting a Mitra removes all associated Pangan and Chat messages
- Deleting a User removes all associated Chat messages
- Deleting Pangan removes associated Cart items
- Deleting Cart removes associated Payment records

## Development Status

### Completed
- Database schema design and migration files
- Entity relationship configuration
- CORS setup for API access
- File storage configuration
- Base controller structure

### Pending Implementation
- Model class definitions with relationships
- API controller implementations
- Authentication logic (registration, login, logout)
- Request validation rules
- API route definitions
- Unit and feature tests

## Testing

Run the test suite:
```bash
php artisan test
```

## Migration Management

Rollback last migration:
```bash
php artisan migrate:rollback
```

Reset and re-run all migrations:
```bash
php artisan migrate:fresh
```

Run migrations with seeding:
```bash
php artisan migrate --seed
```

## License

This project is proprietary software. All rights reserved.

## Support

For technical support or questions, contact the development team.

## Version History

- v1.0.0 (2025-11-30) - Initial database structure and migration setup