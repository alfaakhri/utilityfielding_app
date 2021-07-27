import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget(
      {Key? key, required this.onlineChild, required this.offlineChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus networkStatus = Provider.of<ConnectivityStatus>(context);
    if (networkStatus == ConnectivityStatus.Online) {
      _showToastMessage("Online");
      return onlineChild;
    } else {
      _showToastMessage("Offline");
      return offlineChild;
    }
  }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }
}
