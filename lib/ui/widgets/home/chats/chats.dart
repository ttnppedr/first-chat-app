import 'package:first_chat_app/colors.dart';
import 'package:first_chat_app/theme.dart';
import 'package:first_chat_app/ui/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats();

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.only(
          top: 30,
          right: 16,
        ),
        itemBuilder: (_, index) => _chatItem(),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: 3);
  }

  _chatItem() => ListTile(
        contentPadding: EdgeInsets.only(left: 16),
        leading: ProfileImage(
          imageUrl: "https://picsum.photos/seed/picc/200/300",
          online: true,
        ),
        title: Text(
          'Lisa',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14,
                color: isLightTheme(context) ? Colors.black : Colors.white,
              ),
        ),
        subtitle: Text(
          'Thank you so much',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isLightTheme(context) ? Colors.black54 : Colors.white70,
              ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '12pm',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 15,
                  width: 15,
                  color: kPrimary,
                  alignment: Alignment.center,
                  child: Text(
                    '2',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
