# Backend Setup Instructions

## Prerequisites
- PHP 8.0 or higher
- MySQL or MariaDB
- Composer

## Setup Steps

### 1. Database Setup
Make sure your MySQL/MariaDB is running and create a database:
```sql
CREATE DATABASE laravel_alp;
```

### 2. Configure Environment
Edit the `Backend/.env` file with your database credentials:
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_alp
DB_USERNAME=root
DB_PASSWORD=yourpassword
```

### 3. Install Dependencies
```bash
cd Backend
composer install
```

### 4. Run Migrations and Seed Database
```bash
php artisan migrate:fresh --seed
```
This will create all tables and populate them with sample data.

### 5. Start the Backend Server

#### Option A: Use the batch file (Windows)
```bash
start_backend.bat
```

#### Option B: Manual start
```bash
php artisan serve
```

The server will run at: `http://127.0.0.1:8000`
API endpoints are at: `http://127.0.0.1:8000/api`

## Testing the API

### Check if data is loaded
```bash
php test_api.php
```

### Test API endpoints with curl
```bash
# Get all products
curl http://127.0.0.1:8000/api/pangan

# Get specific product
curl http://127.0.0.1:8000/api/pangan/P001
```

## Frontend Connection

The Flutter app will automatically connect to:
- **Android Emulator**: `http://10.0.2.2:8000/api`
- **iOS Simulator**: `http://localhost:8000/api`
- **Physical Device**: Use your computer's IP address

## Troubleshooting

### If products don't show in the app:
1. Make sure the backend server is running (`php artisan serve`)
2. Check if the database has data (`php test_api.php`)
3. If no data, run: `php artisan db:seed`
4. Check the Flutter debug console for error messages

### If you see "Using demo data" in the app:
- The app couldn't connect to the backend
- Make sure the backend is running on port 8000
- Check your firewall settings

### To force demo data (for testing without backend):
- Click "Use Demo Data" button when connection fails
- Or uncomment the `_useDemoData()` line in dashboard_viewmodel.dart
