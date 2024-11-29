import 'package:flutter/material.dart';
import 'package:artist_profile/utility/app_constants.dart';

class SearchHistoryTile extends StatefulWidget {
  final double height;
  final Map<String, dynamic> historyItem;
  final int index;
  final Function(int index) onDelete;
  final Function(String searchText) onTap;

  const SearchHistoryTile({
    super.key,
    required this.height,
    required this.historyItem,
    required this.index,
    required this.onDelete,
    required this.onTap,
  });
  @override
  State<SearchHistoryTile> createState() => _SearchHistoryTileState();
}

class _SearchHistoryTileState extends State<SearchHistoryTile> {
  bool isTouching = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.searchPageMargin,
      ),
      color: isTouching ? Colors.grey[200] : Colors.transparent,
      child: GestureDetector(
        onTap: () => widget.onTap(widget.historyItem['searchText']),
        // When the user's finger touches the tile
        onPanDown: (_) {
          // Highlight the tile with a grey background
          setState(() {
            isTouching = true;
          });
        },
        // When the gesture ends
        onPanEnd: (_) {
          // Remove the grey background
          setState(() {
            isTouching = false;
          });
        },
        // When the user's finger moves away from the tile
        onPanCancel: () {
          // Remove the grey background
          setState(() {
            isTouching = false;
          });
        },
        child: Row(
          children: [
            // Leading icon
            Icon(Icons.history, size: 22, color: Colors.grey[600]),

            const SizedBox(width: 12), // Space between icon and text

            // Title text
            Expanded(
              child: Text(
                widget.historyItem['searchText'],
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 12), // Space between text and delete icon

            // Trailing delete icon button
            GestureDetector(
              onTap: () => widget.onDelete(widget.index),
              child: Icon(
                Icons.close,
                size: 20,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
