import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/data/models/task_model.dart';
import 'package:taskmate/presentation/providers/task_provider.dart';
import 'package:taskmate/presentation/screens/task/task_detail_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
      '10. Halaman detail tugas tidak mengalami RenderFlex Overflow pada berbagai ukuran layar',
      (tester) async {
    final sampleTask = TaskModel(
      id: 'test_task_1',
      title: 'Tugas Proyek Rekayasa Perangkat Lunak Berorientasi Objek Lanjut',
      description: 'Detail deskripsi instruksi pengerjaan tugas akademik',
      categoryId: 'cat_rpl',
      categoryName: 'Rekayasa Perangkat Lunak Berorientasi Objek',
      deadline: DateTime(2026, 11, 25, 23, 59),
      priority: TaskPriority.high,
      isCompleted: false,
      createdAt: DateTime(2026, 11, 10, 8, 30),
    );

    // Test on small screen: 320x640
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TaskProvider()),
        ],
        child: MaterialApp(
          home: TaskDetailScreen(task: sampleTask),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Test on standard mobile screen: 360x800
    tester.view.physicalSize = const Size(360, 800);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Test on standard mobile screen: 390x844
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Test on larger mobile screen: 412x915
    tester.view.physicalSize = const Size(412, 915);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
