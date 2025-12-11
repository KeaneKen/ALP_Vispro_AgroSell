import '../models/bumdes_model.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class BumdesRepository {
  final ApiService _apiService = ApiService();

  // Get all bumdes
  Future<List<BumdesModel>> getAllBumdes() async {
    try {
      final response = await _apiService.get(ApiConfig.bumdes);
      
      if (response is List) {
        return response.map((json) => BumdesModel.fromJson(json)).toList();
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch bumdes: $e');
    }
  }

  // Get bumdes by ID
  Future<BumdesModel> getBumdesById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.bumdes}/$id');
      return BumdesModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch bumdes: $e');
    }
  }

  // Create new bumdes (Register)
  Future<BumdesModel> createBumdes(BumdesModel bumdes) async {
    try {
      final response = await _apiService.post(
        ApiConfig.bumdes,
        body: bumdes.toCreateJson(),
      );
      
      if (response['success'] == true && response['data'] != null) {
        return BumdesModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to create bumdes');
    } catch (e) {
      throw Exception('Failed to create bumdes: $e');
    }
  }

  // Update bumdes
  Future<BumdesModel> updateBumdes(String id, BumdesModel bumdes) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.bumdes}/$id',
        body: bumdes.toCreateJson(),
      );
      
      if (response['success'] == true && response['data'] != null) {
        return BumdesModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to update bumdes');
    } catch (e) {
      throw Exception('Failed to update bumdes: $e');
    }
  }

  // Delete bumdes
  Future<void> deleteBumdes(String id) async {
    try {
      await _apiService.delete('${ApiConfig.bumdes}/$id');
    } catch (e) {
      throw Exception('Failed to delete bumdes: $e');
    }
  }

  // Login bumdes
  Future<BumdesModel?> loginBumdes(String email, String password) async {
    try {
      final allBumdes = await getAllBumdes();
      
      for (var bumdes in allBumdes) {
        if (bumdes.emailBumdes == email && bumdes.passwordBumdes == password) {
          return bumdes;
        }
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
