import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tirta_desa/app/data/models/meter_model.dart';

class PaymentDetailController extends GetxController {
  /// Tagihan yang dipilih — dikirim via Get.arguments
  late final TagihanModel tagihan;

  @override
  void onInit() {
    super.onInit();
    // Terima data tagihan dari halaman sebelumnya
    final args = Get.arguments;
    if (args is TagihanModel) {
      tagihan = args;
    } else {
      // Fallback kosong jika tidak ada argumen
      tagihan = TagihanModel(
        id: 0,
        meterId: 0,
        bulan: '-',
        penggunaanM3: 0,
        totalTagihan: 0,
        statusPembayaran: '-',
      );
    }
  }

  /// Format angka ke Rupiah
  String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format bulan: "2024-01" → "Januari 2024"
  String formatBulan(String bulan) {
    try {
      if (RegExp(r'^\d{4}-\d{2}').hasMatch(bulan)) {
        final date = DateFormat('yyyy-MM').parse(bulan);
        return DateFormat('MMMM yyyy', 'id_ID').format(date);
      }
    } catch (_) {}
    return bulan;
  }

  /// Format tanggal bayar dari ISO string
  String formatTanggalBayar(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) return '-';
    try {
      final dt = DateTime.parse(tanggal).toLocal();
      return DateFormat('dd MMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      return tanggal;
    }
  }

  /// Status label untuk badge
  String get statusLabel {
    switch (tagihan.statusPembayaran.toLowerCase()) {
      case 'lunas':
        return 'Lunas';
      case 'belum_lunas':
        return 'Belum Lunas';
      default:
        return tagihan.statusPembayaran;
    }
  }

  bool get isLunas => tagihan.statusPembayaran.toLowerCase() == 'lunas';

  /// ID transaksi tampilan
  String get trxId => '#TRX-${tagihan.id.toString().padLeft(6, '0')}';
}
