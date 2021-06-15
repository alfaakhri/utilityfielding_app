part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

class GetCurrentAddress extends LocationEvent {
  final double? latitude;
  final double? longitude;

  GetCurrentAddress(this.latitude, this.longitude);
}

class UpdateLocation extends LocationEvent {
  final String? token;
  final String? poleId;
  final String? latitude;
  final String? longitude;

  UpdateLocation(this.token, this.poleId, this.latitude, this.longitude);
}
