class WorkPackage {
  final String created;
  final String name;
  final String languages;
  final String wordCount;
  final String overallProgress;
  final List<LanguagePackage> languagePackages;

  WorkPackage({
    required this.created,
    required this.name,
    required this.languages,
    required this.wordCount,
    required this.overallProgress,
    required this.languagePackages,
  });
}

class LanguagePackage {
  final String languageCode;
  final String languageName;
  final int totalWords;
  final List<TranslationStage> stages;
  final bool isLoading;

  LanguagePackage({
    required this.languageCode,
    required this.languageName,
    required this.totalWords,
    required this.stages,
    this.isLoading = false,
  });
}

class TranslationStage {
  final String name;
  final double proofreadProgress;
  final double translatedProgress;
  final double newProgress;
  final int words;

  TranslationStage({
    required this.name,
    required this.proofreadProgress,
    required this.translatedProgress,
    required this.newProgress,
    required this.words,
  });

  // Legacy constructor for backward compatibility
  TranslationStage.simple({
    required this.name,
    required double progress,
    required this.words,
    required String status,
  }) : proofreadProgress = 0.0725,
       translatedProgress = 0.0022,
       newProgress = 0.9253;
}

class FilterOption {
  final String title;
  final bool isChecked;
  final int count;

  FilterOption({
    required this.title,
    required this.isChecked,
    required this.count,
  });
} 