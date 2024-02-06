import 'package:chat/chat.dart';
import 'package:first_chat_app/cache/local_cache.dart';
import 'package:first_chat_app/states_management/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  IUserService _userService;
  ILocalCache _localCache;

  HomeCubit(this._userService, this._localCache) : super(HomeInitial());

  Future<User> connect() async {
    final userJson = _localCache.fetch('USER');
    userJson['lastseen'] = DateTime.now();
    userJson['active'] = true;

    final user = User.fromJson(userJson);
    await _userService.connect(user);
    return user;
  }

  Future<void> activeUsers(User user) async {
    emit(HomeLoading());
    final users = await _userService.online();
    emit(HomeSuccess(users));
  }
}
