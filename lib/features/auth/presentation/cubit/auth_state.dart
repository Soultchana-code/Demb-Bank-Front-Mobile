part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class RegisterSuccess extends AuthState {}
class RegisterFailure extends AuthState {
  final String message;
  RegisterFailure(this.message);
}