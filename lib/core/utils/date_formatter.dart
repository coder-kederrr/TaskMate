class DateFormatter {
  static const List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> _monthsShort = [
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
    'Des',
  ];

  static String formatFullDate(DateTime dateTime) {
    final dayName = _days[dateTime.weekday - 1];
    final monthName = _months[dateTime.month - 1];
    return '$dayName, ${dateTime.day} $monthName ${dateTime.year}';
  }

  static String formatMediumDate(DateTime dateTime) {
    final monthName = _monthsShort[dateTime.month - 1];
    return '${dateTime.day} $monthName ${dateTime.year}';
  }

  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatMediumDate(dateTime)}, ${formatTime(dateTime)} WIB';
  }

  static String getRelativeTimeSpan(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      final daysAgo = (-difference.inDays);
      if (daysAgo == 0) {
        return 'Lewat deadline hari ini';
      }
      return 'Terlambat $daysAgo hari';
    }

    if (difference.inDays == 0) {
      if (difference.inHours <= 0) {
        return 'Kurang dari 1 jam';
      }
      return 'Tersisa ${difference.inHours} jam';
    } else if (difference.inDays == 1) {
      return 'Besok (${formatTime(deadline)})';
    } else {
      return '${difference.inDays} hari lagi';
    }
  }

  static bool isDueSoon(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    return !difference.isNegative && difference.inDays <= 2;
  }

  static bool isOverdue(DateTime deadline) {
    return deadline.isBefore(DateTime.now());
  }
}
