import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/presentation/providers/task_provider.dart';
import 'package:taskmate/presentation/screens/task/task_list_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('TaskListScreen Widget & Filter Tests', () {
    testWidgets(
        'Interaksi dropdown filter prioritas (Prioritas Rendah dan Semua Prioritas) pada TaskListScreen',
        (tester) async {
      final taskProvider = TaskProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
          ],
          child: const MaterialApp(
            home: TaskListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Pastikan halaman terbuka dengan benar
      expect(find.text('Semua Tugas Kuliah'), findsOneWidget);
      expect(find.text('Prioritas'), findsOneWidget);

      // Buka menu filter prioritas
      await tester.tap(find.byType(PopupMenuButton<PriorityFilter>));
      await tester.pumpAndSettle();

      // Pilih "Prioritas Rendah"
      await tester.tap(find.text('Prioritas Rendah').last);
      await tester.pumpAndSettle();

      expect(taskProvider.selectedPriority, PriorityFilter.low);

      // Verifikasi teks pada PopupMenuButton menampilkan 'Rendah'
      final popupFinder = find.byType(PopupMenuButton<PriorityFilter>);
      expect(
        find.descendant(of: popupFinder, matching: find.text('Rendah')),
        findsOneWidget,
      );

      // Buka kembali menu filter dan pilih "Semua Prioritas"
      await tester.tap(popupFinder);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Semua Prioritas').last);
      await tester.pumpAndSettle();

      expect(taskProvider.selectedPriority, PriorityFilter.all);
      expect(
        find.descendant(of: popupFinder, matching: find.text('Prioritas')),
        findsOneWidget,
      );
    });

    testWidgets(
        'Sinkronisasi SearchController pada TaskListScreen saat resetFilters() dipanggil',
        (tester) async {
      final taskProvider = TaskProvider();

      // 1. Tampilkan TaskListScreen
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
          ],
          child: const MaterialApp(
            home: TaskListScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final searchFieldFinder = find.byType(TextField);
      expect(searchFieldFinder, findsOneWidget);

      // 2. Isi kolom pencarian dengan teks tertentu
      const queryText = 'Algoritma Pemrograman';
      await tester.enterText(searchFieldFinder, queryText);
      await tester.pumpAndSettle();

      expect(taskProvider.searchQuery, queryText);
      expect(find.text(queryText), findsOneWidget);

      // 3. Panggil taskProvider.resetFilters() dari luar TextField
      taskProvider.resetFilters();
      await tester.pumpAndSettle();

      // 4. Verifikasi teks pada TextField ikut kosong
      expect(taskProvider.searchQuery, '');
      expect(find.text(queryText), findsNothing);
      final textField = tester.widget<TextField>(searchFieldFinder);
      expect(textField.controller?.text, '');

      // 5. Pastikan tidak ada exception
      expect(tester.takeException(), isNull);
    });
  });
}
