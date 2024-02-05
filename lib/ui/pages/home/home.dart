import 'package:chat/chat.dart';
import 'package:first_chat_app/states_management/home/chats_cubit.dart';
import 'package:first_chat_app/states_management/home/home_cubit.dart';
import 'package:first_chat_app/states_management/home/home_state.dart';
import 'package:first_chat_app/states_management/message/message_bloc.dart';
import 'package:first_chat_app/ui/widgets/home/active/active_users.dart';
import 'package:first_chat_app/ui/widgets/home/chats/chats.dart';
import 'package:first_chat_app/ui/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<ChatsCubit>().chats();
    context.read<HomeCubit>().activeUsers();
    final user = User.fromJson({
      "id": "c750bf20-dabe-4007-ae4c-3be28690c989",
      "active": true,
      "photoUrl": "https://picsum.photos/seed/picc/200/300",
      "lastseen": DateTime.now(),
    });
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(user));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.maxFinite,
            child: Row(
              children: [
                ProfileImage(
                  imageUrl: "https://picsum.photos/seed/picc/200/300",
                  online: true,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Jess',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Online',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Messages'),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (_, state) => state is HomeSuccess
                            ? Text('Active(${state.onlineUsers.length})')
                            : Text('Active(0)')),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chats(),
            ActiveUsers(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
