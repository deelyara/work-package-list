import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../theme/app_theme.dart';
import '../../theme/button_styles.dart';

Future<void> showExportDialog(BuildContext context, String packageName) async {
  String fileFormat = 'XLIFF';
  String exportType = 'Entries with translation';
  String languageToExport = 'af-ZA';
  List<String> languageOptions = [
    'af-ZA',
    'de-DE',
    'fr-FR',
    'it-IT',
    'ru-RU',
    'ca-ES',
  ];
  
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: AppTheme.colorScheme.surfaceContainerHigh,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 520, maxHeight: 600),
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title (left-aligned)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Export work package set: $packageName',
                      style: AppTheme.textTheme.headlineSmall,
                    ),
                  ),
                ),
                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // File format dropdown
                        Text('File format', style: AppTheme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value: fileFormat,
                          items: [
                            'XLIFF',
                            'Excel (CSV, export only)',
                            'Client side translation (JS, export only)',
                            'Entries dumped in an HTML table (export only)',
                          ].map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: AppTheme.textTheme.bodyMedium),
                          )).toList(),
                          onChanged: (val) => setState(() => fileFormat = val ?? fileFormat),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Source language
                        Text('Source language', style: AppTheme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: AppTheme.colorScheme.outline, width: 0.5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: CountryFlag.fromCountryCode('US', width: 20, height: 14),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'English (United States) | en-US',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Languages to export dropdown
                        Text('Languages to export', style: AppTheme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value: languageToExport,
                          items: languageOptions.map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: AppTheme.textTheme.bodyMedium),
                          )).toList(),
                          onChanged: (val) => setState(() => languageToExport = val ?? languageToExport),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Export dropdown
                        Text('Export', style: AppTheme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value: exportType,
                          items: [
                            'All entries',
                            'Entries without translation',
                            'Entries with translation',
                          ].map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: AppTheme.textTheme.bodyMedium),
                          )).toList(),
                          onChanged: (val) => setState(() => exportType = val ?? exportType),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Checkboxes
                        CheckboxListTile(
                          value: false,
                          onChanged: (_) {},
                          title: Text('Resources included', style: AppTheme.textTheme.bodyMedium),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          value: true,
                          onChanged: (_) {},
                          title: Text('Exclude repetitions', style: AppTheme.textTheme.bodyMedium),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          value: false,
                          onChanged: (_) {},
                          title: Text(
                            'Trim export to contain as few tags and whitespaces as possible (experimental, safe to use)',
                            style: AppTheme.textTheme.bodyMedium,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          value: false,
                          onChanged: (_) {},
                          title: Text('Skip excluded and pending segments from export', style: AppTheme.textTheme.bodyMedium),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          value: false,
                          onChanged: (_) {},
                          title: Text('Copy source to target where empty (Wordfast Pro)', style: AppTheme.textTheme.bodyMedium),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        // Disabled option
                        IgnorePointer(
                          child: CheckboxListTile(
                            value: false,
                            onChanged: null,
                            title: Row(
                              children: [
                                Text('Send XLIFF files to ', style: AppTheme.textTheme.bodyMedium),
                                Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded, color: AppTheme.colorScheme.error, size: 16),
                                      const SizedBox(width: 4),
                                      Text('No external TMS configured!', style: AppTheme.textTheme.bodySmall?.copyWith(color: AppTheme.colorScheme.error)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Action buttons (no divider above)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel', style: AppTheme.textTheme.labelLarge),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: AppButtonStyles.primaryFilledButton,
                        child: AppButtonStyles.buttonText('Start export'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
} 