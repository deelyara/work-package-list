import 'package:flutter/material.dart';
import 'work_package_list_frame.dart';
import '../theme/app_theme.dart';

// Import the extracted components
import 'models/work_package_models.dart';
import 'components/work_package_toolbar.dart';
import 'components/progress_components.dart';
import 'dialogs/export_dialog.dart';
import 'dialogs/generation_parameters_dialog.dart';
import 'utils/work_package_utils.dart';
import 'data/mock_work_packages.dart';

class WorkPackagePage extends StatefulWidget {
  const WorkPackagePage({Key? key}) : super(key: key);

  @override
  State<WorkPackagePage> createState() => _WorkPackagePageState();
}

class _WorkPackagePageState extends State<WorkPackagePage> {
  List<FilterOption> filterOptions = [
    FilterOption(title: 'Work packages without tag', isChecked: false, count: 0),
    FilterOption(title: 'Created by the Auto Pre-Translate process.', isChecked: false, count: 0),
    FilterOption(title: 'This work package set was started by a user manually.', isChecked: true, count: 1),
    FilterOption(title: 'This work package set was automatically filtered further, so no point showing on the Dashboard by default.', isChecked: false, count: 0),
    FilterOption(title: 'Created by filtering an already existing work package set.', isChecked: true, count: 3),
    FilterOption(title: 'Created in order to support the Search&Replace feature of the WorkBench.', isChecked: true, count: 0),
    FilterOption(title: 'This work package was collected by a crawl.', isChecked: true, count: 0),
    FilterOption(title: 'The crawl which collected this crawl ran with various remote contents per existing target languages.', isChecked: true, count: 0),
    FilterOption(title: 'Created in order to support the memory translation of the Content Connector\'s TMX upload feature.', isChecked: true, count: 0),
    FilterOption(title: 'Created by the Arboretum module to group all source entries contained by an uploaded file.', isChecked: true, count: 0),
    FilterOption(title: 'Created in order to support the Crest Bootstrap feature.', isChecked: true, count: 0),
  ];

  Set<int> expandedRows = {};
  Set<String> expandedLanguagePackages = {}; // Track expanded language packages
  Map<int, bool> progressReportGenerated = {}; // Track which work packages have progress reports generated
  Map<int, String> progressReportDates = {}; // Track progress report generation dates

