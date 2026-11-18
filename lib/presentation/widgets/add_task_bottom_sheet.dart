import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final TaskModel? task;

  const AddTaskBottomSheet({
    super.key,
    this.task,
  });

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  String? _selectedCategoryId;
  String _selectedCategoryName = '';
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TaskPriority _selectedPriority;

  bool get _isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    final categories = context.read<TaskProvider>().categories;

    if (_isEditMode) {
      final task = widget.task!;
      _titleController = TextEditingController(text: task.title);
      _descController = TextEditingController(text: task.description);
      _selectedDate = task.deadline;
      _selectedTime = TimeOfDay(
        hour: task.deadline.hour,
        minute: task.deadline.minute,
      );
      _selectedPriority = task.priority;

      final matchingCategory = categories.where((c) => c.id == task.categoryId);
      if (matchingCategory.isNotEmpty) {
        _selectedCategoryId = task.categoryId;
        _selectedCategoryName = matchingCategory.first.name;
      } else if (categories.isNotEmpty) {
        _selectedCategoryId = categories.first.id;
        _selectedCategoryName = categories.first.name;
      } else {
        _selectedCategoryId = task.categoryId;
        _selectedCategoryName = task.categoryName;
      }
    } else {
      _titleController = TextEditingController();
      _descController = TextEditingController();
      _selectedDate = DateTime.now().add(const Duration(days: 1));
      _selectedTime = const TimeOfDay(hour: 23, minute: 59);
      _selectedPriority = TaskPriority.medium;

      if (categories.isNotEmpty) {
        _selectedCategoryId = categories.first.id;
        _selectedCategoryName = categories.first.name;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final defaultFirstDate = now.subtract(const Duration(days: 1));
    final firstDate = _selectedDate.isBefore(defaultFirstDate)
        ? _selectedDate.subtract(const Duration(days: 365))
        : defaultFirstDate;
    final defaultLastDate = now.add(const Duration(days: 365));
    final lastDate = _selectedDate.isAfter(defaultLastDate)
        ? _selectedDate.add(const Duration(days: 365))
        : defaultLastDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final deadline = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final taskProvider = context.read<TaskProvider>();

      if (_isEditMode) {
        final currentTask = widget.task!;
        final updatedTask = currentTask.copyWith(
          id: currentTask.id,
          createdAt: currentTask.createdAt,
          isCompleted: currentTask.isCompleted,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          categoryId: _selectedCategoryId ?? currentTask.categoryId,
          categoryName: _selectedCategoryName.isNotEmpty
              ? _selectedCategoryName
              : currentTask.categoryName,
          deadline: deadline,
          priority: _selectedPriority,
        );

        taskProvider.updateTask(updatedTask);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil diperbarui! ✨'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        final newTask = TaskModel(
          id: 'task_${DateTime.now().millisecondsSinceEpoch}',
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          categoryId: _selectedCategoryId ?? 'cat_general',
          categoryName: _selectedCategoryName,
          deadline: deadline,
          priority: _selectedPriority,
          isCompleted: false,
          createdAt: DateTime.now(),
        );

        taskProvider.addTask(newTask);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil ditambahkan! ✨'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = context.watch<TaskProvider>().categories;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isEditMode ? 'Edit Tugas' : 'Tambah Tugas Baru',
                      style: AppTextStyles.h3.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title Field
                CustomTextField(
                  controller: _titleController,
                  label: 'Judul Tugas',
                  hint: 'Contoh: Makalah Sistem Informasi Bab 3',
                  prefixIcon: Icons.title_rounded,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Judul tugas wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Category Dropdown
                Text(
                  'Mata Kuliah',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardElevated : Colors.white,
                    borderRadius: AppConstants.borderRadiusM,
                    border: Border.all(
                      color:
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value:
                          categories.any((cat) => cat.id == _selectedCategoryId)
                              ? _selectedCategoryId
                              : (categories.isNotEmpty
                                  ? categories.first.id
                                  : null),
                      isExpanded: true,
                      dropdownColor:
                          isDark ? AppColors.darkCardElevated : Colors.white,
                      items: categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.id,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: cat.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(cat.name,
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedCategoryId = val;
                            _selectedCategoryName =
                                categories.firstWhere((c) => c.id == val).name;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Deadline Row (Date & Time pickers)
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Deadline',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkCardElevated
                                    : Colors.white,
                                borderRadius: AppConstants.borderRadiusM,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded,
                                      size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormatter.formatMediumDate(
                                        _selectedDate),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _pickTime,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jam Pengumpulan',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkCardElevated
                                    : Colors.white,
                                borderRadius: AppConstants.borderRadiusM,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_rounded,
                                      size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Priority Selection
                Text(
                  'Prioritas Tugas',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildPriorityOption(
                      label: 'Rendah',
                      priority: TaskPriority.low,
                      color: AppColors.priorityLow,
                    ),
                    const SizedBox(width: 8),
                    _buildPriorityOption(
                      label: 'Sedang',
                      priority: TaskPriority.medium,
                      color: AppColors.priorityMedium,
                    ),
                    const SizedBox(width: 8),
                    _buildPriorityOption(
                      label: 'Tinggi',
                      priority: TaskPriority.high,
                      color: AppColors.priorityHigh,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Description Field
                CustomTextField(
                  controller: _descController,
                  label: 'Catatan / Instruksi Dosen (Opsional)',
                  hint: 'Detail pengerjaan, format berkas, link referensi...',
                  prefixIcon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Submit Button
                CustomButton(
                  text: _isEditMode ? 'Simpan Perubahan' : 'Simpan Tugas',
                  icon: Icons.check_rounded,
                  onPressed: _saveTask,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityOption({
    required String label,
    required TaskPriority priority,
    required Color color,
  }) {
    final isSelected = _selectedPriority == priority;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPriority = priority),
        borderRadius: AppConstants.borderRadiusS,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: AppConstants.borderRadiusS,
            border: Border.all(
              color: isSelected ? color : color.withOpacity(0.3),
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : color.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
