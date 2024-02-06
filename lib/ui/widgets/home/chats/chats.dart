import 'package:chat/chat.dart';
import 'package:first_chat_app/colors.dart';
import 'package:first_chat_app/states_management/home/chats_cubit.dart';
import 'package:first_chat_app/states_management/message/message_bloc.dart';
import 'package:first_chat_app/states_management/typing/typing_notification_bloc.dart';
import 'package:first_chat_app/theme.dart';
import 'package:first_chat_app/ui/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../models/chat.dart';

class Chats extends StatefulWidget {
  final User user;

  const Chats(this.user);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  var chats = [];
  var typingEvents = [];

  @override
  void initState() {
    super.initState();
    _updateChatsOnMessageReceived();
    context.read<ChatsCubit>().chats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(
      builder: (_, chats) {
        this.chats = chats;

        if (this.chats.isEmpty) {
          return Container();
        }

        context.read<TypingNotificationBloc>().add(
            TypingNotificationEvent.onSubscribed(widget.user,
                usersWithChat: chats.map((e) => e.from!.id!).toList()));

        return _buildListView();
      },
    );
  }

  _buildListView() {
    return ListView.separated(
        padding: EdgeInsets.only(
          top: 30,
          right: 16,
        ),
        itemBuilder: (_, index) => _chatItem(chats[index]),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: chats.length);
  }

  _chatItem(Chat chat) => ListTile(
        contentPadding: EdgeInsets.only(left: 16),
        leading: ProfileImage(
          imageUrl: chat.from!.photoUrl!,
          online: chat.from!.active,
        ),
        title: Text(
          chat.from!.username!,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14,
                color: isLightTheme(context) ? Colors.black : Colors.white,
              ),
        ),
        subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
          builder: (__, state) {
            if (state is TypingNotificationReceivedSuccess &&
                state.event.event == Typing.start &&
                state.event.from == chat.from!.id) {
              this.typingEvents.add(state.event.from);
            }

            if (state is TypingNotificationReceivedSuccess &&
                state.event.event == Typing.stop &&
                state.event.from == chat.from!.id) {
              this.typingEvents.add(state.event.from);
            }

            if (this.typingEvents.contains(chat.from!.id)) {
              return Text(
                'typing...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              );
            }

            return Text(
              chat.mostRecent!.message!.contents!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                    fontWeight:
                        chat.unread > 0 ? FontWeight.bold : FontWeight.normal,
                  ),
            );
          },
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('h:mm a').format(chat.mostRecent!.message!.timestamp!),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: chat.unread > 0
                    ? Container(
                        height: 15,
                        width: 15,
                        color: kPrimary,
                        alignment: Alignment.center,
                        child: Text(
                          chat.unread.toString(),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      );

  _updateChatsOnMessageReceived() {
    final chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await chatsCubit.viewModel.receivedMessage(state.message);
        chatsCubit.chats();
      }
    });
  }
}
