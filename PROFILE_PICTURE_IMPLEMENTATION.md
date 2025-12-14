# Profile Picture Upload Implementation

## Summary
Successfully implemented profile picture upload functionality for both Mitra and Bumdes users in the AgroSell application.

## Backend Changes

### Database
- Added `profile_picture` column to both `mitra` and `bumdes` tables via migration
- Column stores the filename of the uploaded image

### API Endpoints
- **Mitra:** `POST /api/mitra/{idMitra}/upload-profile-picture`
- **Bumdes:** `POST /api/bumdes/{idBumdes}/upload-profile-picture`
- Both endpoints accept multipart/form-data with an image file
- Images are stored in `storage/app/public/profile_pictures/`
- Created storage symbolic link for public access

### Models
- Updated `Mitra` and `Bumdes` models to include `profile_picture` field
- Added field to fillable arrays for mass assignment

## Frontend Changes

### Dependencies
- Added `image_picker: ^1.0.7` to Flutter dependencies
- Supports both camera and gallery image selection

### UI Updates
- **Mitra Profile View:** Added clickable profile picture with camera icon overlay
- **Bumdes Profile View:** Added clickable profile picture with camera icon overlay
- Both views show image picker dialog to choose between camera and gallery

### ViewModels
- Added `profilePicture` property to both `MitraProfileViewModel` and `BumdesProfileViewModel`
- Implemented `uploadProfilePicture()` method for handling image uploads
- Profile picture URL is fetched and displayed when available

### Models
- Updated `MitraModel` and `BumdesModel` to include `profilePicture` field
- Added parsing in `fromJson()` and serialization in `toJson()` methods

## How to Use

1. **For Users:**
   - Click on the profile picture in the profile view
   - Choose between Camera or Gallery
   - Select/capture an image
   - Image will be automatically uploaded and displayed

2. **For Testing:**
   - Ensure Laravel backend is running (`php artisan serve`)
   - Ensure storage link is created (`php artisan storage:link`)
   - Launch Flutter app and navigate to profile view
   - Click on profile picture to test upload functionality

## Technical Details
- Maximum image size: 2MB
- Supported formats: JPEG, PNG, JPG, GIF
- Images are resized to max 800x800 pixels before upload
- Old profile pictures are automatically deleted when uploading new ones
- Profile pictures are accessible via: `http://localhost:8000/storage/profile_pictures/{filename}`

## Files Modified
- Backend: 6 files (migrations, models, controllers, routes)
- Frontend: 6 files (views, viewmodels, models)
- Configuration: 1 file (pubspec.yaml)

## Future Enhancements
- Add image cropping functionality
- Implement image compression for faster uploads
- Add default avatars based on user type
- Cache profile pictures locally for offline access
