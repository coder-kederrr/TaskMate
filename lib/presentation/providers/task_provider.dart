import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/task_model.dart';
import '../../data/models/category_model.dart';
import '../../data/dummy/dummy_data.dart';
import '../../core/utils/date_formatter.dart';

enum TaskStatusFilter { all, pending, completed }

enum PriorityFilter { all, high, medium, low }

class TaskProvider extends ChangeNotifier {
  static const String _storageKey = 'taskmate_saved_tasks';

  List<TaskModel> _tasks = [];
  List<CategoryModel> _categories = [];

  String _searchQuery = '';
  String? _selectedCategoryId;
  PriorityFilter _selectedPriority = PriorityFilter.all;
  TaskStatusFilter _statusFilter = TaskStatusFilter.all;

  bool _isInitializing = true;
  bool _hasLocalChangesDuringInit = false;
  bool _isSaving = false;
  bool _hasPendingSave = false;

  TaskProvider() {
    _tasks = List.from(DummyData.getTasks());
    _categories = List.from(DummyData.categories);
    _initPreferences();
  }

  // Inisialisasi data dari SharedPreferences
  Future<void> _initPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      // Jika ada perubahan lokal saat pembacaan SharedPreferences berlangsung,
      // jangan timpa data di memori dengan data lama dari SharedPreferences.
      if (_hasLocalChangesDuringInit) {
        _isInitializing = false;
        await _saveTasks();
        return;
      }

      if (jsonString != null && jsonString.trim().isNotEmpty) {
        final List<dynamic> decodedList =
            jsonDecode(jsonString) as List<dynamic>;
        final loadedTasks = decodedList.map((item) {
          return TaskModel.fromMap(Map<String, dynamic>.from(item as Map));
        }).toList();

        // Validasi kembali sebelum menimpa data di memori
        if (_hasLocalChangesDuringInit) {
          _isInitializing = false;
          await _saveTasks();
          return;
        }

        _tasks = loadedTasks;
        _isInitializing = false;
        notifyListeners();
      } else {
        // Belum ada data tersimpan, gunakan DummyData dan simpan via antrean _saveTasks()
        _tasks = List.from(DummyData.getTasks());
        _isInitializing = false;
        await _saveTasks();
      }
    } catch (e) {
      debugPrint('Gagal memuat tugas dari SharedPreferences: $e');
      _isInitializing = false;
      // Tangani kesalahan dengan aman
      if (!_hasLocalChangesDuringInit) {
        _tasks = List.from(DummyData.getTasks());
        notifyListeners();
      }
    }
  }

  // Notifikasi perubahan lokal dan picu penyimpanan aman
  void _onTasksChanged() {
    if (_isInitializing) {
      _hasLocalChangesDuringInit = true;
    }
    notifyListeners();
    _saveTasks();
  }

  // Mekanisme antrean penyimpanan untuk menghindari race condition
  Future<void> _saveTasks() async {
    if (_isSaving) {
      _hasPendingSave = true;
      return;
    }

    _isSaving = true;
    try {
      do {
        _hasPendingSave = false;
        await _performSave();
      } while (_hasPendingSave);
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _performSave() async {
    try {
      final snapshot = List<TaskModel>.from(_tasks);
      final encoded = jsonEncode(snapshot.map((t) => t.toMap()).toList());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Gagal menyimpan tugas ke SharedPreferences: $e');
    }
  }

  // Getters
  List<TaskModel> get allTasks => List.unmodifiable(_tasks);
  List<CategoryModel> get categories => List.unmodifiable(_categories);
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  PriorityFilter get selectedPriority => _selectedPriority;
  TaskStatusFilter get statusFilter => _statusFilter;

  List<TaskModel> get filteredTasks {
    return _tasks.where((task) {
      // Search filter (judul, deskripsi, mata kuliah / kategori)
      final trimmedQuery = _searchQuery.trim().toLowerCase();
      if (trimmedQuery.isNotEmpty) {
        final matchesTitle = task.title.toLowerCase().contains(trimmedQuery);
        final matchesDesc =
            task.description.toLowerCase().contains(trimmedQuery);
        final matchesCat =
            task.categoryName.toLowerCase().contains(trimmedQuery);
        if (!matchesTitle && !matchesDesc && !matchesCat) return false;
      }

      // Category filter
      if (_selectedCategoryId != null && _selectedCategoryId != 'all') {
        if (task.categoryId != _selectedCategoryId) return false;
      }

      // Priority filter
      switch (_selectedPriority) {
        case PriorityFilter.high:
          if (task.priority != TaskPriority.high) return false;
          break;
        case PriorityFilter.medium:
          if (task.priority != TaskPriority.medium) return false;
          break;
        case PriorityFilter.low:
          if (task.priority != TaskPriority.low) return false;
          break;
        case PriorityFilter.all:
          break;
      }

      // Status filter
      switch (_statusFilter) {
        case TaskStatusFilter.pending:
          if (task.isCompleted) return false;
          break;
        case TaskStatusFilter.completed:
          if (!task.isCompleted) return false;
          break;
        case TaskStatusFilter.all:
          break;
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
  int get highPriorityCount => _tasks
      .where((t) => !t.isCompleted && t.priority == TaskPriority.high)
      .length;
  int get dueSoonCount => _tasks
      .where((t) => !t.isCompleted && DateFormatter.isDueSoon(t.deadline))
      .length;

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
      _onTasksChanged();
    }
  }

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    _onTasksChanged();
  }

  void updateTask(TaskModel updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _onTasksChanged();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    _onTasksChanged();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setPriorityFilter(PriorityFilter priority) {
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
    _selectedPriority = PriorityFilter.all;
    _statusFilter = TaskStatusFilter.all;
    notifyListeners();
  }
}
