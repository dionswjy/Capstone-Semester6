import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/petugas_activity_log_controller.dart';

class PetugasActivityLogView
    extends GetView<PetugasActivityLogController> {
  const PetugasActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FB),
      appBar: AppBar(
        title: const Text(
          'Log Aktivitas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xff0D47A1),
        iconTheme: const IconThemeData(color: Color(0xff0D47A1)),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: Obx(() {
              final logs = controller.filteredLogs;
              if (logs.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final prevLog = index > 0 ? logs[index - 1] : null;
                  final showDateHeader = prevLog == null ||
                      !_isSameDay(log.time, prevLog.time);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDateHeader) _buildDateHeader(log.time),
                      _buildLogCard(log),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1),
          SizedBox(
            height: 52,
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  itemCount: controller.filterOptions.length,
                  itemBuilder: (context, index) {
                    final option = controller.filterOptions[index];
                    final isSelected =
                        controller.filterType.value == option;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => controller.setFilter(option),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xff0D47A1)
                                : const Color(0xffF0F4FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xff0D47A1),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    String label;
    if (_isSameDay(date, now)) {
      label = 'Hari Ini';
    } else if (_isSameDay(
        date, now.subtract(const Duration(days: 1)))) {
      label = 'Kemarin';
    } else {
      final months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ];
      label = '${date.day} ${months[date.month]} ${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xff6B7280),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLogCard(PetugasActivityLog log) {
    final iconData = _iconFor(log.type);
    final color = _colorFor(log.type);
    final timeStr =
        '${log.time.hour.toString().padLeft(2, '0')}:${log.time.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xff1A1C1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  log.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            timeStr,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xff9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xffF0F4FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history,
              size: 48,
              color: Color(0xff0D47A1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada aktivitas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff374151),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Belum ada log aktivitas untuk filter ini.',
            style: TextStyle(color: Color(0xff9CA3AF), fontSize: 13),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(PetugasActivityLogType type) {
    switch (type) {
      case PetugasActivityLogType.inputMeter:
        return Icons.speed_outlined;
      case PetugasActivityLogType.pengaduan:
        return Icons.bar_chart_outlined;
      case PetugasActivityLogType.pelanggan:
        return Icons.people_outline;
      case PetugasActivityLogType.profile:
        return Icons.person_outline;
      case PetugasActivityLogType.login:
        return Icons.login_outlined;
    }
  }

  Color _colorFor(PetugasActivityLogType type) {
    switch (type) {
      case PetugasActivityLogType.inputMeter:
        return const Color(0xff6A1B9A);
      case PetugasActivityLogType.pengaduan:
        return const Color(0xffE65100);
      case PetugasActivityLogType.pelanggan:
        return const Color(0xff0D47A1);
      case PetugasActivityLogType.profile:
        return const Color(0xff007C89);
      case PetugasActivityLogType.login:
        return const Color(0xff2E7D32);
    }
  }
}
