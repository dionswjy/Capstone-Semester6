class PetugasDashboardModel {
  final int totalPelanggan;
  final int totalMeter;
  final int komplainBaru;
  final int pengajuanPemasanganBaru;
  final int tagihanBelumLunas;

  PetugasDashboardModel({
    required this.totalPelanggan,
    required this.totalMeter,
    required this.komplainBaru,
    required this.pengajuanPemasanganBaru,
    required this.tagihanBelumLunas,
  });

  factory PetugasDashboardModel.fromJson(Map<String, dynamic> json) {
    return PetugasDashboardModel(
      totalPelanggan: json['total_pelanggan'] ?? 0,
      totalMeter: json['total_meter'] ?? 0,
      komplainBaru: json['komplain_baru'] ?? 0,
      pengajuanPemasanganBaru: json['pengajuan_pemasangan_baru'] ?? 0,
      tagihanBelumLunas: json['tagihan_belum_lunas'] ?? 0,
    );
  }
}
