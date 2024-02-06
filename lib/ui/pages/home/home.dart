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
  final User me;
  const Home(this.me);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = widget.me;
    _initialSetup();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.maxFinite,
            child: Row(
              children: [
                ProfileImage(
                  imageUrl: _user!.photoUrl!,
                  online: true,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        _user!.username!,
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
            Chats(_user!),
            ActiveUsers(),
          ],
        ),
      ),
    );
  }

  _initialSetup() async {
    final user =
        (!_user!.active) ? await context.read<HomeCubit>().connect() : _user;
    context.read<ChatsCubit>().chats();
    context.read<HomeCubit>().activeUsers(user!);
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(user));
  }

  @override
  bool get wantKeepAlive => true;
}
