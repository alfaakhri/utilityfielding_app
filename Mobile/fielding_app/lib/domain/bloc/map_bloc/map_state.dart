part of 'map_bloc.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}

class GetJobNumberLoading extends MapState {}
class GetJobNumberSuccess extends MapState {
  final List<JobNumberLocModel> jobNumberLocModel;

  GetJobNumberSuccess(this.jobNumberLocModel);
}
class GetJobNumberFailed extends MapState {
  final String message;

  GetJobNumberFailed(this.message);
}