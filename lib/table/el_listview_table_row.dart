import 'package:flutter/material.dart';
import 'package:work_package_list/theme/app_theme.dart';

import 'el_listview_table_cell_config.dart';

/// A reusable horizontal layout row for tables, allowing consistent `flex`
/// alignment between headers and data rows in an `ELTableListView`.
///
/// Use the same flex values for both header and row to ensure column alignment.

class ELListViewTableRow extends StatelessWidget {
  final List<ELTableCellConfig> cellConfigs;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool isLast;
  final bool selected;
  final void Function() onTap;

  const ELListViewTableRow({
    super.key,
    required this.cellConfigs,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isLast = false,
    this.selected = false,
    this.onTap = _noop,
  });

  static void _noop() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppTheme.colorScheme;
    return Container(
        decoration: BoxDecoration(
          color: selected ? colorScheme.surfaceContainer : colorScheme.surface,
          border: Border(
            left: BorderSide(color: colorScheme.outlineVariant, width: 1),
            right: BorderSide(color: colorScheme.outlineVariant, width: 1),
            bottom: BorderSide(color: colorScheme.outlineVariant, width: 1),
          ),
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )
              : BorderRadius.zero,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: isLast
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  )
                : BorderRadius.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                children: List.generate(children.length, (i) {
                  final config = cellConfigs[i];
                  return Flexible(
                    flex: config.flex,
                    child: config.isRowWrapped
                        ? Row(
                            mainAxisAlignment: config.alignment ?? MainAxisAlignment.start,
                            children: [children[i]],
                          )
                        : children[i],
                  );
                }),
              ),
            ),
          ),
        ));
  }
}
