import '../models/mitra_model.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';
import 'package:flutter/foundation.dart';

class MitraRepository {
  final ApiService _apiService = ApiService();

  // Get all mitra
  Future<List<MitraModel>> getAllMitra() async {
    try {
      final response = await _apiService.get(ApiConfig.mitras);
      
      if (response is List) {
        return response.map((json) => MitraModel.fromJson(Map<String, dynamic>.from(json))).toList();
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
      
      // Handle response format with success wrapper
      if (response is Map && response['success'] == true && response['data'] != null) {
        return MitraModel.fromJson(Map<String, dynamic>.from(response['data']));
      } else if (response is Map && response['idMitra'] != null) {
        // Direct mitra object
        return MitraModel.fromJson(Map<String, dynamic>.from(response));
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch mitra: $e');
    }
  }

  // Create new mitra (Register)
  Future<MitraModel> createMitra(MitraModel mitra) async {
    try {
      debugPrint('MitraRepository: Creating mitra with data: ${mitra.toCreateJson()}');
      
      final response = await _apiService.post(
        ApiConfig.mitras,
        body: mitra.toCreateJson(),
      );
      
      debugPrint('MitraRepository: Response received: $response');
      
      if (response['success'] == true && response['data'] != null) {
        final createdMitra = MitraModel.fromJson(Map<String, dynamic>.from(response['data']));
        debugPrint('MitraRepository: Mitra created with ID: ${createdMitra.idMitra}');
        return createdMitra;
      }
      
      throw Exception(response['message'] ?? 'Failed to create mitra');
    } catch (e) {
      debugPrint('MitraRepository: Error creating mitra: $e');
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
        return MitraModel.fromJson(Map<String, dynamic>.from(response['data']));
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
      final response = await _apiService.post(
        '${ApiConfig.mitras}/login',
        body: {
          'Email_Mitra': email,
          'Password_Mitra': password,
        },
      );
      
      if (response['success'] == true && response['data'] != null) {
        return MitraModel.fromJson(Map<String, dynamic>.from(response['data']));
      }
      
      return null;
    } catch (e) {
      // Check if it's an authentication error (401) or Not Found (404)
      if (e is ApiException && (e.statusCode == 401 || e.statusCode == 404)) {
        return null; // Invalid credentials or User not found
      }
      // Fallback for string check if exception type is lost
      if (e.toString().contains('401') || e.toString().contains('Email tidak terdaftar')) {
        return null;
      }
      throw Exception('Failed to login: $e');
    }
  }
}
