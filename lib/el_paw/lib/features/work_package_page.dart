import 'package:flutter/material.dart';
import 'work_package_list_frame.dart';

class WorkPackagePage extends StatelessWidget {
  const WorkPackagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WorkPackageListFrame(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'Work Package Content Goes Here',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
} 