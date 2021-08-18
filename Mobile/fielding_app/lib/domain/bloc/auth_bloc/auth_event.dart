part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class GetAuthentication extends AuthEvent {
  final bool isConnected;

  GetAuthentication(this.isConnected);
}

class DoLogin extends AuthEvent {
  final String username;
  final String password;

  DoLogin(this.username, this.password);
}

class DoLogout extends AuthEvent {}

class StartApp extends AuthEvent {
  final bool isConnected;

  StartApp(this.isConnected);
}

class SaveFirstInstall extends AuthEvent {}