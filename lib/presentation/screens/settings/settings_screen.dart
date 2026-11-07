import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/theme_provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _deadlineReminderEnabled = true;
  bool _dailySummaryEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan & Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: AppConstants.borderRadiusL,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'M',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Mahasiswa',
                          style: AppTextStyles.h3.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user?.email ?? 'student@kampus.ac.id',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${user?.university ?? 'Kampus'} • Smtr ${user?.semester ?? 5}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section: Tampilan & Tema
            _buildSectionHeader('Tampilan & Tema', isDark),
            const SizedBox(height: 8),
            _buildCardGroup(
              isDark,
              children: [
                SwitchListTile.adaptive(
                  value: themeProvider.isDarkMode,
                  onChanged: (val) => themeProvider.toggleTheme(val),
                  title: const Text('Mode Gelap (Dark Mode)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Mengurangi kelelahan mata saat belajar malam', style: TextStyle(fontSize: 12)),
                  secondary: Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section: Notifikasi & Alarm
            _buildSectionHeader('Notifikasi & Pengingat', isDark),
            const SizedBox(height: 8),
            _buildCardGroup(
              isDark,
              children: [
                SwitchListTile.adaptive(
                  value: _deadlineReminderEnabled,
                  onChanged: (val) {
                    setState(() => _deadlineReminderEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val
                            ? 'Pengingat deadline diaktifkan'
                            : 'Pengingat deadline dinonaktifkan'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  title: const Text('Pengingat Deadline H-1', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Notifikasi 24 jam sebelum batas waktu pengumpulan', style: TextStyle(fontSize: 12)),
                  secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  value: _dailySummaryEnabled,
                  onChanged: (val) {
                    setState(() => _dailySummaryEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val
                            ? 'Ringkasan harian diaktifkan'
                            : 'Ringkasan harian dinonaktifkan'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  title: const Text('Ringkasan Pagi Hari (07:00)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Daftar agenda tugas untuk hari ini', style: TextStyle(fontSize: 12)),
                  secondary: const Icon(Icons.wb_sunny_outlined, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section: Penyimpanan & Sinkronisasi
            _buildSectionHeader('Database & Sinkronisasi', isDark),
            const SizedBox(height: 8),
            _buildCardGroup(
              isDark,
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_sync_outlined, color: AppColors.primary),
                  title: const Text('Firebase Cloud Sync', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Tahap Integrasi Database Online', style: TextStyle(fontSize: 12)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Next Phase', style: TextStyle(fontSize: 11, color: AppColors.info, fontWeight: FontWeight.w600)),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage_rounded, color: AppColors.primary),
                  title: const Text('SQLite Local Database', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Penyimpanan offline sqflite', style: TextStyle(fontSize: 12)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Next Phase', style: TextStyle(fontSize: 11, color: AppColors.info, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section: Tentang Aplikasi
            _buildSectionHeader('Tentang TaskMate', isDark),
            const SizedBox(height: 8),
            _buildCardGroup(
              isDark,
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: AppColors.primary),
                  title: Text('Versi Aplikasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text('TaskMate Student Planner v1.0.0 (Tahap UI & Navigasi)', style: TextStyle(fontSize: 12)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.school_outlined, color: AppColors.primary),
                  title: const Text('Dibuat Untuk Mahasiswa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Membantu produktivitas dan kelulusan tepat waktu', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'TaskMate',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 40),
                      children: const [
                        Text('TaskMate adalah aplikasi Student Task & Study Planner yang dirancang khusus untuk mahasiswa Indonesia.'),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppConstants.borderRadiusM,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Keluar dari Akun?'),
                      content: const Text('Kamu perlu masuk kembali untuk mengakses tugas kuliahmu.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            authProvider.logout();
                            Navigator.pop(ctx);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.login,
                              (route) => false,
                            );
                          },
                          child: const Text('Keluar', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Keluar dari Akun',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildCardGroup(bool isDark, {required List<Widget> children}) {
    return Material(
      color: isDark ? AppColors.darkCard : Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.borderRadiusM,
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(children: children),
    );
  }
}

