import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import '../../data/models/category_model.dart';
import '../../data/dummy/dummy_data.dart';
import '../../core/utils/date_formatter.dart';

enum TaskStatusFilter { all, pending, completed }

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  List<CategoryModel> _categories = [];

  String _searchQuery = '';
  String? _selectedCategoryId;
  TaskPriority? _selectedPriority;
  TaskStatusFilter _statusFilter = TaskStatusFilter.all;

  TaskProvider() {
    _tasks = List.from(DummyData.getTasks());
    _categories = List.from(DummyData.categories);
  }

  // Getters
  List<TaskModel> get allTasks => List.unmodifiable(_tasks);
  List<CategoryModel> get categories => List.unmodifiable(_categories);
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  TaskPriority? get selectedPriority => _selectedPriority;
  TaskStatusFilter get statusFilter => _statusFilter;

  List<TaskModel> get filteredTasks {
    return _tasks.where((task) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = task.title.toLowerCase().contains(query);
        final matchesDesc = task.description.toLowerCase().contains(query);
        final matchesCat = task.categoryName.toLowerCase().contains(query);
        if (!matchesTitle && !matchesDesc && !matchesCat) return false;
      }

      // Category filter
      if (_selectedCategoryId != null && _selectedCategoryId != 'all') {
        if (task.categoryId != _selectedCategoryId) return false;
      }

      // Priority filter
      if (_selectedPriority != null) {
        if (task.priority != _selectedPriority) return false;
      }

      // Status filter
      if (_statusFilter == TaskStatusFilter.pending && task.isCompleted) {
        return false;
      }
      if (_statusFilter == TaskStatusFilter.completed && !task.isCompleted) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  List<TaskModel> get upcomingTasks {
    final list = _tasks.where((t) => !t.isCompleted).toList();
    list.sort((a, b) => a.deadline.compareTo(b.deadline));
    return list;
  }

  int get totalTasksCount => _tasks.length;
  int get completedTasksCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasksCount => _tasks.where((t) => !t.isCompleted).length;
  int get highPriorityCount =>
      _tasks.where((t) => !t.isCompleted && t.priority == TaskPriority.high).length;
  int get dueSoonCount =>
      _tasks.where((t) => !t.isCompleted && DateFormatter.isDueSoon(t.deadline)).length;

  double get completionRate {
    if (_tasks.isEmpty) return 0.0;
    return completedTasksCount / totalTasksCount;
  }

  int getCategoryTaskCount(String categoryId) {
    return _tasks.where((t) => t.categoryId == categoryId).length;
  }

  // Actions
  void toggleTaskStatus(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners();
    }
  }

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void updateTask(TaskModel updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setStatusFilter(TaskStatusFilter filter) {
    _statusFilter = filter;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategoryId = null;
    _selectedPriority = null;
    _statusFilter = TaskStatusFilter.all;
    notifyListeners();
  }
}

