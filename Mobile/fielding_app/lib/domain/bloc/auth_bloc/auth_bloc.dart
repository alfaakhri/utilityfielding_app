import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fielding_app/data/models/response_check_token.dart';
import 'package:fielding_app/data/models/user_model.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/external/service/shared_pref_service.dart';
import 'package:fielding_app/presentation/ui/login_page.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());
  ApiProvider _apiProvider = ApiProvider();
  SharedPrefService _sharedPref = SharedPrefService();

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  ResponseCheckToken _responseToken = ResponseCheckToken();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is GetAuthentication) {
      yield GetAuthLoading();
      try {
        var firstInstall = await _sharedPref.getFirstInstall();
        if (firstInstall == null) {
          yield FirstInstall();
        } else {
          _userModel = await (_sharedPref.getUserModel() as FutureOr<UserModel>);
          if (_userModel == null) {
            yield GetAuthMustLogin();
          } else {
            var response = await (_apiProvider.checkToken(_userModel.data!.token) as FutureOr<Response<dynamic>>);
            if (response.statusCode == 200) {
              yield GetAuthSuccess(_userModel);
            } else
              yield GetAuthMustLogin();
          }
        }
      } catch (e) {
        yield GetAuthFailed(e.toString());
      }
    } else if (event is DoLogin) {
      yield DoLoginLoading();
      try {
        var response =
            await _apiProvider.doLogin(event.username, event.password);
        _userModel = UserModel.fromJson(response!.data);
        if (response.statusCode == 200) {
          _sharedPref.saveUserModel(_userModel);
          yield DoLoginSuccess(_userModel);
        } else {
          yield DoLoginFailed(_userModel.message);
        }
      } catch (e) {
        yield DoLoginFailed(e.toString());
      }
    } else if (event is StartApp) {
      yield* _startAppToState();
    } else if (event is DoLogout) {
      _sharedPref.deleteUserModel();
      Get.offAll(LoginPage());
    } else if (event is SaveFirstInstall) {
      _sharedPref.saveFirstInstall();
    }
  }

  Stream<AuthState> _startAppToState() async* {
    yield GetAuthLoading();
    Timer(Duration(seconds: 2), () {
      add(GetAuthentication());
    });
  }
}
