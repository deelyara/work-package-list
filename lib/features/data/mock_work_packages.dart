import '../models/work_package_models.dart';

class MockWorkPackages {
  static List<WorkPackage> getMockWorkPackages() {
    return [
      WorkPackage(
        created: 'June 1, 2025 00:10:27',
        name: 'ar-SA-untranslatedContent-website',
        languages: 'EN, ES, FR',
        wordCount: '2915',
        overallProgress: '75%',
        languagePackages: [
          LanguagePackage(
            languageCode: 'ar-SA',
            languageName: 'Arabic (Saudi Arabia)',
            totalWords: 2915,
            isLoading: true, // Show loading state for this language package
            stages: [
              TranslationStage(
                name: 'ar-SA-untranslatedContent-website #0', 
                proofreadProgress: 0.0725,
                translatedProgress: 0.0022,
                newProgress: 0.9253,
                words: 1500,
              ),
              TranslationStage(
                name: 'ar-SA-untranslatedContent-website #1', 
                proofreadProgress: 0.12,
                translatedProgress: 0.08,
                newProgress: 0.80,
                words: 915,
              ),
              TranslationStage(
                name: 'ar-SA-untranslatedContent-website #2', 
                proofreadProgress: 0.05,
                translatedProgress: 0.15,
                newProgress: 0.80,
                words: 500,
              ),
            ],
          ),
        ],
      ),
      WorkPackage(
        created: 'June 15, 2025 14:22:15',
        name: 'ar-SA-untranslatedContent-mobileApplicationLocalizationWithAdvancedFeatures',
        languages: 'EN, DE, IT',
        wordCount: '3650',
        overallProgress: '45%',
        languagePackages: [
          LanguagePackage(
            languageCode: 'de-DE',
            languageName: 'German (Germany)',
            totalWords: 3650,
            stages: [
              TranslationStage(
                name: 'ar-SA-untranslatedContent-mobileApp #0', 
                proofreadProgress: 0.15,
                translatedProgress: 0.25,
                newProgress: 0.60,
                words: 2000,
              ),
              TranslationStage(
                name: 'ar-SA-untranslatedContent-mobileApp #1', 
                proofreadProgress: 0.08,
                translatedProgress: 0.12,
                newProgress: 0.80,
                words: 1650,
              ),
            ],
          ),
          LanguagePackage(
            languageCode: 'it-IT',
            languageName: 'Italian (Italy)',
            totalWords: 3650,
            stages: [
              TranslationStage(
                name: 'ar-SA-untranslatedContent-mobileApp #0', 
                proofreadProgress: 0.10,
                translatedProgress: 0.20,
                newProgress: 0.70,
                words: 2000,
              ),
              TranslationStage(
                name: 'ar-SA-untranslatedContent-mobileApp #1', 
                proofreadProgress: 0.05,
                translatedProgress: 0.10,
                newProgress: 0.85,
                words: 1650,
              ),
            ],
          ),
        ],
      ),
      WorkPackage(
        created: 'July 3, 2025 09:45:33',
        name: 'ar-SA-untranslatedContent-docs',
        languages: 'EN, FR, RU, CA, DE, IT, ZH',
        wordCount: '9600',
        overallProgress: '90%',
        languagePackages: [
          LanguagePackage(
            languageCode: 'fr-FR',
            languageName: 'French (France)',
            totalWords: 9600,
            stages: [
              TranslationStage(
                name: 'ar-SA-untranslatedContent-docs #0', 
                proofreadProgress: 0.20,
                translatedProgress: 0.30,
                newProgress: 0.50,
                words: 2000,
              ),
              TranslationStage(
                name: 'ar-SA-untranslatedContent-docs #1', 
                proofreadProgress: 0.15,
                translatedProgress: 0.25,
                newProgress: 0.60,
                words: 2000,
              ),
            ],
          ),
          LanguagePackage(
            languageCode: 'ru-RU',
            languageName: 'Russian (Russia)',
            totalWords: 9600,
            stages: [
              TranslationStage(
                name: 'ar-SA-untranslatedContent-docs #0', 
                proofreadProgress: 0.25,
                translatedProgress: 0.35,
                newProgress: 0.40,
                words: 2000,
              ),
              TranslationStage(
                name: 'ar-SA-untranslatedContent-docs #1', 
                proofreadProgress: 0.18,
                translatedProgress: 0.27,
                newProgress: 0.55,
                words: 2000,
              ),
            ],
          ),
        ],
      ),
    ];
  }
} 