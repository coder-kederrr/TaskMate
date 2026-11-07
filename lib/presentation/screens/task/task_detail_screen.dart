import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../widgets/priority_badge.dart';
import '../../widgets/custom_button.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taskProvider = context.watch<TaskProvider>();

    // Get live updated task from provider if it exists
    final currentTask = taskProvider.allTasks.firstWhere(
      (t) => t.id == task.id,
      orElse: () => task,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            tooltip: 'Hapus Tugas',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Tugas?'),
                  content: Text('Apakah kamu yakin ingin menghapus "${currentTask.title}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        taskProvider.deleteTask(currentTask.id);
                        Navigator.pop(ctx); // Close dialog
                        Navigator.pop(context); // Close detail screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tugas berhasil dihapus'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: currentTask.isCompleted
                    ? AppColors.priorityLowBg
                    : AppColors.primaryContainer,
                borderRadius: AppConstants.borderRadiusM,
                border: Border.all(
                  color: currentTask.isCompleted
                      ? AppColors.priorityLow.withOpacity(0.4)
                      : AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    currentTask.isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.pending_actions_rounded,
                    color: currentTask.isCompleted
                        ? AppColors.priorityLow
                        : AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentTask.isCompleted
                          ? 'Tugas ini sudah selesai dikerjakan! 🎉'
                          : 'Tugas masih dalam proses pengerjaan.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: currentTask.isCompleted
                            ? AppColors.priorityLow
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              currentTask.title,
              style: AppTextStyles.h2.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 20),

            // Meta Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: AppConstants.borderRadiusM,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  _buildMetaRow(
                    context,
                    icon: Icons.menu_book_rounded,
                    label: 'Mata Kuliah',
                    value: currentTask.categoryName,
                  ),
                  const Divider(height: 24),
                  _buildMetaRow(
                    context,
                    icon: Icons.calendar_today_rounded,
                    label: 'Deadline Pengumpulan',
                    value: DateFormatter.formatDateTime(currentTask.deadline),
                    valueWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormatter.formatDateTime(currentTask.deadline),
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        Text(
                          DateFormatter.getRelativeTimeSpan(currentTask.deadline),
                          style: TextStyle(
                            fontSize: 11,
                            color: DateFormatter.isDueSoon(currentTask.deadline)
                                ? AppColors.warning
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 24),
                  _buildMetaRow(
                    context,
                    icon: Icons.flag_rounded,
                    label: 'Tingkat Prioritas',
                    valueWidget: PriorityBadge(priority: currentTask.priority),
                  ),
                  const Divider(height: 24),
                  _buildMetaRow(
                    context,
                    icon: Icons.history_rounded,
                    label: 'Dibuat Pada',
                    value: DateFormatter.formatMediumDate(currentTask.createdAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Description / Instructions
            Text(
              'Instruksi & Catatan Tambahan',
              style: AppTextStyles.h4.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: AppConstants.borderRadiusM,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Text(
                currentTask.description.isNotEmpty
                    ? currentTask.description
                    : 'Tidak ada catatan atau instruksi tambahan untuk tugas ini.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Toggle Complete Button
            CustomButton(
              text: currentTask.isCompleted
                  ? 'Tandai Belum Selesai'
                  : 'Tandai Selesai Dikerjakan ✓',
              icon: currentTask.isCompleted
                  ? Icons.undo_rounded
                  : Icons.check_circle_outline_rounded,
              backgroundColor: currentTask.isCompleted
                  ? AppColors.lightTextSecondary
                  : AppColors.success,
              onPressed: () {
                taskProvider.toggleTaskStatus(currentTask.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      !currentTask.isCompleted
                          ? 'Mantap! Tugas selesai 🎉'
                          : 'Status tugas diubah menjadi belum selesai.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
    Widget? valueWidget,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const Spacer(),
        if (valueWidget != null)
          valueWidget
        else if (value != null)
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
      ],
    );
  }
}

