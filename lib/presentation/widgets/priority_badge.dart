import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/task_model.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool showIcon;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: config.textColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(config.icon, size: 12, color: config.textColor),
            const SizedBox(width: 4),
          ],
          Text(
            config.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _PriorityConfig _getConfig(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return _PriorityConfig(
          label: 'Tinggi',
          textColor: AppColors.priorityHigh,
          bgColor: AppColors.priorityHighBg,
          icon: Icons.flag_rounded,
        );
      case TaskPriority.medium:
        return _PriorityConfig(
          label: 'Sedang',
          textColor: AppColors.priorityMedium,
          bgColor: AppColors.priorityMediumBg,
          icon: Icons.outlined_flag_rounded,
        );
      case TaskPriority.low:
        return _PriorityConfig(
          label: 'Rendah',
          textColor: AppColors.priorityLow,
          bgColor: AppColors.priorityLowBg,
          icon: Icons.outlined_flag_rounded,
        );
    }
  }
}

class _PriorityConfig {
  final String label;
  final Color textColor;
  final Color bgColor;
  final IconData icon;

  _PriorityConfig({
    required this.label,
    required this.textColor,
    required this.bgColor,
    required this.icon,
  });
}

