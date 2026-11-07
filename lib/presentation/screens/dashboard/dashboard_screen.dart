import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/task_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/add_task_bottom_sheet.dart';

class DashboardScreen extends StatelessWidget {
  final void Function(int index)? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthProvider>().user;
    final taskProvider = context.watch<TaskProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    final completionRate = taskProvider.completionRate;
    final upcomingTasks = taskProvider.upcomingTasks;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Greeting & Quick Profile / Theme
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, ${user?.name.split(' ').first ?? 'Mahasiswa'}! 👋',
                          style: AppTextStyles.h2.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Semester ${user?.semester ?? 5} • ${user?.major ?? 'Teknik Informatika'}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Dark / Light toggle button
                      IconButton(
                        onPressed: () {
                          themeProvider.toggleTheme(!themeProvider.isDarkMode);
                        },
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: isDark ? AppColors.warning : AppColors.lightTextPrimary,
                        ),
                        tooltip: 'Ganti Tema',
                      ),
                      // Profile Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'M',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Productivity Progress Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppConstants.borderRadiusL,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Target Belajar & Tugas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${(completionRate * 100).toInt()}% Selesai',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${taskProvider.completedTasksCount} dari ${taskProvider.totalTasksCount} tugas akademik telah diselesaikan',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: completionRate,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 7,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick Statistics
              Row(
                children: [
                  StatCard(
                    title: 'Total Tugas',
                    count: '${taskProvider.totalTasksCount}',
                    icon: Icons.assignment_outlined,
                    color: AppColors.info,
                    onTap: () => onNavigateTab?.call(1),
                  ),
                  const SizedBox(width: 10),
                  StatCard(
                    title: 'Deadline Dekat',
                    count: '${taskProvider.dueSoonCount}',
                    icon: Icons.timer_outlined,
                    color: AppColors.warning,
                    onTap: () => onNavigateTab?.call(1),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  StatCard(
                    title: 'Tugas Selesai',
                    count: '${taskProvider.completedTasksCount}',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                    onTap: () => onNavigateTab?.call(1),
                  ),
                  const SizedBox(width: 10),
                  StatCard(
                    title: 'Prioritas Tinggi',
                    count: '${taskProvider.highPriorityCount}',
                    icon: Icons.priority_high_rounded,
                    color: AppColors.error,
                    onTap: () => onNavigateTab?.call(1),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Course Categories Horizontal List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mata Kuliah Semester Ini',
                    style: AppTextStyles.h3.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: taskProvider.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final cat = taskProvider.categories[index];
                    final count = taskProvider.getCategoryTaskCount(cat.id);

                    return InkWell(
                      onTap: () {
                        taskProvider.setCategoryFilter(cat.id);
                        onNavigateTab?.call(1);
                      },
                      borderRadius: AppConstants.borderRadiusM,
                      child: Container(
                        width: 130,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: AppConstants.borderRadiusM,
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: cat.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(cat.icon, color: cat.color, size: 16),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '$count Tugas',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Upcoming Tasks Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Segera Dikumpulkan',
                    style: AppTextStyles.h3.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateTab?.call(1),
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Upcoming Tasks List
              if (upcomingTasks.isEmpty)
                EmptyStateView(
                  title: 'Semua Tugas Selesai! 🎉',
                  message: 'Tidak ada tugas yang menunggu deadline saat ini.',
                  buttonText: '+ Tambah Tugas Baru',
                  onButtonPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const AddTaskBottomSheet(),
                    );
                  },
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: upcomingTasks.length > 3 ? 3 : upcomingTasks.length,
                  itemBuilder: (context, index) {
                    final task = upcomingTasks[index];
                    return TaskCard(
                      task: task,
                      onToggle: (_) => taskProvider.toggleTaskStatus(task.id),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.taskDetail,
                          arguments: task,
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

