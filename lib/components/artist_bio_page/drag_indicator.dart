import 'package:flutter/material.dart';

class DragIndicator extends StatelessWidget {
  final ScrollController? sheetController;
  final ScrollController? listViewController;

  const DragIndicator({
    super.key,
    this.sheetController,
    this.listViewController,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Drag indicator style
          Container(
            // background
            width: double.infinity,
            height: 25,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),

            // Drag indicator
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),

          // Invisible SingleChildScrollView to control parent's DraggableScrollableSheet
          if (sheetController != null && listViewController != null)
            SingleChildScrollView(
              controller: sheetController,
              child: GestureDetector(
                onTap: () {
                  listViewController!.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 25,
                  color: Colors.transparent,
                  // drag indicator
                ),
              ),
            ),
        ],
      ),
    );
  }
}
