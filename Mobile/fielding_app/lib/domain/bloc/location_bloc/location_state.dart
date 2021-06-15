part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class GetCurrentAddressLoading extends LocationState {}
class GetCurrentAddressSuccess extends LocationState {
  final CurrentAddress currentAddress;

  GetCurrentAddressSuccess(this.currentAddress);
}
class GetCurrentAddressFailed extends LocationState {
  final String message;

  GetCurrentAddressFailed(this.message);
}

class UpdateLocationLoading extends LocationState {}

class UpdateLocationSuccess extends LocationState {
  final AllPolesByLayerModel allPolesByLayerModel;

  UpdateLocationSuccess(this.allPolesByLayerModel);
}

class UpdateLocationFailed extends LocationState {
  final String? message;
  UpdateLocationFailed(this.message);
}
