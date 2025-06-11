import 'package:flutter/material.dart';

import 'el_listview_table_header.dart';

/// A reusable, configurable widget for building table-style ListViews with
/// headers, optional reordering, and consistent row layouts.
///
/// Type parameter [T] is the type of each row item.
///
/// ## Features:
/// - Optional reordering support
/// - Separate empty and loading state handling
/// - Header and row cell layout synced via `flex` rules
/// - Optional padding customization
class ELListViewTable<T> extends StatelessWidget {
  /// The list of data entries to render.
  final List<T> rows;

  /// Builder for each row, must return a widget with the same flex layout as the headers.
  final Widget Function(BuildContext context, T item, int index, bool isLast) rowBuilder;

  /// Header row content, typically a list of `Flexible(...)` widgets with fixed flex factors.
  final ELListViewTableHeader header;

  /// Whether the table is in a loading state.
  final bool isLoading;

  /// Whether the table is considered empty (used to trigger [emptyState]).
  final bool isEmpty;

  /// Widget shown when `isEmpty` is true.
  final Widget? emptyState;

  /// Whether the list is reorderable (e.g., for drag-and-drop ordering).
  final bool isReorderable;

  /// Callback to update row order after a reorder action.
  final void Function(int oldIndex, int newIndex)? onReorder;

  /// Padding around the entire table view.
  final EdgeInsets padding;

  const ELListViewTable({
    super.key,
    required this.rows,
    required this.header,
    required this.rowBuilder,
    this.isLoading = false,
    this.isEmpty = false,
    this.emptyState,
    this.isReorderable = false,
    this.onReorder,
    this.padding = const EdgeInsets.symmetric(horizontal: 32),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildList(BuildContext context) {
      final listContent = ListView.builder(
        itemCount: rows.length,
        cacheExtent: 300,
        itemBuilder: (context, index) {
          return rowBuilder(context, rows[index], index, index == rows.length - 1);
        },
      );
      return listContent;
    }

    Widget buildReorderableList(BuildContext context) {
      return ReorderableListView(
        buildDefaultDragHandles: false,
        onReorder: onReorder!,
        children: List.generate(rows.length, (index) {
          final item = rows[index];
          return KeyedSubtree(
            key: ValueKey(item.hashCode), // Ensure a unique key per item
            child: rowBuilder(context, item, index, index == rows.length - 1),
          );
        }),
      );
    }

    return Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final effectiveHeight = constraints.maxHeight - 48;

            return Column(
              children: [
                /// Header row
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: header,
                ),

                /// Loading indicator
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  )

                /// Empty state fallback
                else if (isEmpty)
                  SizedBox(
                    height: effectiveHeight,
                    child: SingleChildScrollView(child: emptyState ?? const SizedBox.shrink()),
                  )

                /// Scrollable or reorderable list
                else
                  SizedBox(
                    height: effectiveHeight,
                    child: isReorderable && onReorder != null ? buildReorderableList(context) : buildList(context),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}