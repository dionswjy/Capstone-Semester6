import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/app/data/models/meter_model.dart';
import 'package:tirta_desa/core/values/api.dart';

class MeterService {
  final String _baseUrl = Api.baseUrl;

  // ──────────────────────────────────────────────
  // PELANGGAN
  // ──────────────────────────────────────────────

  /// GET /pelanggan  → daftar semua pelanggan
  Future<List<PelangganModel>> fetchPelanggan(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pelanggan'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((e) => PelangganModel.fromJson(e)).toList();
      }
      debugPrint('fetchPelanggan error ${response.statusCode}: ${response.body}');
      return [];
    } catch (e) {
      debugPrint('fetchPelanggan exception: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────
  // METER
  // ──────────────────────────────────────────────

  /// GET /meter  → daftar semua meter
  Future<List<MeterModel>> fetchMeter(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/meter'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // Endpoint mengembalikan { "data": [...] }
        final List<dynamic> list = body['data'] ?? body;
        return list.map((e) => MeterModel.fromJson(e)).toList();
      }
      debugPrint('fetchMeter error ${response.statusCode}: ${response.body}');
      return [];
    } catch (e) {
      debugPrint('fetchMeter exception: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────
  // CATAT METER
  // ──────────────────────────────────────────────

  /// GET /catat-meter  → semua catatan (untuk cari meter_lalu)
  Future<List<CatatMeterModel>> fetchCatatMeter(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/catat-meter'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> list = body['data'] ?? body;
        return list.map((e) => CatatMeterModel.fromJson(e)).toList();
      }
      debugPrint('fetchCatatMeter error ${response.statusCode}: ${response.body}');
      return [];
    } catch (e) {
      debugPrint('fetchCatatMeter exception: $e');
      return [];
    }
  }

  /// POST /admin/catat-meter  → simpan pencatatan meter baru
  Future<bool> simpanCatatMeter({
    required String token,
    required int meterId,
    required String bulan,
    required String petugasNama,
    required double angkaMeterLalu,
    required double angkaMeterKini,
    required double penggunaanM3,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/admin/catat-meter'),
        headers: _headers(token),
        body: jsonEncode({
          'meter_id': meterId,
          'bulan': bulan,
          'petugas_nama': petugasNama,
          'angka_meter_lalu': angkaMeterLalu,
          'angka_meter_kini': angkaMeterKini,
          'penggunaan_m3': penggunaanM3,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      debugPrint('simpanCatatMeter error ${response.statusCode}: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('simpanCatatMeter exception: $e');
      return false;
    }
  }

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // ──────────────────────────────────────────────
  // TAGIHAN
  // ──────────────────────────────────────────────

  /// GET /admin/tagihan  → semua data tagihan
  Future<List<TagihanModel>> fetchTagihan(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/admin/tagihan'),
        headers: _headers(token),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> list = body['data'] ?? body;
        return list.map((e) => TagihanModel.fromJson(e)).toList();
      }
      debugPrint('fetchTagihan error ${response.statusCode}: ${response.body}');
      return [];
    } catch (e) {
      debugPrint('fetchTagihan exception: $e');
      return [];
    }
  }

  // ──────────────────────────────────────────────
  // SCAN METER (OCR)
  // ──────────────────────────────────────────────

  /// POST /scan-meter  → OCR dari foto meteran, return angka_meter string
  /// Returns null jika gagal.
  Future<String?> scanMeter({
    required String token,
    required File imageFile,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/scan-meter'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final angka = body['angka_meter']?.toString() ?? '';
        debugPrint('scanMeter OCR result: $angka');
        return angka.isNotEmpty ? angka : null;
      }
      debugPrint('scanMeter error ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('scanMeter exception: $e');
      return null;
    }
  }
}
