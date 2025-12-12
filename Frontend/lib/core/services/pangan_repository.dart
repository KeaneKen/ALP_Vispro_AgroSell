import '../models/pangan_model.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class PanganRepository {
  final ApiService _apiService = ApiService();

  // Get all pangan
  Future<List<PanganModel>> getAllPangan() async {
    try {
      final response = await _apiService.get(ApiConfig.pangans);
      
      if (response is List) {
        return response.map((json) => PanganModel.fromJson(Map<String, dynamic>.from(json))).toList();
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch pangan: $e');
    }
  }

  // Get pangan by ID
  Future<PanganModel> getPanganById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.pangans}/$id');
      return PanganModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch pangan: $e');
    }
  }

  // Create new pangan
  Future<PanganModel> createPangan(PanganModel pangan) async {
    try {
      final response = await _apiService.post(
        ApiConfig.pangans,
        body: pangan.toCreateJson(),
      );
      
      if (response['success'] == true && response['data'] != null) {
        return PanganModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to create pangan');
    } catch (e) {
      throw Exception('Failed to create pangan: $e');
    }
  }

  // Update pangan
  Future<PanganModel> updatePangan(String id, PanganModel pangan) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.pangans}/$id',
        body: pangan.toCreateJson(),
      );
      
      if (response['success'] == true && response['data'] != null) {
        return PanganModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to update pangan');
    } catch (e) {
      throw Exception('Failed to update pangan: $e');
    }
  }

  // Delete pangan
  Future<void> deletePangan(String id) async {
    try {
      await _apiService.delete('${ApiConfig.pangans}/$id');
    } catch (e) {
      throw Exception('Failed to delete pangan: $e');
    }
  }

  // Search pangan by name
  Future<List<PanganModel>> searchPangan(String query) async {
    try {
      final allPangan = await getAllPangan();
      return allPangan
          .where((pangan) => 
              pangan.namaPangan.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search pangan: $e');
    }
  }

  // Get pangan by price range
  Future<List<PanganModel>> getPanganByPriceRange(
      double minPrice, double maxPrice) async {
    try {
      final allPangan = await getAllPangan();
      return allPangan
          .where((pangan) =>
              pangan.hargaPangan >= minPrice && pangan.hargaPangan <= maxPrice)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch pangan by price range: $e');
    }
  }
}
