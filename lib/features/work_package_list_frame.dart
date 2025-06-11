import 'package:flutter/material.dart';
import 'package:work_package_list/theme/app_theme.dart';

class WorkPackageListFrame extends StatelessWidget {
  final Widget? child;
  final String title;
  final Widget? toolbar;
  const WorkPackageListFrame({Key? key, required this.title, this.child, this.toolbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.colorScheme;
    final textTheme = AppTheme.textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        elevation: 0,
        toolbarHeight: 65,
        // Add global controls here if needed
      ),
      body: Row(
        children: [
          // Left Navigation Panel
          Container(
            width: 320,
            color: colorScheme.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  child: Text('Setup', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                  child: Text('Site content', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                  child: Text('Team', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                  child: Text('Manage translations', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                  child: Text('Work package list', style: textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                  child: Text('Subscription', style: textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                  child: Text('Settings', style: textTheme.titleMedium),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Header (below AppBar)
                Container(
                  height: 65,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(color: colorScheme.outlineVariant, width: 1),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: textTheme.headlineSmall,
                    ),
                  ),
                ),
                // Toolbar section (if provided)
                if (toolbar != null)
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(color: colorScheme.outlineVariant, width: 1),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: toolbar!,
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