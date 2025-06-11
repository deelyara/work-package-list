import 'package:flutter/cupertino.dart';

/// Class that represents the config of a single table cell in a row
/// Flex has to be provided
/// Horizontal alignment defaults to start
/// By default each widget in a cell is wrapped in a Row to ensure the cell occupies all the horizontal space defined
/// by its flex factor. This can be overwritten by setting isRowWrapped to false, if the unique use-case requires a
/// different layout solution.

class ELTableCellConfig {
  final int flex;
  final MainAxisAlignment? alignment;
  final bool isRowWrapped;

  const ELTableCellConfig(this.flex, {this.alignment, this.isRowWrapped = true});
}
