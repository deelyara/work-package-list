import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../models/work_package_models.dart';

class WorkPackageToolbar extends StatefulWidget {
  final List<FilterOption> filterOptions;
  final Function(List<FilterOption>) onFiltersChanged;

  const WorkPackageToolbar({
    Key? key,
    required this.filterOptions,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<WorkPackageToolbar> createState() => _WorkPackageToolbarState();
}

class _WorkPackageToolbarState extends State<WorkPackageToolbar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Filter button
        PopupMenuButton<String>(
          icon: Icon(
            Icons.filter_alt_outlined,
            color: AppTheme.colorScheme.onSurface,
            size: 20,
          ),
          tooltip: 'Filter work packages',
          offset: const Offset(-320, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppTheme.colorScheme.surfaceVariant,
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 500,
            maxHeight: 400,
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              enabled: false, // Disable hover effect on PopupMenuItem
              padding: EdgeInsets.zero, // Remove default padding
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setPopupState) => Container(
                  width: 450,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Filter header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Filter',
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      // Filter options - each with its own hover
                      ...widget.filterOptions.map((option) => Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _toggleFilter(option, setPopupState);
                          },
                          borderRadius: BorderRadius.circular(8),
                          hoverColor: AppTheme.colorScheme.primary.withOpacity(0.04),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            child: CheckboxListTile(
                              value: option.isChecked,
                              onChanged: (bool? value) {
                                _toggleFilter(option, setPopupState);
                              },
                              title: Text(
                                option.title,
                                style: AppTheme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                '(${option.count})',
                                style: AppTheme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: AppTheme.colorScheme.primary,
                              checkColor: AppTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      )),
                      const Divider(height: 24),
                      // Limit section
                      Row(
                        children: [
                          Text(
                            'Limit',
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 60,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '5',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorScheme.outline,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                filled: true,
                                fillColor: AppTheme.colorScheme.surface,
                              ),
                              style: AppTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _clearFilters(setPopupState);
                            },
                            child: Text(
                              'Clear',
                              style: AppTheme.textTheme.labelLarge?.copyWith(
                                color: AppTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              _applyFilters();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.colorScheme.primary,
                              foregroundColor: AppTheme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              'Show results',
                              style: AppTheme.textTheme.labelLarge?.copyWith(
                                color: AppTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // Generate button
        IconButton(
          onPressed: () {
            // Action for generating work package
          },
          icon: Icon(
            Icons.add_circle_outline_outlined,
            color: AppTheme.colorScheme.onSurface,
            size: 20,
          ),
          tooltip: 'Generate work package set',
        ),
      ],
    );
  }

  void _toggleFilter(FilterOption option, StateSetter setPopupState) {
    setPopupState(() {
      final index = widget.filterOptions.indexOf(option);
      widget.filterOptions[index] = FilterOption(
        title: option.title,
        isChecked: !option.isChecked,
        count: option.count,
      );
    });
  }

  void _clearFilters(StateSetter setPopupState) {
    setPopupState(() {
      for (int i = 0; i < widget.filterOptions.length; i++) {
        widget.filterOptions[i] = FilterOption(
          title: widget.filterOptions[i].title,
          isChecked: false,
          count: widget.filterOptions[i].count,
        );
      }
    });
  }

  void _applyFilters() {
    Navigator.of(context).pop();
    widget.onFiltersChanged(widget.filterOptions);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filters applied'),
        backgroundColor: AppTheme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 