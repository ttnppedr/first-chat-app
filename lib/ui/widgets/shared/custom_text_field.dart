import 'package:first_chat_app/colors.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String val) onchanged;
  final double height;
  final TextInputAction inputAction;

  const CustomTextField({
    required this.hint,
    this.height = 54,
    required this.onchanged,
    required this.inputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        keyboardType: TextInputType.text,
        onChanged: onchanged,
        textInputAction: inputAction,
        cursorColor: kPrimary,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 8,
          ),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
      decoration: BoxDecoration(
        color: isLightTheme(context) ? Colors.white : kBubbleDark,
        borderRadius: BorderRadius.circular(45),
        border: Border.all(
          color: isLightTheme(context) ? Color(0xFFC4C4C4) : Color(0xFF393737),
          width: 1.5,
        ),
      ),
    );
  }
}
