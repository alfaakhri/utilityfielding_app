part of 'local_bloc.dart';

@immutable
abstract class LocalEvent {}

class GetEditPole extends LocalEvent {}

class PostEditPole extends LocalEvent {
  final String token;
  final AddPoleLocal addPole;

  PostEditPole(this.token, this.addPole);
}

