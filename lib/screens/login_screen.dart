import 'package:bloc_auth_app/models/user_model.dart';
import 'package:bloc_auth_app/screens/register_screen.dart';
import 'package:bloc_auth_app/utils/connection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../globals.dart';
import '../main.dart';
import '../utils/secure_storage.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // bool isConnected = false;

  // @override
  // void initState() {
  //   Connection().initConnection().then((onValue) => setState(() {
  //         isConnected = Connection().isConnected;
  //       }));
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is Authenticated) {
              SecureStorage storage = SecureStorage();
              if (!state.isOffline) {
                final FirebaseAuth auth = FirebaseAuth.instance;
                User? user = auth.currentUser;

                if (user != null) {
                  final authUser = UserModel.fromUser(user);
                  storage.setUser(authUser);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(user: authUser)));
                }
              } else {
                final authUser = await storage.getUser();
                navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
                    builder: (context) => HomeScreen(user: authUser)));
              }
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value!.isEmpty ? "Please enter an email" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) => value!.length < 6
                        ? "Password must be at least 6 characters"
                        : null,
                  ),
                  const SizedBox(height: 20),
                  state is AuthLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                SignInEvent(emailController.text,
                                    passwordController.text),
                              );
                            }
                          },
                          child: const Text("Login"),
                        ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
