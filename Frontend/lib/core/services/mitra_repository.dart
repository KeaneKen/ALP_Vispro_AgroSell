import '../models/mitra_model.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class MitraRepository {
  final ApiService _apiService = ApiService();

  // Get all mitra
  Future<List<MitraModel>> getAllMitra() async {
    try {
      final response = await _apiService.get(ApiConfig.mitras);
      
      if (response is List) {
        return response.map((json) => MitraModel.fromJson(json)).toList();
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch mitra: $e');
    }
  }

  // Get mitra by ID
  Future<MitraModel> getMitraById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.mitras}/$id');
      return MitraModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch mitra: $e');
    }
  }

  // Create new mitra (Register)
  Future<MitraModel> createMitra(MitraModel mitra) async {
    try {
      final response = await _apiService.post(
        ApiConfig.mitras,
        body: mitra.toCreateJson(),
      );
      
      if (response['success'] == true && response['data'] != null) {
        return MitraModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to create mitra');
    } catch (e) {
      throw Exception('Failed to create mitra: $e');
    }
  }

  // Update mitra
  Future<MitraModel> updateMitra(String id, MitraModel mitra) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.mitras}/$id',
        body: mitra.toCreateJson(),
      );
      
      if (response['success'] == true && response['data'] != null) {
        return MitraModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to update mitra');
    } catch (e) {
      throw Exception('Failed to update mitra: $e');
    }
  }

  // Delete mitra
  Future<void> deleteMitra(String id) async {
    try {
      await _apiService.delete('${ApiConfig.mitras}/$id');
    } catch (e) {
      throw Exception('Failed to delete mitra: $e');
    }
  }

  // Login mitra
  Future<MitraModel?> loginMitra(String email, String password) async {
    try {
      final allMitra = await getAllMitra();
      
      for (var mitra in allMitra) {
        if (mitra.emailMitra == email && mitra.passwordMitra == password) {
          return mitra;
        }
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
