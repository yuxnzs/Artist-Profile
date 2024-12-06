import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:artist_profile/utility/custom_colors.dart';
import 'package:artist_profile/components/common/custom_alert_dialog.dart';
import 'package:artist_profile/components/common/placeholder_block.dart';

class BirthInfoBlock extends StatelessWidget {
  final IconData icon;
  final String? content;
  final String title;
  final bool isPlaceholder;

  const BirthInfoBlock({
    super.key,
    required this.icon,
    this.content,
    required this.title,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get the height of the content for placeholder
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: content ?? "",
        style: const TextStyle(fontSize: 14.5),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    // Show full content with dialog when tapped
    return GestureDetector(
      onTap: () {
        if (!isPlaceholder) {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                title: title,
                content: content ?? "No data",
                width: 200,
              );
            },
          );
        }
      },
      child: Container(
        width: 170,
        height: 60,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey[350]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: CustomColors.background,
                borderRadius: BorderRadius.circular(50),
              ),
              // Icon
              child: Icon(
                icon,
                size: 25,
                color: Colors.grey[800],
              ),
            ),
            // Between icon and content
            const SizedBox(width: 10),

            // Content Container
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),

                // Content
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (content == null && !isPlaceholder)
                      // Error icon
                      const Padding(
                        padding: EdgeInsets.only(right: 7),
                        child: Icon(
                          Icons.error,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    // Content
                    if (isPlaceholder)
                      PlaceholderBlock(
                        width: 90,
                        height: textPainter.size.height - 2,
                        borderRadius: 5,
                        topMargin: 6,
                      )
                    else
                      SizedBox(
                        // If content is null and display `No data`, set width to 65
                        width: content != null ? 105 : 65,
                        child: Text(
                          content ?? "No data",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