  @override
  Widget build(BuildContext context) {
    // Get mock data
    final workPackages = MockWorkPackages.getMockWorkPackages();
    
    // Sort by date
    workPackages.sort((a, b) => WorkPackageUtils.parseDate(b.created).compareTo(WorkPackageUtils.parseDate(a.created)));

    return WorkPackageListFrame(
      title: 'Work package sets',
      toolbar: WorkPackageToolbar(
        filterOptions: filterOptions,
        onFiltersChanged: (updatedFilters) {
          setState(() {
            filterOptions = updatedFilters;
          });
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: workPackages.length + 1, // +1 for header
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildTableHeader();
                    }
                    final workPackageIndex = index - 1;
                    return _buildWorkPackageRow(
                      context,
                      workPackages[workPackageIndex],
                      workPackageIndex,
                      workPackageIndex == workPackages.length - 1,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
                      decoration: BoxDecoration(
                        color: AppTheme.colorScheme.surfaceContainerHighest,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text('Name', style: AppTheme.textTheme.titleSmall?.copyWith(color: AppTheme.colorScheme.onSurface)),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text('Created', style: AppTheme.textTheme.titleSmall?.copyWith(color: AppTheme.colorScheme.onSurface)),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text('Target languages', style: AppTheme.textTheme.titleSmall?.copyWith(color: AppTheme.colorScheme.onSurface)),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 24),
                                child: Text('Word count', style: AppTheme.textTheme.titleSmall?.copyWith(color: AppTheme.colorScheme.onSurface)),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text('Actions', style: AppTheme.textTheme.titleSmall?.copyWith(color: AppTheme.colorScheme.onSurface)),
                            ),
                          ),
                        ],
                      ),
    );
  }

  Widget _buildWorkPackageRow(BuildContext context, WorkPackage workPackage, int index, bool isLast) {
                          final isExpanded = expandedRows.contains(index);
                          
                          return Column(
                            children: [
                              // Main row
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.colorScheme.surface,
                                  border: Border(
                                    bottom: (isExpanded || isLast)
                                      ? BorderSide.none
                                      : BorderSide(
                                          color: AppTheme.colorScheme.outlineVariant,
                                          width: 1,
                                        ),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isExpanded) {
                                          expandedRows.remove(index);
                                        } else {
                                          expandedRows.add(index);
                                        }
                                      });
                                    },
                                    hoverColor: AppTheme.colorScheme.primary.withOpacity(0.04),
                                    splashColor: AppTheme.colorScheme.primary.withOpacity(0.1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                      child: Row(
                                        children: [
                    // Name with expand/collapse icon
                                          Expanded(
                                            flex: 5,
                      child: _buildNameColumn(workPackage, isExpanded),
                    ),
                    // Created date
                    Expanded(
                      flex: 2,
                      child: _buildCreatedColumn(workPackage),
                    ),
                    // Target languages flags
                    Expanded(
                      flex: 2,
                      child: _buildLanguagesColumn(workPackage),
                    ),
                    // Word count
                    Expanded(
                      flex: 2,
                      child: _buildWordCountColumn(workPackage),
                    ),
                    // Actions menu
                    Expanded(
                      flex: 1,
                      child: _buildActionsColumn(workPackage),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Expanded content
        if (isExpanded && workPackage.languagePackages.isNotEmpty)
          _buildExpandedContent(context, workPackage, index),
      ],
    );
  }

  Widget _buildNameColumn(WorkPackage workPackage, bool isExpanded) {
    return Padding(
                                              padding: const EdgeInsets.only(right: 16),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    isExpanded ? Icons.expand_less : Icons.expand_more,
                                                    size: 16,
                                                    color: AppTheme.colorScheme.onSurfaceVariant,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Tooltip(
                                                      message: workPackage.name,
                                                      child: Text(
                                                        workPackage.name,
                                                        style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.colorScheme.onSurface),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
    );
  }

  Widget _buildCreatedColumn(WorkPackage workPackage) {
    return Padding(
                                              padding: const EdgeInsets.only(left: 8),
                                              child: Tooltip(
                                                message: workPackage.created,
                                                child: Text(
          WorkPackageUtils.extractDate(workPackage.created),
                                                  style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.colorScheme.onSurface),
                                                ),
                                              ),
    );
  }

  Widget _buildLanguagesColumn(WorkPackage workPackage) {
    return Padding(
                                              padding: const EdgeInsets.only(left: 16),
                                              child: Row(
                                                children: [
                                                ...workPackage.languagePackages.take(4).map((langPackage) => 
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 4),
              child: WorkPackageUtils.getFlagIcon(langPackage.languageCode),
                                                  ),
                                                ),
                                                if (workPackage.languagePackages.length > 4)
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4),
                                                    child: Text(
                                                      '+${workPackage.languagePackages.length - 4}',
                                                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                                                        color: AppTheme.colorScheme.onSurface,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
    );
  }

  Widget _buildWordCountColumn(WorkPackage workPackage) {
    return Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
        padding: const EdgeInsets.only(right: 24),
                                                child: Text(
                                                  workPackage.wordCount,
                                                  style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.colorScheme.onSurface),
                                                ),
                                              ),
    );
  }

  Widget _buildActionsColumn(WorkPackage workPackage) {
    return Center(
                                              child: PopupMenuButton<String>(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: AppTheme.colorScheme.onSurface,
                                                ),
                                                onSelected: (String value) {
                                                  if (value == 'Export...') {
                                                    showExportDialog(context, workPackage.name);
                                                  } else if (value == 'View generation parameters') {
                                                    showGenerationParametersDialog(context);
                                                  }
          // Handle other menu items...
                                                },
                                                itemBuilder: (BuildContext context) => [
                                                  PopupMenuItem<String>(
                                                    value: 'Generate progress report',
                                                    child: ListTile(
                                                      leading: Icon(Icons.addchart_outlined, size: 20),
                                                      title: Text(
                                                        'Generate progress report',
                                                        style: AppTheme.textTheme.bodyMedium,
                                                      ),
                                                      contentPadding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                  PopupMenuItem<String>(
                                                    value: 'Export...',
                                                    child: ListTile(
                                                      leading: Icon(Icons.download, size: 20),
                                                      title: Text(
                                                        'Export...',
                                                        style: AppTheme.textTheme.bodyMedium,
                                                      ),
                                                      contentPadding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                  PopupMenuItem<String>(
                                                    value: 'Split by translation source',
                                                    child: ListTile(
                                                      leading: Icon(Icons.call_split, size: 20),
                                                      title: Text(
                                                        'Split by translation source',
                                                        style: AppTheme.textTheme.bodyMedium,
                                                      ),
                                                      contentPadding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                  PopupMenuItem<String>(
                                                    value: 'Create new Work package with the same settings',
                                                    child: ListTile(
                                                      leading: Icon(Icons.content_copy, size: 20),
                                                      title: Text(
                                                        'Create new work package with the same settings',
                                                        style: AppTheme.textTheme.bodyMedium,
                                                      ),
                                                      contentPadding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                  PopupMenuItem<String>(
                                                    value: 'View generation parameters',
                                                    child: ListTile(
                                                      leading: Icon(Icons.info_outline, size: 20),
                                                      title: Text(
                                                        'View generation parameters',
                                                        style: AppTheme.textTheme.bodyMedium,
                                                      ),
                                                      contentPadding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                ],
                                              ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, WorkPackage workPackage, int index) {
    return Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorScheme.surface,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppTheme.colorScheme.outlineVariant,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                                                              Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppTheme.colorScheme.surface,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppTheme.colorScheme.outlineVariant,
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                // Progress report header and button
                _buildProgressReportHeader(index),
                const SizedBox(height: 16),
                
                // Show overall progress if report is generated
                if (progressReportGenerated[index] == true) ...[
                  OverallProgressWidget(languagePackages: workPackage.languagePackages),
                  const SizedBox(height: 20),
                  Text(
                    'Target languages',
                    style: AppTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Language packages
                ...workPackage.languagePackages.map((langPackage) => 
                  _buildLanguagePackageItem(context, langPackage, index)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressReportHeader(int index) {
    if (progressReportGenerated[index] != true) {
      // Show simple header with generate button when report is not generated
      return Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Target languages',
                                                    style: AppTheme.textTheme.titleMedium?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        progressReportGenerated[index] = true;
                progressReportDates[index] = WorkPackageUtils.formatDateTime(DateTime.now());
                                                      });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Progress report generated successfully!')),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.addchart_outlined,
                                                      size: 20,
                                                      color: AppTheme.colorScheme.onSurface,
                                                    ),
                                                    tooltip: 'Generate progress report',
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(
                                                      minWidth: 32,
                                                      minHeight: 32,
                                                    ),
                                                  ),
                                                ],
      );
    } else {
      // Show full header with timestamp when report is generated
      return Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Overall progress',
                                                    style: AppTheme.textTheme.titleMedium?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  if (progressReportDates[index] != null) ...[
                                                    Tooltip(
                                                      message: 'Last report generation time',
                                                      child: Text(
                                                        progressReportDates[index]!,
                                                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                                                          color: AppTheme.colorScheme.onSurfaceVariant,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                  ],
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                progressReportDates[index] = WorkPackageUtils.formatDateTime(DateTime.now());
                                                      });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress report updated successfully!')),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.addchart_outlined,
                                                      size: 20,
                                                      color: AppTheme.colorScheme.onSurface,
                                                    ),
                                                    tooltip: 'Generate progress report',
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(
                                                      minWidth: 32,
                                                      minHeight: 32,
                                                    ),
                                                  ),
                                                ],
      );
    }
  }

    // Helper method to build loading widget for work packages
  Widget _buildLoadingWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.colorScheme.outlineVariant.withOpacity(0.8),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Loading spinner
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorScheme.primary),
            ),
          ),
          const SizedBox(width: 12),
          // Loading text
          Text(
            'Loading work packages...',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
                     const Spacer(),
        ],
      ),
    );
  }

  // Helper method to build placeholder badges
  Widget _buildPlaceholderBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                            decoration: BoxDecoration(
        color: AppTheme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.colorScheme.outline.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
                                                                    style: AppTheme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppTheme.colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildLanguagePackageItem(BuildContext context, LanguagePackage langPackage, int workPackageIndex) {
    final langKey = '${workPackageIndex}_${langPackage.languageCode}';
    final isLangExpanded = expandedLanguagePackages.contains(langKey);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isLangExpanded) {
                  expandedLanguagePackages.remove(langKey);
                } else {
                  expandedLanguagePackages.add(langKey);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Name Column
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Icon(
                          isLangExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: AppTheme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        WorkPackageUtils.getFlagIcon(langPackage.languageCode),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            langPackage.languageName,
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Section (Word Count)
                  const Spacer(),
                  Text(
                    '${langPackage.totalWords} words',
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
          if (isLangExpanded)
            Container(
              child: Column(
                children: langPackage.isLoading 
                  ? [_buildLoadingWidget()]
                  : langPackage.stages.map((stage) {
                    return Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.colorScheme.outlineVariant.withOpacity(0.8),
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Opening viewer for: ${stage.name}')),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        hoverColor: AppTheme.colorScheme.primary.withOpacity(0.04),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Row(
                            children: [
                              // Stage Name (optimized layout, not forced table alignment)
                              Expanded(
                                flex: 4,
                                child: Text(
                                  stage.name,
                                  style: AppTheme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              // Progress Badges Section (flex: 3)
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    // Progress Badges (horizontal row, no stacking)
                                    // Always show progress badges
                                    if (progressReportGenerated[workPackageIndex] == true) ...[
                                      // Show actual progress when report is generated
                                      if (stage.newProgress > 0) ...[
                                        buildProgressBadge(
                                          'New ${(stage.newProgress * 100).toStringAsFixed(0)}%', 
                                          const Color(0xFF00BCD4),
                                          tooltip: 'New: ${(stage.words * stage.newProgress).round()}/${stage.words} words',
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                      if (stage.proofreadProgress >= stage.translatedProgress) ...[
                                        if (stage.proofreadProgress > 0) ...[
                                          buildProgressBadge(
                                            'Proofread ${(stage.proofreadProgress * 100).toStringAsFixed(0)}%', 
                                            const Color(0xFF4CAF50),
                                            tooltip: 'Proofread: ${(stage.words * stage.proofreadProgress).round()}/${stage.words} words',
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                        if (stage.translatedProgress > 0)
                                          buildProgressBadge(
                                            'Translated ${(stage.translatedProgress * 100).toStringAsFixed(0)}%', 
                                            const Color(0xFF2196F3),
                                            tooltip: 'Translated: ${(stage.words * stage.translatedProgress).round()}/${stage.words} words',
                                          ),
                                      ] else ...[
                                        if (stage.translatedProgress > 0) ...[
                                          buildProgressBadge(
                                            'Translated ${(stage.translatedProgress * 100).toStringAsFixed(0)}%', 
                                            const Color(0xFF2196F3),
                                            tooltip: 'Translated: ${(stage.words * stage.translatedProgress).round()}/${stage.words} words',
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                        if (stage.proofreadProgress > 0)
                                          buildProgressBadge(
                                            'Proofread ${(stage.proofreadProgress * 100).toStringAsFixed(0)}%', 
                                            const Color(0xFF4CAF50),
                                            tooltip: 'Proofread: ${(stage.words * stage.proofreadProgress).round()}/${stage.words} words',
                                          ),
                                      ],
                                    ],
                                  ],
                                ),
                              ),
                              // Word Count Section (flex: 2)
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${stage.words} words',
                                  style: AppTheme.textTheme.bodySmall?.copyWith(
                                    color: AppTheme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              // Action Button with icon
                              TextButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Opening editor for: ${stage.name}')),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(70, 32),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                                icon: Icon(
                                  Icons.open_in_new,
                                  size: 16,
                                  color: AppTheme.colorScheme.primary,
                                ),
                                label: Text(
                                  'Open in editor',
                                  style: AppTheme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ),
            ),
        ],
      ),
    );
  }


}  