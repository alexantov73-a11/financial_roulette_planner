import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display Settings
          _buildSectionTitle(context, '🎨 Display'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<ThemeViewModel>(
                builder: (context, themeVM, _) => SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: themeVM.isDarkMode,
                  onChanged: (value) async {
                    await themeVM.toggleTheme();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Profile Settings
          _buildSectionTitle(context, '👤 Profile'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).pushNamed('/profile-edit');
              },
            ),
          ),
          const SizedBox(height: 24),

          // Notifications
          _buildSectionTitle(context, '🔔 Notifications'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<SettingsViewModel>(
                builder: (context, settingsVM, _) => SwitchListTile(
                  title: const Text('Enable Notifications'),
                  value: settingsVM.notificationsEnabled,
                  onChanged: (value) async {
                    await settingsVM.toggleNotifications(value);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // App Actions
          _buildSectionTitle(context, '⭐ App'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Rate App'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    context.read<SettingsViewModel>().requestAppReview();
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share App'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Share.share(
                      'Check out Financial Roulette Planner - Smart budget allocation! https://example.com',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About
          _buildSectionTitle(context, 'ℹ️ About'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAboutRow(context, 'Version', '1.0.0'),
                  const SizedBox(height: 12),
                  _buildAboutRow(context, 'Developer', 'Alex Antov'),
                  const SizedBox(height: 12),
                  _buildAboutRow(context, 'Platform', 'iOS & Android'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Danger Zone
          _buildSectionTitle(context, '⚠️ Danger Zone'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                'Clear All Data',
                style: TextStyle(color: Colors.red),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showClearDataDialog(context);
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAboutRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This action cannot be undone. All your goals, settings, and preferences will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<SettingsViewModel>().clearAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared')),
                );
              }
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
