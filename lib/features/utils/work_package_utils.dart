import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../theme/app_theme.dart';
import '../models/work_package_models.dart';

class WorkPackageUtils {
  // Helper function to parse date string
  static DateTime parseDate(String dateStr) {
    // "June 1, 2025 00:10:27"
    final parts = dateStr.replaceAll(',', '').split(' '); // [June, 1, 2025, 00:10:27]
    if (parts.length < 4) return DateTime(1970); // fallback

    const monthMap = {
      'January': 1, 'February': 2, 'March': 3, 'April': 4, 'May': 5, 'June': 6,
      'July': 7, 'August': 8, 'September': 9, 'October': 10, 'November': 11, 'December': 12
    };

    final month = monthMap[parts[0]];
    final day = int.tryParse(parts[1]) ?? 1;
    final year = int.tryParse(parts[2]) ?? 1970;
    
    if (parts.length < 4 || month == null) return DateTime(1970);

    final timeParts = parts[3].split(':');
    final hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = int.tryParse(timeParts[1]) ?? 0;
    final second = int.tryParse(timeParts[2]) ?? 0;

    return DateTime(year, month, day, hour, minute, second);
  }

  // Helper function to calculate overall language progress as percentage
  static double calculateLanguageProgress(LanguagePackage langPackage) {
    if (langPackage.stages.isEmpty) return 0.0;
    
    int totalWords = 0;
    int completedWords = 0;
    
    for (final stage in langPackage.stages) {
      totalWords += stage.words;
      completedWords += (stage.words * (stage.proofreadProgress + stage.translatedProgress)).round();
    }
    
    return totalWords > 0 ? (completedWords / totalWords) : 0.0;
  }

  // Helper function to extract date from datetime string
  static String extractDate(String dateTimeString) {
    // Extract date part from "June 1, 2025 00:10:27" -> "June 1, 2025"
    final parts = dateTimeString.split(' ');
    if (parts.length >= 3) {
      return '${parts[0]} ${parts[1]} ${parts[2]}';
    }
    return dateTimeString;
  }

  // Helper function to format DateTime to readable string
  static String formatDateTime(DateTime dateTime) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final month = monthNames[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    
    return '$month $day, $year $hour:$minute:$second';
  }

  // Helper function to get rectangular flag icon
  static Widget getFlagIcon(String languageCode) {
    String countryCode = '';
    
    switch (languageCode.toLowerCase()) {
      case 'ar-sa':
        countryCode = 'SA';
        break;
      case 'de-de':
        countryCode = 'DE';
        break;
      case 'it-it':
        countryCode = 'IT';
        break;
      case 'fr-fr':
        countryCode = 'FR';
        break;
      case 'ru-ru':
        countryCode = 'RU';
        break;
      case 'ca-es':
        countryCode = 'ES';
        break;
      case 'zh-cn':
        countryCode = 'CN';
        break;
      case 'pt-br':
        countryCode = 'BR';
        break;
      case 'pt-pt':
        countryCode = 'PT';
        break;
      case 'ja-jp':
        countryCode = 'JP';
        break;
      case 'es-es':
        countryCode = 'ES';
        break;
      default:
        countryCode = 'US';
    }
    
    return Container(
      width: 20,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: AppTheme.colorScheme.outline, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: CountryFlag.fromCountryCode(
          countryCode,
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
    );
  }
} 