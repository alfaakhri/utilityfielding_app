part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class GetJobNumberLoc extends MapEvent {
  final String? token;

  GetJobNumberLoc(this.token);
}
