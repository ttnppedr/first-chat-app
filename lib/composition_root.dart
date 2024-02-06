import 'package:chat/chat.dart';
import 'package:first_chat_app/data/factories/db_factory.dart';
import 'package:first_chat_app/data/services/image_uploader.dart';
import 'package:first_chat_app/states_management/home/chats_cubit.dart';
import 'package:first_chat_app/states_management/home/home_cubit.dart';
import 'package:first_chat_app/states_management/message/message_bloc.dart';
import 'package:first_chat_app/states_management/message_thread/message_thread_cubit.dart';
import 'package:first_chat_app/states_management/onboarding/onboarding_cubit.dart';
import 'package:first_chat_app/states_management/onboarding/profile_image_cubit.dart';
import 'package:first_chat_app/states_management/receipt/receipt_bloc.dart';
import 'package:first_chat_app/states_management/typing/typing_notification_bloc.dart';
import 'package:first_chat_app/ui/pages/home/home.dart';
import 'package:first_chat_app/ui/pages/home/home_router.dart';
import 'package:first_chat_app/ui/pages/message_thread/message_thread.dart';
import 'package:first_chat_app/ui/pages/onboarding/onboarding.dart';
import 'package:first_chat_app/ui/pages/onboarding/onboarding_router.dart';
import 'package:first_chat_app/viewmodels/chat_view_model.dart';
import 'package:first_chat_app/viewmodels/chats_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'cache/local_cache.dart';
import 'data/datasources/datasource_contract.dart';
import 'data/datasources/sqflite_datasource.dart';

class CompositionRoot {
  static RethinkDb? _r;
  static Connection? _connection;
  static IUserService? _userService;
  static Database? _db;
  static IMessageService? _messagesService;
  static IDatasource? _datasource;
  static ILocalCache? _localCache;
  static MessageBloc? _messageBloc;
  static ITypingNotificationService? _typingNotification;
  static TypingNotificationBloc? _typingNotificationBloc;
  static ChatsCubit? _chatsCubit;

  static configure() async {
    _r = RethinkDb();
    _connection = await _r!.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_r!, _connection);
    _messagesService = MessageService(_r!, _connection);
    _typingNotification = TypingNotification(_r!, _connection, _userService!);
    _db = await LocalDatabaseFactory().createDatabase();
    _datasource = SqfliteDatasource(_db!);
    final sp = await SharedPreferences.getInstance();
    _localCache = LocalCache(sp);
    _messageBloc = MessageBloc(_messagesService!);
    _typingNotificationBloc = TypingNotificationBloc(_typingNotification!);
    final viewModel = ChatsViewModel(_datasource!, _userService!);
    _chatsCubit = ChatsCubit(viewModel);
  }

  static Widget start() {
    final user = _localCache!.fetch('USER');
    return user.isEmpty
        ? composeOnboardingUi()
        : composeHomeUi(User.fromJson(user));
  }

  static Widget composeOnboardingUi() {
    ImageUploader imageUploader = ImageUploader('http://localhost:3000/upload');

    OnboardingCubit onboardingCubit =
        OnboardingCubit(_userService!, imageUploader, _localCache!);
    ProfileImageCubit imageCubit = ProfileImageCubit();
    IOnboardingRouter router = OnboardingRouter(composeHomeUi);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => onboardingCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: Onboarding(router),
    );
  }

  static Widget composeHomeUi(User me) {
    HomeCubit homeCubit = HomeCubit(_userService!, _localCache!);
    IHomeRouter router = HomeRouter(showMessageThread: composeMessageThreadUi);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => homeCubit),
        BlocProvider(create: (BuildContext context) => _messageBloc!),
        BlocProvider(
            create: (BuildContext context) => _typingNotificationBloc!),
        BlocProvider(create: (BuildContext context) => _chatsCubit!),
      ],
      child: Home(me, router),
    );
  }

  static Widget composeMessageThreadUi(User receiver, User me,
      {String? chatId}) {
    ChatViewModel viewModel = ChatViewModel(_datasource!);
    MessageThreadCubit messageThreadCubit = MessageThreadCubit(viewModel);
    IReceiptService receiptService = ReceiptService(_r!, _connection!);
    ReceiptBloc receiptBloc = ReceiptBloc(receiptService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => messageThreadCubit),
        BlocProvider(create: (BuildContext context) => receiptBloc),
      ],
      child: MessageThread(receiver, me, _messageBloc!, _chatsCubit!,
          _typingNotificationBloc!, chatId!),
    );
  }
}
