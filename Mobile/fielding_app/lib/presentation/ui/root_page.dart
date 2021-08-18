import 'package:connectivity/connectivity.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/ui.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'list/list_fielding_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late AuthBloc authBloc;
  final Connectivity _connectivity = Connectivity();

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        Fluttertoast.showToast(msg: "Internet available");
        context.read<ConnectionProvider>().setIsConnected(true);
        break;
      case ConnectivityResult.mobile:
        Fluttertoast.showToast(msg: "Internet available");
        context.read<ConnectionProvider>().setIsConnected(true);
        break;
      case ConnectivityResult.none:
        Fluttertoast.showToast(msg: "Internet not available");
        context.read<ConnectionProvider>().setIsConnected(false);
        break;
      default:
        Fluttertoast.showToast(msg: "Internet not available");
        context.read<ConnectionProvider>().setIsConnected(false);
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      bool _isConnected = (result.index == 2) ? false : true;

      context.read<FieldingProvider>().getListAllPoleClass(_isConnected);
      context.read<FieldingProvider>().getListAllPoleCondition(_isConnected);
      context.read<FieldingProvider>().getListAllPoleHeight(_isConnected);
      context.read<FieldingProvider>().getListAllPoleSpecies(_isConnected);
      context.read<FieldingProvider>().getListAllHoaType(_isConnected);
      context.read<RiserProvider>().getAllDownGuyOwner(_isConnected);
      context.read<RiserProvider>().getRiserAndVGR(_isConnected);
      context.read<AnchorProvider>().getAllAnchorEyes(_isConnected);
      context.read<AnchorProvider>().getAllAnchorSize(_isConnected);
      context.read<AnchorProvider>().getBrokenDownGuySize(_isConnected);
      context.read<AnchorProvider>().getDownGuySize(_isConnected);
      context.read<AnchorProvider>().getAllAnchorCondition(_isConnected);
      context.read<FieldingProvider>().getFieldingType(_isConnected);
      authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(StartApp(_isConnected));
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is GetAuthSuccess) {
          Get.offAll(ListFieldingPage());
          context.read<UserProvider>().setUserModel(state.userModel!);
        } else if (state is GetAuthFailed) {
          Get.offAll(LoginPage());
        } else if (state is GetAuthMustLogin) {
          Get.offAll(LoginPage());
        } else if (state is FirstInstall) {
          Get.offAll(IntroductionPage());
        }
      },
      builder: (context, state) {
        if (state is GetAuthLoading) {
          return SplashPage();
        }
        return Container(
          color: ColorHelpers.colorWhite,
        );
      },
    );
  }
}
