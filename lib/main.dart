import 'package:bloc_auth_app/repository/item_repository.dart';
import 'package:bloc_auth_app/screens/home_screen.dart';
import 'package:bloc_auth_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/auth_repository.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/auth_bloc/auth_event.dart';
import 'blocs/item_bloc/item_bloc.dart';
import 'fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FCMService().initFCM(); // Initialize Firebase Messaging
  // FirebaseMessaging.instance.getToken().then((token) {
  //   print(token);
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        //BlocProvider(create: (context) => ItemBloc(ItemRepository())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CheckAuthStatus(),
      ),
    );
  }
}

class CheckAuthStatus extends StatelessWidget {
  const CheckAuthStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return const LoginScreen();
    } else {
      BlocProvider.of<AuthBloc>(context).add(IfAuthEvent());
      return HomeScreen(user: user);
    }
  }
}
