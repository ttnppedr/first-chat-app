import 'package:first_chat_app/colors.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class ProfileUpload extends StatelessWidget {
  const ProfileUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      width: 126,
      child: Material(
        color: isLightTheme(context) ? Color(0xFFF2F2F2) : Color(0xFF211E1E),
        borderRadius: BorderRadius.circular(126),
        child: InkWell(
          borderRadius: BorderRadius.circular(126),
          onTap: () {},
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 126,
                  color: isLightTheme(context) ? kIconLight : Colors.black,
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.add_circle_rounded,
                    color: kPrimary,
                    size: 38,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
