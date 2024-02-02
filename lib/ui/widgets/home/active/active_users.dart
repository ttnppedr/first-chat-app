import 'package:chat/chat.dart';
import 'package:first_chat_app/states_management/home/home_cubit.dart';
import 'package:first_chat_app/states_management/home/home_state.dart';
import 'package:first_chat_app/ui/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveUsers extends StatefulWidget {
  const ActiveUsers();

  @override
  State<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (_, state) {
        if (state is HomeLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is HomeSuccess) {
          return _buildList(state.onlineUsers);
        }
        return Container();
      },
    );
    // return ListView.separated(
    //     padding: EdgeInsets.only(top: 30, right: 16),
    //     itemBuilder: (BuildContext context, index) => _listItem(),
    //     separatorBuilder: (_, __) => Divider(),
    //     itemCount: 3);
  }

  _listItem(User user) => ListTile(
        leading: ProfileImage(
          imageUrl: user.photoUrl!,
          online: true,
        ),
        title: Text(
          'Anna',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

  _buildList(List<User> users) => ListView.separated(
        padding: EdgeInsets.only(top: 30, right: 16),
        itemBuilder: (BuildContext context, index) => _listItem(users[index]),
        separatorBuilder: (_, __) => Divider(),
        itemCount: users.length,
      );
}
