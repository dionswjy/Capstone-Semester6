import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/app/data/models/petugas_dashboard_model.dart';
import 'package:tirta_desa/core/values/api.dart';

class DashboardService {
  final String _baseUrl = Api.baseUrl;

  /// Mengambil data ringkasan dashboard petugas dari endpoint /admin/dashboard
  Future<PetugasDashboardModel?> fetchPetugasDashboard(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/admin/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PetugasDashboardModel.fromJson(data);
      } else {
        debugPrint('fetchPetugasDashboard error: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('fetchPetugasDashboard exception: $e');
      return null;
    }
  }
}
