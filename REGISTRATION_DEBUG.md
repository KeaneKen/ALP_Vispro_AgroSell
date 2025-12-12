# Registration System - Debug Guide

## ✅ Current Status
The registration system is **WORKING CORRECTLY**. Data is being saved to the `mitra` table in the database.

### Confirmed Working:
1. **Backend API** - Successfully creates new mitra records with auto-generated IDs (M001, M002, M003, etc.)
2. **Database** - Currently has 3 registered mitras:
   - M001: budi@tanimakmur.com (original seeded data)
   - M002: testuser3491@example.com (test registration)
   - M003: testuser4414@example.com (test registration)
3. **Validation** - Duplicate emails are properly rejected
4. **Password Encryption** - Passwords are hashed using bcrypt

## 🔍 If You Don't See Your Registration in phpMyAdmin

### 1. Check Laravel Server
Make sure the Laravel backend is running on all interfaces:
```bash
cd Backend
php artisan serve --host=0.0.0.0 --port=8000
```

### 2. Verify Database Connection
Check current mitra count:
```bash
cd Backend
echo "App\Models\Mitra::count();" | php artisan tinker
```

List all registered emails:
```bash
echo "App\Models\Mitra::all()->pluck('Email_Mitra');" | php artisan tinker
```

### 3. Flutter App Connection Issues

#### For Android Emulator:
- The app uses `http://10.0.2.2:8000/api` (configured correctly)
- This is the special IP that Android emulator uses to access host machine's localhost

#### For Physical Device:
- Update `Frontend/lib/core/config/api_config.dart` with your computer's IP:
```dart
static const String baseUrlPhysicalDevice = 'http://YOUR_COMPUTER_IP:8000/api';
```
- Find your IP: Run `ipconfig` and look for IPv4 Address (e.g., 192.168.40.212)

#### For iOS Simulator:
- Uses `http://localhost:8000/api` (configured correctly)

## 📊 View Debug Logs

When you register from the Flutter app, you'll see console logs like:
```
Starting registration for email: test@example.com
Calling API to create mitra...
POST Request to: http://10.0.2.2:8000/api/mitra
Request body: {"Nama_Mitra":"Test User","NoTelp_Mitra":"0812345678","Email_Mitra":"test@example.com","Password_Mitra":"password123"}
Response status: 201
Response body: {"success":true,"message":"Mitra created successfully","data":{...}}
Mitra created successfully with ID: M004
Session saved successfully
```

## 🛠️ Troubleshooting

### Error: "No connection could be made"
- Laravel server is not running
- Solution: Start server with `php artisan serve --host=0.0.0.0`

### Error: "Failed to create mitra: SocketException"
- Flutter app can't reach the backend
- Solution: Check IP configuration in `api_config.dart`

### Error: "Email sudah terdaftar"
- The email is already registered
- Solution: Use a different email address

### Registration succeeds but not in phpMyAdmin
- Might be looking at wrong database
- Check `.env` file: `DB_DATABASE=laravel_alp`
- Refresh phpMyAdmin page

## 📱 Test Registration from Flutter

1. Run the Flutter app on emulator/device
2. Go to Registration screen
3. Fill in:
   - Username: Any name
   - Phone: Any phone number
   - Email: Must be unique (not already registered)
   - Password: Minimum 8 characters
4. Click "Daftar" button
5. Check console logs for debug info
6. On success, you'll be redirected to login screen
7. Verify in database:
   ```bash
   echo "App\Models\Mitra::latest()->first();" | php artisan tinker
   ```

## 🔄 Complete Flow

1. **User fills form** → Flutter app validates fields
2. **Flutter calls API** → POST to `/api/mitra` with user data
3. **Laravel receives** → MitraController@store method
4. **Backend validates** → Checks email uniqueness
5. **Generate ID** → Creates next sequential ID (M001, M002, etc.)
6. **Hash password** → Uses bcrypt for security
7. **Save to DB** → Inserts into `mitra` table
8. **Return response** → Sends success with created mitra data
9. **Flutter receives** → Saves session to SharedPreferences
10. **Navigate** → Redirects to login screen

## ✅ Verification Commands

Quick test to create a new mitra via command line:
```python
import requests
import random

test_data = {
    "Nama_Mitra": f"Test User {random.randint(1000,9999)}",
    "Email_Mitra": f"test{random.randint(1000,9999)}@example.com",
    "Password_Mitra": "password123",
    "NoTelp_Mitra": "0812345678"
}

response = requests.post("http://localhost:8000/api/mitra", json=test_data)
print(response.json())
```

## 📝 Summary

The registration system is fully functional and saves data to the `mitra` table. If you're not seeing data in phpMyAdmin:
1. Make sure you're refreshing the page
2. Check you're viewing the correct database (`laravel_alp`)
3. Ensure the Laravel server is running
4. Verify the Flutter app is connecting to the correct IP/port
