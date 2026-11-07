import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../widgets/task_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/add_task_bottom_sheet.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.filteredTasks;
    final categories = taskProvider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Tugas Kuliah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded),
            tooltip: 'Tambah Tugas',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AddTaskBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (val) => taskProvider.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Cari tugas, topik, atau mata kuliah...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              taskProvider.setSearchQuery('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Status Filter Segment
                Row(
                  children: [
                    _buildStatusTab(
                      label: 'Semua (${taskProvider.totalTasksCount})',
                      filter: TaskStatusFilter.all,
                      active: taskProvider.statusFilter == TaskStatusFilter.all,
                      onTap: () => taskProvider.setStatusFilter(TaskStatusFilter.all),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusTab(
                      label: 'Belum Selesai (${taskProvider.pendingTasksCount})',
                      filter: TaskStatusFilter.pending,
                      active: taskProvider.statusFilter == TaskStatusFilter.pending,
                      onTap: () => taskProvider.setStatusFilter(TaskStatusFilter.pending),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusTab(
                      label: 'Selesai (${taskProvider.completedTasksCount})',
                      filter: TaskStatusFilter.completed,
                      active: taskProvider.statusFilter == TaskStatusFilter.completed,
                      onTap: () => taskProvider.setStatusFilter(TaskStatusFilter.completed),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Course Categories Filter Horizontal Scroll
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryChip(
                        label: 'Semua Mata Kuliah',
                        color: AppColors.primary,
                        isSelected: taskProvider.selectedCategoryId == null ||
                            taskProvider.selectedCategoryId == 'all',
                        onTap: () => taskProvider.setCategoryFilter(null),
                      ),
                      const SizedBox(width: 8),
                      ...categories.map((cat) {
                        final isSelected = taskProvider.selectedCategoryId == cat.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CategoryChip(
                            label: cat.name,
                            color: cat.color,
                            icon: cat.icon,
                            isSelected: isSelected,
                            onTap: () {
                              taskProvider.setCategoryFilter(isSelected ? null : cat.id);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Task Count & Active Filters Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menampilkan ${tasks.length} tugas',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                // Priority filter quick dropdown
                PopupMenuButton<TaskPriority?>(
                  tooltip: 'Filter Prioritas',
                  initialValue: taskProvider.selectedPriority,
                  onSelected: (p) => taskProvider.setPriorityFilter(p),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        size: 16,
                        color: taskProvider.selectedPriority != null
                            ? AppColors.primary
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        taskProvider.selectedPriority == null
                            ? 'Prioritas'
                            : (taskProvider.selectedPriority == TaskPriority.high
                                ? 'Tinggi'
                                : (taskProvider.selectedPriority == TaskPriority.medium
                                    ? 'Sedang'
                                    : 'Rendah')),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: taskProvider.selectedPriority != null
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('Semua Prioritas'),
                    ),
                    const PopupMenuItem(
                      value: TaskPriority.high,
                      child: Text('Prioritas Tinggi'),
                    ),
                    const PopupMenuItem(
                      value: TaskPriority.medium,
                      child: Text('Prioritas Sedang'),
                    ),
                    const PopupMenuItem(
                      value: TaskPriority.low,
                      child: Text('Prioritas Rendah'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Task List View
          Expanded(
            child: tasks.isEmpty
                ? EmptyStateView(
                    title: 'Tidak Ada Tugas Ditemukan',
                    message: 'Coba ubah kata kunci pencarian atau reset filter yang dipilih.',
                    buttonText: 'Reset Semua Filter',
                    onButtonPressed: () {
                      _searchController.clear();
                      taskProvider.resetFilters();
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTab({
    required String label,
    required TaskStatusFilter filter,
    required bool active,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : (isDark ? AppColors.darkCardElevated : Colors.white),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

