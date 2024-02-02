import 'package:first_chat_app/colors.dart';
import 'package:first_chat_app/theme.dart';
import 'package:flutter/material.dart';

class OnlineIndicator extends StatelessWidget {
  const OnlineIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: kIndicatorBubble,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLightTheme(context) ? Colors.white : Colors.black,
          width: 3,
        ),
      ),
    );
  }
}
