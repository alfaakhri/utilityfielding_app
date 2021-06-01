import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:flutter/material.dart';

class ErrorHandlingWidget extends StatelessWidget {
  final String? icon;
  final String? title;
  final String? subTitle;

  const ErrorHandlingWidget({Key? key, this.icon, this.title, this.subTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            UIHelper.verticalSpaceSmall,
            Text(
              subTitle!,
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
