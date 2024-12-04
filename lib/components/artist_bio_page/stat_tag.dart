import 'package:flutter/cupertino.dart';
import 'package:artist_profile/utility/custom_colors.dart';
import 'package:artist_profile/components/common/custom_alert_dialog.dart';

class StatTag extends StatelessWidget {
  final String type;
  final String label;
  final IconData icon;

  const StatTag({
    super.key,
    required this.type,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCupertinoDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: type,
          content: label,
          width: 200,
        ),
      ),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: CustomColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
