import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../theme/app_theme.dart';
import '../../theme/button_styles.dart';

Future<void> showGenerationParametersDialog(BuildContext context) async {
  // These would be passed in from the workPackage in a real app
  const splitBy = '2000';
  const separateHidden = false;
  const exportAsXliff = true;
  const exportWithoutTranslation = true;
  const entriesAfter = 'February 4, 2025 14:09:16';
  const entriesBefore = 'June 3, 2025 15:04:27';
  const timelineAfterLabel = 'Project created';
  const timelineBeforeLabel = 'Work package generation';

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: AppTheme.colorScheme.surfaceContainerHigh,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Generation parameters',
                    style: AppTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source language and creation method
                      Text('Source language', style: AppTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colorScheme.onSurface,
                      )),
                      const SizedBox(height: 12),
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
                              child: CountryFlag.fromCountryCode(
                                'US',
                                width: 20,
                                height: 14,
                              ) ?? Container(
                                width: 20,
                                height: 14,
                                color: AppTheme.colorScheme.primary,
                                child: Icon(
                                  Icons.flag,
                                  size: 12,
                                  color: AppTheme.colorScheme.onPrimary,
                                ),
                              ),
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
                      const SizedBox(height: 12),
                      // Creation method
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2, right: 8),
                            child: Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppTheme.colorScheme.primary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'This work package set was started by a user manually.',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Generation parameters
                      Text('Parameters', style: AppTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colorScheme.onSurface,
                      )),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: Text('Split package by:', style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ))),
                          Text(splitBy, style: AppTheme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colorScheme.onSurface,
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: Text('Create separate work package for hidden elements', style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ))),
                          Text(separateHidden ? 'Yes' : 'No', style: AppTheme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colorScheme.onSurface,
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: Text('Automatically export as XLIFF', style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ))),
                          Text(exportAsXliff ? 'Yes' : 'No', style: AppTheme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colorScheme.onSurface,
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: Text('Export entries without translation only', style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ))),
                          Text(exportWithoutTranslation ? 'Yes' : 'No', style: AppTheme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colorScheme.onSurface,
                          )),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text('Timeline', style: AppTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colorScheme.onSurface,
                      )),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text('Entries extracted after', style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ))),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(entriesAfter, style: AppTheme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.colorScheme.onSurface,
                                )),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(timelineAfterLabel, style: AppTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.colorScheme.onSurfaceVariant,
                                    )),
                                    const SizedBox(width: 4),
                                    Text('[-1]', style: AppTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.colorScheme.tertiary,
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text('Entries extracted before', style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ))),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(entriesBefore, style: AppTheme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.colorScheme.onSurface,
                                )),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(timelineBeforeLabel, style: AppTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.colorScheme.onSurfaceVariant,
                                    )),
                                    const SizedBox(width: 4),
                                    Text('[4]', style: AppTheme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.colorScheme.tertiary,
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: AppButtonStyles.primaryFilledButton,
                      child: AppButtonStyles.buttonText('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
} 