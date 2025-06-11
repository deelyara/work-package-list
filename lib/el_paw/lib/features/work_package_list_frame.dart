import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WorkPackageListFrame extends StatelessWidget {
  final Widget? child;
  const WorkPackageListFrame({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.colorScheme;
    final textTheme = AppTheme.textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Row(
        children: [
          // Left Navigation Panel
          Container(
            width: 320,
            color: colorScheme.surface,
            child: Column(
              children: [
                // Top space for alignment with top bar
                SizedBox(height: 65),
                // Example nav items (replace with your own)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Setup', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Site content', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Team', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Manage translations', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Work package list', style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Subscription', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Settings', style: textTheme.titleMedium),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Panel
                Container(
                  height: 65,
                  color: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Work package list',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                // Main Content
                Expanded(
                  child: Container(
                    color: colorScheme.background,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 