import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../models/work_package_models.dart';

// Helper function to build progress badges consistently
Widget buildProgressBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        color: color.withOpacity(0.3),
        width: 0.5,
      ),
    ),
    child: Text(
      text,
      style: AppTheme.textTheme.bodySmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color.withOpacity(1), // Use a solid color for text
      ),
    ),
  );
}

// Helper function to create multi-segment progress bar
Widget buildMultiSegmentProgressBar(TranslationStage stage) {
  return Container(
    height: 8,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: AppTheme.colorScheme.surfaceVariant,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Row(
        children: [
          // New segment (Light Blue/Cyan) - First
          if (stage.newProgress > 0)
            Expanded(
              flex: (stage.newProgress * 1000).round(),
              child: Container(
                color: const Color(0xFF00BCD4), // Cyan
              ),
            ),
          // Higher percentage between Proofread and Translated
          if (stage.proofreadProgress >= stage.translatedProgress) ...[
            if (stage.proofreadProgress > 0)
              Expanded(
                flex: (stage.proofreadProgress * 1000).round(),
                child: Container(
                  color: const Color(0xFF4CAF50), // Green
                ),
              ),
            if (stage.translatedProgress > 0)
              Expanded(
                flex: (stage.translatedProgress * 1000).round(),
                child: Container(
                  color: const Color(0xFF2196F3), // Blue
                ),
              ),
          ] else ...[
            if (stage.translatedProgress > 0)
              Expanded(
                flex: (stage.translatedProgress * 1000).round(),
                child: Container(
                  color: const Color(0xFF2196F3), // Blue
                ),
              ),
            if (stage.proofreadProgress > 0)
              Expanded(
                flex: (stage.proofreadProgress * 1000).round(),
                child: Container(
                  color: const Color(0xFF4CAF50), // Green
                ),
              ),
          ],
          // Remaining segment (background)
          if ((stage.proofreadProgress + stage.translatedProgress + stage.newProgress) < 1.0)
            Expanded(
              flex: ((1.0 - stage.proofreadProgress - stage.translatedProgress - stage.newProgress) * 1000).round(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
        ],
      ),
    ),
  );
}

// Overall progress widget for work packages
class OverallProgressWidget extends StatelessWidget {
  final List<LanguagePackage> languagePackages;

  const OverallProgressWidget({
    Key? key,
    required this.languagePackages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate overall progress from all language packages and their stages
    int totalWords = 0;
    int proofreadWords = 0;
    int translatedWords = 0;
    int newWords = 0;
    
    for (final lang in languagePackages) {
      for (final stage in lang.stages) {
        totalWords += stage.words;
        proofreadWords += (stage.words * stage.proofreadProgress).round();
        translatedWords += (stage.words * stage.translatedProgress).round();
        newWords += (stage.words * stage.newProgress).round();
      }
    }
    
    int remainingWords = totalWords - proofreadWords - translatedWords - newWords;
    // Avoid division by zero
    totalWords = totalWords == 0 ? 1 : totalWords;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppTheme.colorScheme.surfaceVariant,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Row(
                    children: [
                      if (newWords > 0)
                        Expanded(flex: newWords, child: Container(color: const Color(0xFF00BCD4))),
                      if (proofreadWords >= translatedWords) ...[
                        if (proofreadWords > 0)
                          Expanded(flex: proofreadWords, child: Container(color: const Color(0xFF4CAF50))),
                        if (translatedWords > 0)
                          Expanded(flex: translatedWords, child: Container(color: const Color(0xFF2196F3))),
                      ] else ...[
                        if (translatedWords > 0)
                          Expanded(flex: translatedWords, child: Container(color: const Color(0xFF2196F3))),
                        if (proofreadWords > 0)
                          Expanded(flex: proofreadWords, child: Container(color: const Color(0xFF4CAF50))),
                      ],
                      if (remainingWords > 0)
                        Expanded(flex: remainingWords, child: Container(color: Colors.transparent)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8, 
                        height: 8, 
                        decoration: const BoxDecoration(
                          color: Color(0xFF00BCD4), 
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'New: ${(100 * newWords / totalWords).toStringAsFixed(1)}%', 
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  if (proofreadWords >= translatedWords) ...[
                    Row(
                      children: [
                        Container(
                          width: 8, 
                          height: 8, 
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50), 
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Proofread: ${(100 * proofreadWords / totalWords).toStringAsFixed(1)}%', 
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Container(
                          width: 8, 
                          height: 8, 
                          decoration: const BoxDecoration(
                            color: Color(0xFF2196F3), 
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Translated: ${(100 * translatedWords / totalWords).toStringAsFixed(1)}%', 
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Container(
                          width: 8, 
                          height: 8, 
                          decoration: const BoxDecoration(
                            color: Color(0xFF2196F3), 
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Translated: ${(100 * translatedWords / totalWords).toStringAsFixed(1)}%', 
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Container(
                          width: 8, 
                          height: 8, 
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50), 
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Proofread: ${(100 * proofreadWords / totalWords).toStringAsFixed(1)}%', 
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
} 