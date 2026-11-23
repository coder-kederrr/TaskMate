import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/data/models/task_model.dart';
import 'package:taskmate/presentation/providers/task_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('TaskProvider Filter Tests', () {
    test('1. Memilih Prioritas Tinggi menampilkan hanya tugas prioritas tinggi',
        () {
      final provider = TaskProvider();
      provider.setPriorityFilter(PriorityFilter.high);

      final tasks = provider.filteredTasks;
      expect(tasks.isNotEmpty, true);
      expect(tasks.every((t) => t.priority == TaskPriority.high), true);
    });

    test('2. Memilih Prioritas Rendah menampilkan hanya tugas prioritas rendah',
        () {
      final provider = TaskProvider();
      provider.setPriorityFilter(PriorityFilter.low);

      final tasks = provider.filteredTasks;
      expect(tasks.isNotEmpty, true);
      expect(tasks.every((t) => t.priority == TaskPriority.low), true);
    });

    test('3. Memilih Semua Prioritas mengembalikan semua prioritas', () {
      final provider = TaskProvider();
      final totalInitial = provider.filteredTasks.length;

      // Ubah ke low dulu
      provider.setPriorityFilter(PriorityFilter.low);
      expect(provider.filteredTasks.length < totalInitial, true);

      // Kembalikan ke all
      provider.setPriorityFilter(PriorityFilter.all);
      expect(provider.filteredTasks.length, totalInitial);
      expect(
        provider.filteredTasks.any((t) => t.priority == TaskPriority.high),
        true,
      );
      expect(
        provider.filteredTasks.any((t) => t.priority == TaskPriority.medium),
        true,
      );
      expect(
        provider.filteredTasks.any((t) => t.priority == TaskPriority.low),
        true,
      );
    });

    test(
        '4. Memilih Prioritas Tinggi lalu kategori tertentu tetap menghasilkan data yang benar',
        () {
      final provider = TaskProvider();
      // cat_mobile memiliki tugas dengan priority high (task_1)
      provider.setPriorityFilter(PriorityFilter.high);
      provider.setCategoryFilter('cat_mobile');

      final tasks = provider.filteredTasks;
      expect(tasks, isNotEmpty);
      expect(
        tasks.every((t) =>
            t.priority == TaskPriority.high && t.categoryId == 'cat_mobile'),
        true,
      );
    });

    test(
        '5. Mengubah status dari Belum Selesai ke Selesai tetap menghasilkan data yang benar',
        () {
      final provider = TaskProvider();

      provider.setStatusFilter(TaskStatusFilter.pending);
      expect(provider.filteredTasks.every((t) => !t.isCompleted), true);

      provider.setStatusFilter(TaskStatusFilter.completed);
      expect(provider.filteredTasks.every((t) => t.isCompleted), true);
    });

    test(
        '6. Mengubah prioritas kembali ke Semua Prioritas tidak menghapus filter kategori dan status',
        () {
      final provider = TaskProvider();

      // Set category dan status
      provider.setCategoryFilter('cat_mobile');
      provider.setStatusFilter(TaskStatusFilter.pending);
      provider.setPriorityFilter(PriorityFilter.low);

      // Kembalikan prioritas ke Semua Prioritas
      provider.setPriorityFilter(PriorityFilter.all);

      // Verifikasi filter kategori dan status tetap aktif
      expect(provider.selectedCategoryId, 'cat_mobile');
      expect(provider.statusFilter, TaskStatusFilter.pending);
      expect(provider.selectedPriority, PriorityFilter.all);

      final tasks = provider.filteredTasks;
      expect(tasks, isNotEmpty);
      expect(
        tasks.every((t) => t.categoryId == 'cat_mobile' && !t.isCompleted),
        true,
      );
    });

    test(
        '7. Menggunakan pencarian bersamaan dengan filter lain tetap berfungsi',
        () {
      final provider = TaskProvider();

      // cat_mobile memiliki tugas pending dengan kata 'Mobile' di judul dan nama kategori (task_1)
      provider.setCategoryFilter('cat_mobile');
      provider.setStatusFilter(TaskStatusFilter.pending);
      provider.setSearchQuery('Mobile');

      final tasks = provider.filteredTasks;
      expect(tasks, isNotEmpty);
      expect(
        tasks.every((t) =>
            t.categoryId == 'cat_mobile' &&
            !t.isCompleted &&
            (t.title.toLowerCase().contains('mobile') ||
                t.description.toLowerCase().contains('mobile') ||
                t.categoryName.toLowerCase().contains('mobile'))),
        true,
      );
    });

    test('8. Reset filter mengembalikan seluruh filter ke kondisi awal', () {
      final provider = TaskProvider();

      provider.setSearchQuery('makalah');
      provider.setCategoryFilter('cat_db');
      provider.setPriorityFilter(PriorityFilter.high);
      provider.setStatusFilter(TaskStatusFilter.completed);

      provider.resetFilters();

      expect(provider.searchQuery, '');
      expect(provider.selectedCategoryId, null);
      expect(provider.selectedPriority, PriorityFilter.all);
      expect(provider.statusFilter, TaskStatusFilter.all);
      expect(provider.filteredTasks.length, provider.totalTasksCount);
    });
  });
}
