import 'package:flutter/material.dart';

import 'el_listview_table_cell_config.dart';

/// A reusable horizontal header layout row for tables, allowing consistent `flex`
/// alignment between headers and data rows in an `ELTableListView`.
///
/// Use the same flex values for both header and row to ensure column alignment.
///
/// ### Example Usage
/// ```dart
/// ELListViewTableHeader(
///   cellConfigs: [
///     ELTableCellConfig(2),
///     ELTableCellConfig(3),
///     ELTableCellConfig(1, alignment: MainAxisAlignment.end)],
///   children: [
///     Text('John Doe'),
///     Text('john@example.com'),
///     Icon(Icons.more_vert),
///   ],
/// )
/// ```
class ELListViewTableHeader extends StatelessWidget {
  final List<ELTableCellConfig> cellConfigs;
  final List<Widget> children;
  final MainAxisAlignment rowMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;

  const ELListViewTableHeader({
    super.key,
    required this.cellConfigs,
    required this.children,
    this.rowMainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
  }) : assert(cellConfigs.length == children.length, 'cellConfigs and children length must match');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: rowMainAxisAlignment,
      crossAxisAlignment: rowCrossAxisAlignment,
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
    );
  }
}
