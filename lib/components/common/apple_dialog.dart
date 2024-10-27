import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppleDialog extends StatelessWidget {
  final String title;
  final String content;

  const AppleDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.light,
      ),
      child: CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(content),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
