import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signIn(event.email, event.password);
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
      emit(AuthInitial());
    });
  }

  FutureOr<void> handleError(Object error, StackTrace stackTrace) {
    print(error);
    print(stackTrace);
  }
}
