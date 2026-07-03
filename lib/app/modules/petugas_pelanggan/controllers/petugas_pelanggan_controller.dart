import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tirta_desa/app/data/models/meter_model.dart';
import 'package:tirta_desa/app/data/services/meter_service.dart';

class PetugasPelangganController extends GetxController {
  final _box = GetStorage();
  final _service = MeterService();

  // State
  var pelangganList = <PelangganModel>[].obs;
  var filteredPelangganList = <PelangganModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  // Search controller
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadPelanggan();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  Future<void> _loadPelanggan() async {
    final token = _box.read('token');
    if (token == null) return;

    isLoading.value = true;
    hasError.value = false;

    try {
      final list = await _service.fetchPelanggan(token);
      pelangganList.assignAll(list);
      _filterList();
    } catch (e) {
      debugPrint('_loadPelanggan error: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() => _loadPelanggan();

  void _onSearchChanged() {
    _filterList();
  }

  void _filterList() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      filteredPelangganList.assignAll(pelangganList);
    } else {
      filteredPelangganList.assignAll(
        pelangganList.where((p) {
          return p.nama.toLowerCase().contains(query) ||
              p.noMeter.toLowerCase().contains(query) ||
              p.alamat.toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
