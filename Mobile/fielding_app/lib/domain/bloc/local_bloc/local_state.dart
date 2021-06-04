part of 'local_bloc.dart';

@immutable
abstract class LocalState {}

class LocalInitial extends LocalState {}

class GetEditPoleLoading extends LocalState {}
class GetEditPoleSuccess extends LocalState {
  final List<AddPoleLocal>? listAddPoleLocal;

  GetEditPoleSuccess(this.listAddPoleLocal);
}
class GetEditPoleFailed extends LocalState {
  final String? message;

  GetEditPoleFailed(this.message);
}

class GetEditPoleEmpty extends LocalState {}