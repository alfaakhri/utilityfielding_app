import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      bool _isConnected = (result.index == 2) ? false : true;
      context.read<ConnectionProvider>().setIsConnected(_isConnected);
      context.read<FieldingProvider>().getAllDataFielding(_isConnected);
      context.read<RiserProvider>().getAllDataRiser(_isConnected);
      context.read<AnchorProvider>().getAllDataAnchor(_isConnected);

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

    // return _updateConnectionStatus(result);
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      print("TEST NOTIFICATION");
      // Navigator.of(context).pushName(context, '/NotificationPage', arguments: {
      //   id: receivedNotification.id
      // } // your page params. I recommend to you to pass all *receivedNotification* object
      //     );
    });
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is GetAuthSuccess) {
          Get.offAll(ListFieldingPage());
          context.read<UserProvider>().setUserModel(state.userModel!);
          context
              .read<LocalProvider>()
              .updateProjectsLocal(state.userModel!.data!.user!.iD!);
          context
              .read<ConnectionProvider>()
              .updateForTriggerDialog(state.userModel!.data!.user!.iD!);
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

  Future dialogSaveLocal(String titleName, String layerName) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UIHelper.verticalSpaceMedium,
                Text(
                  'Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorHelpers.colorGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                UIHelper.verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Internet is available, do you want upload all data pole sequence in $titleName $layerName. After finished uplaod you can upload manually on menu pole local storage",
                    softWrap: true,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorHelpers.colorGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                UIHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorHelpers.colorBlueNumber,
                        border: Border.all(color: ColorHelpers.colorBlueNumber),
                      ),
                      child: Text(
                        "UPLOAD",
                        style: TextStyle(
                            color: ColorHelpers.colorWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                UIHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorHelpers.colorRed,
                      ),
                      child: Text(
                        "CANCEL",
                        style: TextStyle(
                            color: ColorHelpers.colorWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          );
        });
  }
}
