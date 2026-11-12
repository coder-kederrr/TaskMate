import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';

class DummyData {
  static const UserModel currentUser = UserModel(
    id: 'user_1',
    name: 'Dwi Bima Merdiyansyah',
    email: 'merdiyansyahdwibima@gmail.com',
    university: 'Universitas Yudharta Pasuruan',
    major: 'Teknik Informatika',
    semester: 7,
  );

  static final List<CategoryModel> categories = [
    const CategoryModel(
      id: 'cat_mobile',
      name: 'Pemrograman Mobile',
      code: 'TI-301',
      color: Color(0xFF4F46E5), // Indigo
      icon: Icons.phone_android_rounded,
    ),
    const CategoryModel(
      id: 'cat_db',
      name: 'Basis Data Lanjut',
      code: 'TI-204',
      color: Color(0xFFF59E0B), // Amber
      icon: Icons.storage_rounded,
    ),
    const CategoryModel(
      id: 'cat_ai',
      name: 'Kecerdasan Buatan',
      code: 'TI-305',
      color: Color(0xFF10B981), // Emerald
      icon: Icons.psychology_rounded,
    ),
    const CategoryModel(
      id: 'cat_rpl',
      name: 'Rekayasa Perangkat Lunak',
      code: 'TI-302',
      color: Color(0xFF3B82F6), // Blue
      icon: Icons.developer_mode_rounded,
    ),
    const CategoryModel(
      id: 'cat_jarkom',
      name: 'Jaringan Komputer',
      code: 'TI-201',
      color: Color(0xFFEC4899), // Pink
      icon: Icons.hub_rounded,
    ),
    const CategoryModel(
      id: 'cat_etika',
      name: 'Etika Profesi & Tekno',
      code: 'UM-102',
      color: Color(0xFF8B5CF6), // Purple
      icon: Icons.menu_book_rounded,
    ),
  ];

  static List<TaskModel> getTasks() {
    final now = DateTime.now();

    return [
      TaskModel(
        id: 'task_1',
        title: 'Project Mobile UI Slicing TaskMate',
        description:
            'Implementasikan antarmuka aplikasi TaskMate menggunakan Flutter. Terapkan design system modern dengan dukungan Light & Dark mode.',
        categoryId: 'cat_mobile',
        categoryName: 'Pemrograman Mobile',
        deadline: now.add(const Duration(hours: 4)),
        priority: TaskPriority.high,
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      TaskModel(
        id: 'task_2',
        title: 'Laporan Tugas Normalisasi Database',
        description:
            'Buat skema relasi dari 1NF sampai BCNF untuk sistem informasi rumah sakit beserta query DDL PostgreSQL.',
        categoryId: 'cat_db',
        categoryName: 'Basis Data Lanjut',
        deadline: now.add(const Duration(days: 1, hours: 2)),
        priority: TaskPriority.high,
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      TaskModel(
        id: 'task_3',
        title: 'Implementasi Algoritma Search A*',
        description:
            'Tulis kode Python untuk menyelesaikan grid pathfinding problem menggunakan Heuristic Manhattan Distance.',
        categoryId: 'cat_ai',
        categoryName: 'Kecerdasan Buatan',
        deadline: now.add(const Duration(days: 3)),
        priority: TaskPriority.medium,
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      TaskModel(
        id: 'task_4',
        title: 'Penyusunan Software Requirement Spec (SRS)',
        description:
            'Finalisasi diagram use case, activity diagram, dan matriks traceability fitur tim capstone.',
        categoryId: 'cat_rpl',
        categoryName: 'Rekayasa Perangkat Lunak',
        deadline: now.add(const Duration(days: 5)),
        priority: TaskPriority.medium,
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      TaskModel(
        id: 'task_5',
        title: 'Simulasi Subnetting VLSM Packet Tracer',
        description:
            'Konfigurasi router Cisco dengan routing dinamis OSPF dan verifikasi konektivitas ping antar departemen.',
        categoryId: 'cat_jarkom',
        categoryName: 'Jaringan Komputer',
        deadline: now.add(const Duration(days: 6)),
        priority: TaskPriority.low,
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      TaskModel(
        id: 'task_6',
        title: 'Esai Dampak GenAI Terhadap Hak Cipta',
        description:
            'Tulis analisis kritis minimal 1500 kata mengenai kepemilikan hak cipta pada konten hasil generative AI.',
        categoryId: 'cat_etika',
        categoryName: 'Etika Profesi & Tekno',
        deadline: now.add(const Duration(days: 7)),
        priority: TaskPriority.low,
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 6)),
      ),
    ];
  }
}
