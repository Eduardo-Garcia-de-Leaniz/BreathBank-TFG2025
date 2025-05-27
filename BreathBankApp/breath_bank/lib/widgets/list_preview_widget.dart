import 'package:breath_bank/constants/strings.dart';
import 'package:flutter/material.dart';

class ListPreview extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final IconData icon;
  final bool isEvaluacion;
  final String Function(Map<String, dynamic>) getTitle;
  final String? Function(Map<String, dynamic>)? getSubtitle;
  final int maxItemsToShow;

  const ListPreview({
    super.key,
    required this.items,
    required this.icon,
    required this.isEvaluacion,
    required this.getTitle,
    this.getSubtitle,
    required this.maxItemsToShow,
  });

  @override
  State<ListPreview> createState() => _ListPreviewState();
}

class _ListPreviewState extends State<ListPreview> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Text(Strings.noData);
    }

    final itemsToShow =
        expanded
            ? widget.items
            : widget.items.take(widget.maxItemsToShow).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...itemsToShow.map(
          (item) => ListTile(
            leading: Icon(widget.icon, color: Colors.teal),
            title: Text(widget.getTitle(item)),
            subtitle:
                widget.getSubtitle != null
                    ? Text(widget.getSubtitle!(item) ?? '')
                    : null,
          ),
        ),
        if (widget.items.length > widget.maxItemsToShow)
          TextButton.icon(
            onPressed: () => setState(() => expanded = !expanded),
            icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
            label: Text(
              expanded ? Strings.seeLess : Strings.seeMore,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.teal[800],
              ),
            ),
          ),
      ],
    );
  }
}
