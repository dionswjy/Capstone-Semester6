import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/petugas_meter_detail_controller.dart';

class PetugasMeterDetailView
    extends GetView<PetugasMeterDetailController> {
  const PetugasMeterDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              Row(
                children: const [

                  Icon(
                    Icons.water_drop_outlined,
                    color: Color(0xff0D47A1),
                  ),

                  SizedBox(width: 8),

                  Text(
                    "TirtaDesa",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0D47A1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // CUSTOMER CARD
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(22),
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    CircleAvatar(
                      radius: 34,
                      backgroundColor:
                          const Color(0xff1565F9),

                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Budi Santoso",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Color(0xff0D47A1),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "ID: TD-2024-001",
                            style: TextStyle(
                              color:
                                  Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            "ALAMAT METER UTAMA",
                            style: TextStyle(
                              color:
                                  Colors.grey.shade700,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Jl. Melati No. 12, Desa Sumber Air",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // METER SAAT INI
              _infoCard(
                title: "Meteran Saat Ini",
                value: "1.240",
                unit: "m³",
                color: const Color(0xff1565F9),
                textColor: Colors.white,
              ),

              const SizedBox(height: 18),

              _infoCard(
                title: "Rata-rata Bulanan",
                value: "14.8",
                unit: "m³",
                color: Colors.white,
                textColor: const Color(0xff006D77),
              ),

              const SizedBox(height: 18),

              // STATUS
              Container(
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(22),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Status Pembayaran",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: const [

                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),

                        SizedBox(width: 10),

                        Text(
                          "Tidak Ada Tunggakan",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Riwayat\nPencatatan",
                    style: TextStyle(
                      fontSize: 34,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Filter Tahun",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _historyCard(
                month: "September 2023",
                date: "25 Sep 2023",
                meter: "1.240",
                usage: "15",
              ),

              _historyCard(
                month: "September 2023",
                date: "25 Sep 2023",
                meter: "1.225",
                usage: "12",
              ),

              _historyCard(
                month: "Agustus 2023",
                date: "27 Agt 2023",
                meter: "1.213",
                usage: "18",
              ),

              _historyCard(
                month: "Juli 2023",
                date: "29 Jul 2023",
                meter: "1.195",
                usage: "14",
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [

              Text(
                value,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(width: 8),

              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8),

                child: Text(
                  unit,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyCard({
    required String month,
    required String date,
    required String meter,
    required String usage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        children: [

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: const Color(0xffF3F7FF),
                  borderRadius:
                      BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.calendar_month,
                  color: Color(0xff0D47A1),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      month,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Text(
                      "Tanggal: $date",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              _historyItem(
                "Indeks Meter",
                "$meter m³",
              ),

              _historyItem(
                "Indeks Meter",
                "$usage m³",
                valueColor:
                    const Color(0xff006D77),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),

            decoration: BoxDecoration(
              color: const Color(0xffD7F8FF),
              borderRadius:
                  BorderRadius.circular(40),
            ),

            child: const Center(
              child: Text(
                "✓ Lunas / Selesai",
                style: TextStyle(
                  color: Color(0xff006D77),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyItem(
    String title,
    String value, {
    Color valueColor = Colors.black,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}