import 'package:flutter/material.dart';
import 'features/work_package_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Package List',
      theme: AppTheme.lightTheme,
      home: const WorkPackagePage(),
    );
  }
}

