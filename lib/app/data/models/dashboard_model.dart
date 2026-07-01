class UsageHistoryModel {
  final String bulan;
  final double penggunaan;

  UsageHistoryModel({
    required this.bulan,
    required this.penggunaan,
  });

  factory UsageHistoryModel.fromJson(Map<String, dynamic> json) {
    return UsageHistoryModel(
      bulan: json["bulan"] ?? "",
      penggunaan: (json["penggunaan"] ?? 0).toDouble(),
    );
  }
}

class DashboardModel {
  final String nama;
  final String email;
  final double penggunaanAir;
  final String statusPembayaran;
  final double totalTagihan;
  final String noMeter;
  final List<UsageHistoryModel> historiPenggunaan;

  DashboardModel({
    required this.nama,
    required this.email,
    required this.penggunaanAir,
    required this.statusPembayaran,
    required this.totalTagihan,
    required this.noMeter,
    required this.historiPenggunaan,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final list = json["histori_penggunaan"] as List? ?? [];
    final historyList = list.map((i) => UsageHistoryModel.fromJson(i)).toList();

    return DashboardModel(
      nama: json["nama"] ?? "",
      email: json["email"] ?? "",
      penggunaanAir:
          (json["penggunaan_air"] ?? 0).toDouble(),
      statusPembayaran:
          json["status_pembayaran"] ?? "Belum Bayar",
      totalTagihan:
          (json["total_tagihan"] ?? 0).toDouble(),
      noMeter:
          json["no_meter"] ?? "-",
      historiPenggunaan: historyList,
    );
  }
}