import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/core/values/api.dart';

class ActivityLogService {
  final String _baseUrl = Api.baseUrl;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// GET /dashboard → pelanggan_id, meter info, tagihan terbaru
  Future<Map<String, dynamic>?> fetchDashboard(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/dashboard'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('ActivityLogService.fetchDashboard: $e');
      return null;
    }
  }

  /// GET /meter → cari meter_id dari pelanggan_id
  Future<int?> fetchMeterIdByPelanggan(String token, int pelangganId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/meter'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> list = body['data'] ?? body;
        for (final m in list) {
          if ((m['pelanggan_id'] ?? 0) == pelangganId) {
            return m['id'] as int;
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('ActivityLogService.fetchMeterIdByPelanggan: $e');
      return null;
    }
  }

  /// GET /admin/tagihan → tagihan pelanggan ini (filter by meter_id)
  Future<List<Map<String, dynamic>>> fetchTagihanByMeter(
      String token, int meterId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/admin/tagihan'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> list = body['data'] ?? body;
        return list
            .where((t) => (t['meter_id'] ?? 0) == meterId)
            .map((t) => t as Map<String, dynamic>)
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('ActivityLogService.fetchTagihanByMeter: $e');
      return [];
    }
  }

  /// GET /catat-meter → catatan meter pelanggan ini (filter by meter_id)
  Future<List<Map<String, dynamic>>> fetchCatatMeterByMeter(
      String token, int meterId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/catat-meter'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> list = body['data'] ?? body;
        return list
            .where((c) => (c['meter_id'] ?? 0) == meterId)
            .map((c) => c as Map<String, dynamic>)
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('ActivityLogService.fetchCatatMeterByMeter: $e');
      return [];
    }
  }

  /// GET /admin/komplain → komplain pelanggan ini
  Future<List<Map<String, dynamic>>> fetchKomplainByPelanggan(
      String token, int pelangganId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/admin/komplain'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> list = body['data'] ?? body;
        return list
            .where((k) => (k['pelanggan_id'] ?? 0) == pelangganId)
            .map((k) => k as Map<String, dynamic>)
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('ActivityLogService.fetchKomplainByPelanggan: $e');
      return [];
    }
  }
}
