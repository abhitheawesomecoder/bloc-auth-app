import 'package:bloc_auth_app/repository/item_repository.dart';
import 'package:bloc_auth_app/screens/home_screen.dart';
import 'package:bloc_auth_app/screens/login_screen.dart';
import 'package:bloc_auth_app/utils/connection.dart';
import 'package:bloc_auth_app/utils/secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'globals.dart';
import 'models/user_model.dart';
import 'repository/auth_repository.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/auth_bloc/auth_event.dart';
import 'blocs/item_bloc/item_bloc.dart';
import 'fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final Connectivity connectivity = Connectivity();
  // List<ConnectivityResult> connectionStatus =
  //     await connectivity.checkConnectivity();
  Connection().initConnection();
  SecureStorage storage = SecureStorage();

  final lastUser = await storage.getUser();
  //await FCMService().initFCM(); // Initialize Firebase Messaging
  // FirebaseMessaging.instance.getToken().then((token) {
  //   print(token);
  // });
  runApp(MyApp(
    // connectionStatus: connectionStatus,
    user: lastUser,
  ));
}

class MyApp extends StatelessWidget {
  // final List<ConnectivityResult> connectionStatus;
  final UserModel? user;
  const MyApp(
      {super.key,
      // required this.connectionStatus,
      required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        //BlocProvider(create: (context) => ItemBloc(ItemRepository())),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: CheckAuthStatus(
          // connectionStatus: connectionStatus,
          lastUser: user,
        ),
      ),
    );
  }
}

class CheckAuthStatus extends StatelessWidget {
  // final List<ConnectivityResult> connectionStatus;
  final UserModel? lastUser;
  const CheckAuthStatus(
      {super.key,
      // required this.connectionStatus,
      required this.lastUser});

  @override
  Widget build(BuildContext context) {
    if (Connection().isConnected) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      if (user == null) {
        return const LoginScreen();
      } else {
        final authUser = UserModel.fromUser(user);
        BlocProvider.of<AuthBloc>(context).add(IfAuthEvent());
        return HomeScreen(user: authUser);
      }
    } else {
      if (lastUser == null) {
        return const LoginScreen();
      } else {
        BlocProvider.of<AuthBloc>(context).add(IfAuthEvent());
        return HomeScreen(user: lastUser);
      }
    }
  }
}
