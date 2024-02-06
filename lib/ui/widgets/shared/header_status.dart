import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../home/profile_image.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool online;
  final DateTime? lastSeen;
  final bool? typing;

  const HeaderStatus(this.username, this.imageUrl, this.online,
      {this.lastSeen, this.typing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          ProfileImage(
            imageUrl: imageUrl,
            online: online,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  username.trim(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: typing == null
                    ? Text(
                        online
                            ? 'Online'
                            : 'last seen ${DateFormat.yMd().add_jm().format(lastSeen!)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : Text(
                        'typing...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
