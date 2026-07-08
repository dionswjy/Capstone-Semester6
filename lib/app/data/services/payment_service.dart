import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/app/data/models/meter_model.dart';
import 'package:tirta_desa/core/values/api.dart';

class PaymentService {
  final String _baseUrl = Api.baseUrl;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// GET /dashboard → data pelanggan + tagihan terbaru milik user ini
  Future<Map<String, dynamic>?> fetchDashboardPelanggan(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/dashboard'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      debugPrint('fetchDashboardPelanggan error ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('fetchDashboardPelanggan exception: $e');
      return null;
    }
  }

  /// GET /meter → cari meter_id berdasarkan pelanggan_id
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
      debugPrint('fetchMeterIdByPelanggan exception: $e');
      return null;
    }
  }

  /// GET /admin/tagihan → filter by meter_id → riwayat pembayaran pelanggan ini
  Future<List<TagihanModel>> fetchRiwayatTagihan(String token, int meterId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/admin/tagihan'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> list = body['data'] ?? body;
        final all = list.map((e) => TagihanModel.fromJson(e)).toList();
        // Filter hanya tagihan milik meter pelanggan ini, urutkan dari terbaru
        final filtered = all
            .where((t) => t.meterId == meterId)
            .toList()
          ..sort((a, b) => b.id.compareTo(a.id));
        return filtered;
      }
      debugPrint('fetchRiwayatTagihan error ${response.statusCode}: ${response.body}');
      return [];
    } catch (e) {
      debugPrint('fetchRiwayatTagihan exception: $e');
      return [];
    }
  }
}
