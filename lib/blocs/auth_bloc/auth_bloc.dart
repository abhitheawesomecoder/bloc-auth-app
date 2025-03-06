import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/auth_repository.dart';
import '../../utils/secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final Connectivity _connectivity = Connectivity();

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      SecureStorage storage = SecureStorage();
      try {
        List<ConnectivityResult> connectionStatus =
            await _connectivity.checkConnectivity();
        if (connectionStatus.contains(ConnectivityResult.mobile) ||
            connectionStatus.contains(ConnectivityResult.wifi)) {
          await authRepository.signIn(event.email, event.password);

          storage.setEmail(event.email);
          storage.setPassWord(event.password);
        } else {
          final userEmail = await storage.getEmail();
          final chkPassword = await storage.checkPassWord(event.password);
          if (userEmail != event.email || chkPassword == false) {
            throw Future.error("Email or password is incorrect");
          }
        }
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signUp(event.email, event.password);
        //.onError(handleError);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<IfAuthEvent>((event, emit) async {
      emit(Authenticated());
    });

    on<SignOutEvent>((event, emit) async {
      await authRepository.signOut();
      SecureStorage storage = SecureStorage();
      await storage.deleteAll();
      emit(AuthInitial());
    });
  }
}
