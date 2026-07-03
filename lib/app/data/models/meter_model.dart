/// Model untuk tabel pelanggan
class PelangganModel {
  final int id;
  final int userId;
  final String nama;
  final String alamat;
  final String noMeter;
  final String kategori;
  final String noHp;
  final String nik;
  final String statusPelanggan;
  final String jenisPelanggan;

  PelangganModel({
    required this.id,
    required this.userId,
    required this.nama,
    required this.alamat,
    required this.noMeter,
    required this.kategori,
    required this.noHp,
    required this.nik,
    required this.statusPelanggan,
    required this.jenisPelanggan,
  });

  factory PelangganModel.fromJson(Map<String, dynamic> json) {
    return PelangganModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      noMeter: json['no_meter'] ?? '-',
      kategori: json['kategori'] ?? '',
      noHp: json['no_hp'] ?? '',
      nik: json['nik'] ?? '',
      statusPelanggan: json['status_pelanggan'] ?? '',
      jenisPelanggan: json['jenis_pelanggan'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PelangganModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Model untuk tabel meter
class MeterModel {
  final int id;
  final int pelangganId;
  final String noMeter;
  final String statusMeter;
  final String alamatLokasi;

  MeterModel({
    required this.id,
    required this.pelangganId,
    required this.noMeter,
    required this.statusMeter,
    required this.alamatLokasi,
  });

  factory MeterModel.fromJson(Map<String, dynamic> json) {
    return MeterModel(
      id: json['id'] ?? 0,
      pelangganId: json['pelanggan_id'] ?? 0,
      noMeter: json['no_meter'] ?? '-',
      statusMeter: json['status_meter'] ?? '',
      alamatLokasi: json['alamat_lokasi'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeterModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Model untuk tabel catat_meter
class CatatMeterModel {
  final int id;
  final int meterId;
  final String bulan;
  final String petugasNama;
  final double angkaMeterLalu;
  final double angkaMeterKini;
  final double penggunaanM3;
  final String statusVerifikasi;

  CatatMeterModel({
    required this.id,
    required this.meterId,
    required this.bulan,
    required this.petugasNama,
    required this.angkaMeterLalu,
    required this.angkaMeterKini,
    required this.penggunaanM3,
    required this.statusVerifikasi,
  });

  factory CatatMeterModel.fromJson(Map<String, dynamic> json) {
    return CatatMeterModel(
      id: json['id'] ?? 0,
      meterId: json['meter_id'] ?? 0,
      bulan: json['bulan'] ?? '',
      petugasNama: json['petugas_nama'] ?? '',
      angkaMeterLalu: (json['angka_meter_lalu'] ?? 0).toDouble(),
      angkaMeterKini: (json['angka_meter_kini'] ?? 0).toDouble(),
      penggunaanM3: (json['penggunaan_m3'] ?? 0).toDouble(),
      statusVerifikasi: json['status_verifikasi'] ?? 'pending',
    );
  }
}

/// Model untuk tabel tagihan
class TagihanModel {
  final int id;
  final int meterId;
  final String bulan;
  final double penggunaanM3;
  final double totalTagihan;
  final String statusPembayaran;
  final String? tanggalBayar;

  TagihanModel({
    required this.id,
    required this.meterId,
    required this.bulan,
    required this.penggunaanM3,
    required this.totalTagihan,
    required this.statusPembayaran,
    this.tanggalBayar,
  });

  factory TagihanModel.fromJson(Map<String, dynamic> json) {
    return TagihanModel(
      id: json['id'] ?? 0,
      meterId: json['meter_id'] ?? 0,
      bulan: json['bulan'] ?? '',
      penggunaanM3: (json['penggunaan_m3'] ?? 0).toDouble(),
      totalTagihan: (json['total_tagihan'] ?? 0).toDouble(),
      statusPembayaran: json['status_pembayaran'] ?? '',
      tanggalBayar: json['tanggal_bayar'],
    );
  }
}
