import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../models/work_package_models.dart';
import '../utils/work_package_utils.dart';
import '../data/mock_work_packages.dart';

void showExportDialog(BuildContext context, String workPackageName) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => ExportDialog(workPackageName: workPackageName),
  );
}

class ExportDialog extends StatefulWidget {
  final String workPackageName;

  const ExportDialog({Key? key, required this.workPackageName}) : super(key: key);

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String selectedFileFormat = 'XLIFF';
  String selectedExportType = 'Entries with translation';
  bool resourcesIncluded = false;
  bool excludeRepetitions = true;
  bool trimExport = false;
  bool skipExcludedSegments = false;
  bool copySourceToTarget = false;
  bool sendToTMS = false;
  Map<String, bool> selectedLanguageMap = {};

  final List<String> fileFormats = [
    'XLIFF',
    'Excel (CSV, export only)',
    'Client side translation (JS, export only)',
    'Entries dumped in an HTML table (export only)',
  ];

  final List<String> exportTypes = [
    'All entries',
    'Entries without translation',
    'Entries with translation',
  ];

  // Available languages from work packages
  List<LanguageOption> get availableLanguages {
    final workPackages = MockWorkPackages.getMockWorkPackages();
    final languageSet = <String, LanguageOption>{};
    
    for (final workPackage in workPackages) {
      for (final langPackage in workPackage.languagePackages) {
        languageSet[langPackage.languageCode] = LanguageOption(
          code: langPackage.languageCode,
          name: langPackage.languageName,
        );
      }
    }
    
    return languageSet.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  void initState() {
    super.initState();
    // Initialize with German (Germany) selected by default
    for (final lang in availableLanguages) {
      selectedLanguageMap[lang.code] = lang.code == 'de-DE';
    }
  }

  String get selectedLanguagesText {
    final selectedLangs = availableLanguages.where((lang) => selectedLanguageMap[lang.code] == true).toList();
    if (selectedLangs.isEmpty) {
      return 'No languages selected';
    } else if (selectedLangs.length == 1) {
      return selectedLangs.first.name;
    } else if (selectedLangs.length == 2) {
      return '${selectedLangs[0].name} and ${selectedLangs[1].name}';
    } else {
      return '${selectedLangs.first.name} and ${selectedLangs.length - 1} more';
    }
  }



  @override
  Widget build(BuildContext context) {
      return Dialog(
      backgroundColor: AppTheme.colorScheme.surfaceContainerHigh,
      surfaceTintColor: AppTheme.colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
              mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Title
            Text(
              'Export bilingual file ${widget.workPackageName}',
              style: AppTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // File format
            _buildSection(
              'File format',
              _buildStandardDropdown<String>(
                value: selectedFileFormat,
                items: fileFormats.map((format) => DropdownMenuItem(
                  value: format,
                    child: Text(
                    format,
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.colorScheme.onSurface,
                    ),
                  ),
                          )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFileFormat = value!;
                  });
                },
              ),
            ),

                                    // Source language
            _buildSection(
              'Source language',
              Row(
                children: [
                  WorkPackageUtils.getFlagIcon('en-US'),
                  const SizedBox(width: 8),
                  Text(
                    'English (United States)',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Languages to export
            _buildSection(
              'Languages to export',
              _buildMultiSelectDropdown(),
            ),

            // Export type
            _buildSection(
              'Export',
              _buildStandardDropdown<String>(
                value: selectedExportType,
                items: exportTypes.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.colorScheme.onSurface,
                    ),
                  ),
                          )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedExportType = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

                        // Checkboxes
            _buildCheckboxOption(
              'Resources included',
              resourcesIncluded,
              (value) => setState(() => resourcesIncluded = value ?? false),
            ),
            _buildCheckboxOption(
              'Exclude repetitions',
              excludeRepetitions,
              (value) => setState(() => excludeRepetitions = value ?? false),
            ),
            _buildCheckboxOption(
                            'Trim export to contain as few tags and whitespaces as possible (experimental, safe to use)',
              trimExport,
              (value) => setState(() => trimExport = value ?? false),
            ),
            _buildCheckboxOption(
              'Skip excluded and pending segments from export',
              skipExcludedSegments,
              (value) => setState(() => skipExcludedSegments = value ?? false),
            ),
            _buildCheckboxOption(
              'Copy source to target where empty (Wordfast Pro)',
              copySourceToTarget,
              (value) => setState(() => copySourceToTarget = value ?? false),
            ),

                        // TMS option with warning
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 0.9,
                      child: Checkbox(
                        value: sendToTMS,
                        onChanged: null, // Disabled
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Row(
                          children: [
                            Text(
                              'Send XLIFF files to ',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.colorScheme.outline.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(4),
                                color: AppTheme.colorScheme.surface.withOpacity(0.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'None',
                                    style: AppTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 16,
                                    color: AppTheme.colorScheme.onSurface.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Warning message directly below the TMS setting
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'No external TMS configured!',
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    // Handle export logic here
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export started successfully!'),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.colorScheme.primary,
                    foregroundColor: AppTheme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Start export',
                    style: AppTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCheckboxOption(String title, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 0.9,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                title,
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppTheme.colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppTheme.colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppTheme.colorScheme.outline),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          filled: false,
        ),
        items: items,
        onChanged: onChanged,
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppTheme.colorScheme.onSurfaceVariant,
        ),
        dropdownColor: AppTheme.colorScheme.surfaceContainerHighest,
        style: AppTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.colorScheme.onSurface,
        ),
        isExpanded: true,
        menuMaxHeight: 250, // Limit dropdown height
        elevation: 8,
      ),
    );
  }

  Widget _buildMultiSelectDropdown() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return PopupMenuButton<String>(
          tooltip: '', // Disable tooltip
          splashRadius: 0, // Disable splash
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedLanguagesText,
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppTheme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          color: AppTheme.colorScheme.surfaceContainerHighest,
          elevation: 8,
          position: PopupMenuPosition.under,
          clipBehavior: Clip.antiAlias,
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            maxWidth: constraints.maxWidth,
            maxHeight: 250, // Limit height to prevent overflow
          ),
          menuPadding: EdgeInsets.zero,
          itemBuilder: (BuildContext context) {
            return availableLanguages.map((lang) {
              return PopupMenuItem<String>(
                value: lang.code,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: StatefulBuilder(
                  builder: (context, setMenuState) {
                    final isSelected = selectedLanguageMap[lang.code] ?? false;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedLanguageMap[lang.code] = !isSelected;
                        });
                        setMenuState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedLanguageMap[lang.code] = value ?? false;
                                  });
                                  setMenuState(() {});
                                },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const SizedBox(width: 12),
                            WorkPackageUtils.getFlagIcon(lang.code),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                lang.name,
                                style: AppTheme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList();
          },
          onSelected: (String value) {
            // Don't close the menu immediately, let user continue selecting
          },
        );
      },
    );
  }
} 