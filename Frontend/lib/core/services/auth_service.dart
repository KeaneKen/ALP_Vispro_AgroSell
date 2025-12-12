import 'package:shared_preferences/shared_preferences.dart';
import '../models/mitra_model.dart';
import '../models/bumdes_model.dart';

/// Service to manage user authentication and session persistence
class AuthService {
  static const String _keyUserId = 'user_id';
  static const String _keyUserType = 'user_type'; // 'mitra' or 'bumdes'
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Save Mitra login session
  Future<void> saveMitraSession(MitraModel mitra) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, mitra.idMitra);
    await prefs.setString(_keyUserType, 'mitra');
    await prefs.setString(_keyUserName, mitra.namaMitra);
    await prefs.setString(_keyUserEmail, mitra.emailMitra);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// Save Bumdes login session
  Future<void> saveBumdesSession(BumdesModel bumdes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, bumdes.idBumdes);
    await prefs.setString(_keyUserType, 'bumdes');
    await prefs.setString(_keyUserName, bumdes.namaBumdes);
    await prefs.setString(_keyUserEmail, bumdes.emailBumdes);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// Get current user ID
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  /// Get current user type ('mitra' or 'bumdes')
  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserType);
  }

  /// Get current user name
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  /// Get current user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Logout and clear session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Get Mitra ID if logged in as mitra, null otherwise
  Future<String?> getMitraId() async {
    final userType = await getUserType();
    if (userType == 'mitra') {
      return await getUserId();
    }
    return null;
  }

  /// Get Bumdes ID if logged in as bumdes, null otherwise
  Future<String?> getBumdesId() async {
    final userType = await getUserType();
    if (userType == 'bumdes') {
      return await getUserId();
    }
    return null;
  }

  /// Get the other party ID for chat
  /// If user is mitra, returns bumdesId parameter
  /// If user is bumdes, returns mitraId parameter
  Future<Map<String, String>> getChatParticipantIds(String? mitraId, String? bumdesId) async {
    final userType = await getUserType();
    final userId = await getUserId();
    
    if (userType == 'mitra') {
      return {
        'mitraId': userId ?? '',
        'bumdesId': bumdesId ?? '',
        'currentUserType': 'mitra',
      };
    } else {
      return {
        'mitraId': mitraId ?? '',
        'bumdesId': userId ?? '',
        'currentUserType': 'bumdes',
      };
    }
  }
}
