# Login Fix Summary

## Issue
User reported "email not registered" when trying to log in with a BumDes email.
This was caused by:
1. The frontend `BumdesRepository` was performing a "fake" login by fetching all BumDes records and comparing passwords in plain text client-side.
2. The backend `BumdesController` was missing a dedicated `login` endpoint.
3. The database passwords are hashed, so the plain text comparison in the frontend always failed.

## Changes

### Backend
1.  **`Backend/app/Http/Controllers/BumdesController.php`**:
    *   Added `public function login(Request $request)` method.
    *   Implemented validation, user lookup by email, and password verification using `Hash::check`.
    *   Returns JSON response with user data on success, or error messages on failure.

2.  **`Backend/routes/api.php`**:
    *   Added route: `Route::post('bumdes/login', [BumdesController::class, 'login']);`.

### Frontend
1.  **`Frontend/lib/core/services/bumdes_repository.dart`**:
    *   Updated `loginBumdes` method to call the new backend endpoint (`POST /api/bumdes/login`).
    *   Removed the inefficient "fetch all and filter" logic.
    *   Updated error handling to return `null` on 401/404 errors (consistent with `MitraRepository`), allowing the `LoginViewModel` to handle the login chain correctly.

## Result
The application now correctly supports BumDes login. The `LoginViewModel` will:
1.  Attempt to log in as Mitra.
2.  If that fails (returns null), it will attempt to log in as BumDes.
3.  If that succeeds, the user is logged in.
4.  If both fail, an error message is displayed.
