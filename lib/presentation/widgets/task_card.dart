import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/task_model.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onToggle;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDueSoon = DateFormatter.isDueSoon(task.deadline);
    final isOverdue = DateFormatter.isOverdue(task.deadline);

    Color deadlineColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    if (!task.isCompleted) {
      if (isOverdue) {
        deadlineColor = AppColors.error;
      } else if (isDueSoon) {
        deadlineColor = AppColors.warning;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: AppConstants.borderRadiusM,
        border: Border.all(
          color: task.isCompleted
              ? (isDark ? AppColors.darkBorder : AppColors.lightBorder.withOpacity(0.6))
              : (isDueSoon && !task.isCompleted
                  ? AppColors.warning.withOpacity(0.4)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppConstants.borderRadiusM,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Checkbox
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: InkWell(
                    onTap: () => onToggle?.call(!task.isCompleted),
                    borderRadius: BorderRadius.circular(6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? AppColors.primary
                            : (isDark ? AppColors.darkCardElevated : Colors.white),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: task.isCompleted
                              ? AppColors.primary
                              : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
                          width: 1.8,
                        ),
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Main Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted
                              ? (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary)
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Category & Subject Tag
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              task.categoryName,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Footer: Deadline & Priority
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Due Date info
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: deadlineColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormatter.getRelativeTimeSpan(task.deadline),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isDueSoon || isOverdue
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: deadlineColor,
                                ),
                              ),
                            ],
                          ),

                          // Priority Badge
                          PriorityBadge(
                            priority: task.priority,
                            showIcon: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

