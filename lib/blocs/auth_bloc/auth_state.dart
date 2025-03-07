import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final bool isOffline;

  Authenticated({this.isOffline = false});
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
