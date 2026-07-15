import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Notifikasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Tombol refresh
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: controller.loadNotifications,
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                  tooltip: 'Muat ulang',
                )),
          // Tombol tandai semua dibaca
          Obx(() {
            final hasUnread =
                controller.notifications.any((n) => !n.isRead);
            if (!hasUnread) return const SizedBox.shrink();
            return IconButton(
              onPressed: controller.markAllRead,
              icon: const Icon(LucideIcons.checkCheck),
              tooltip: 'Tandai semua dibaca',
            );
          }),
        ],
      ),
      body: Obx(() {
        // Loading
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryContainer,
            ),
          );
        }

        // Error
        if (controller.hasError.value) {
          return _buildErrorState();
        }

        // Kosong
        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        // List notifikasi
        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          color: AppColors.primaryContainer,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: controller.notifications.length + 1,
            itemBuilder: (context, index) {
              // Header summary unread
              if (index == 0) {
                return _buildSummaryHeader();
              }
              final notif = controller.notifications[index - 1];
              final prev = index > 1
                  ? controller.notifications[index - 2]
                  : null;

              // Header tanggal jika hari berbeda
              final showHeader = prev == null ||
                  !_isSameDay(notif.time, prev.time);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader) _buildDateHeader(notif.time),
                  _buildNotifCard(notif),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  // ── Summary unread count ────────────────────

  Widget _buildSummaryHeader() {
    final unread = controller.unreadCount;
    if (unread == 0) return const SizedBox(height: 4);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryContainer.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.bellRing,
              color: AppColors.primaryContainer, size: 18),
          const SizedBox(width: 10),
          Text(
            '$unread notifikasi belum dibaca',
            style: const TextStyle(
              color: AppColors.primaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: controller.markAllRead,
            child: const Text(
              'Tandai semua',
              style: TextStyle(
                color: AppColors.primaryContainer,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Date section header ─────────────────────

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    String label;
    if (_isSameDay(date, now)) {
      label = 'HARI INI';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      label = 'KEMARIN';
    } else {
      label = DateFormat('dd MMM yyyy', 'id_ID')
          .format(date)
          .toUpperCase();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.outline,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ── Notification card ───────────────────────

  Widget _buildNotifCard(AppNotification notif) {
    final color = _colorFor(notif.type);
    final icon = _iconFor(notif.type);
    final timeStr = _timeLabel(notif.time);
    final isRead = notif.isRead;

    return GestureDetector(
      onTap: () => controller.markRead(notif),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? Colors.white
              : AppColors.primaryContainer.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? AppColors.outline.withValues(alpha: 0.1)
                : AppColors.primaryContainer.withValues(alpha: 0.2),
            width: isRead ? 1 : 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontWeight: isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          color: AppColors.outline,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.body,
                    style: TextStyle(
                      color: isRead
                          ? AppColors.onSurfaceVariant
                          : AppColors.onSurface,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Unread dot
            if (!isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Empty state ─────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.bellOff,
              size: 48,
              color: AppColors.outline,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada notifikasi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Semua notifikasi akan muncul di sini.',
            style: TextStyle(
              color: AppColors.outline,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error state ─────────────────────────────

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.wifiOff, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.loadNotifications,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _timeLabel(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormat('dd MMM', 'id_ID').format(time);
  }

  IconData _iconFor(NotifType type) {
    switch (type) {
      case NotifType.tagihan:
        return LucideIcons.receipt;
      case NotifType.komplain:
        return LucideIcons.messageCircle;
      case NotifType.meter:
        return LucideIcons.gauge;
      case NotifType.info:
        return LucideIcons.info;
    }
  }

  Color _colorFor(NotifType type) {
    switch (type) {
      case NotifType.tagihan:
        return AppColors.primaryContainer;
      case NotifType.komplain:
        return const Color(0xFFE65100);
      case NotifType.meter:
        return const Color(0xFF6A1B9A);
      case NotifType.info:
        return Colors.blue;
    }
  }
}
