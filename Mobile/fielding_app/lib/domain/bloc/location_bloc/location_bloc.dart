// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:fielding_app/data/models/current_address.dart';
// import 'package:fielding_app/data/repository/api_provider.dart';
// import 'package:meta/meta.dart';

// part 'location_event.dart';
// part 'location_state.dart';

// class LocationBloc extends Bloc<LocationEvent, LocationState> {
//   LocationBloc() : super(LocationInitial());
//   ApiProvider _apiProvider = ApiProvider();

//   CurrentAddress _currentAddress = CurrentAddress();
//   CurrentAddress get currentAddress => _currentAddress;

//   @override
//   Stream<LocationState> mapEventToState(
//     LocationEvent event,
//   ) async* {
//     if (event is GetCurrentAddress) {
//       yield GetCurrentAddressLoading();
//       try {
//         var response = await _apiProvider.getLocationByLatLng(
//             event.latitude, event.longitude);
//         if (response.statusCode == 200) {
//           _currentAddress = CurrentAddress.fromJson(response.data);
//           print("status geocode: ${_currentAddress.status.toString()}");
//           yield GetCurrentAddressLoading();
//         } else {
//           yield GetCurrentAddressFailed("Failed get street location");
//         }
//       } catch (e) {
//         yield GetCurrentAddressFailed(e.toString());
//       }
//     }
//   }
// }
