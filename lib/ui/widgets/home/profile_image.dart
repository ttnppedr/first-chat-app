import 'package:first_chat_app/ui/widgets/home/online_indicator.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final bool online;

  const ProfileImage({required this.imageUrl, this.online = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(126),
            child: Image.network(
              imageUrl,
              width: 126,
              height: 126,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: online ? OnlineIndicator() : Container(),
          ),
        ],
      ),
    );
  }
}
