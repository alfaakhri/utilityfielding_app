part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class GetAuthLoading extends AuthState {}

class GetAuthSuccess extends AuthState {
  final UserModel userModel;

  GetAuthSuccess(this.userModel);
}

class GetAuthFailed extends AuthState {
  final String? message;

  GetAuthFailed(this.message);
}

class FirstInstall extends AuthState {}

class GetAuthMustLogin extends AuthState {}

class DoLoginLoading extends AuthState {}

class DoLoginSuccess extends AuthState {
  final UserModel userModel;

  DoLoginSuccess(this.userModel);
}

class DoLoginFailed extends AuthState {
  final String? message;

  DoLoginFailed(this.message);
}

class DoLogoutSuccess extends AuthState {}

class DoLogoutFailed extends AuthState {}
