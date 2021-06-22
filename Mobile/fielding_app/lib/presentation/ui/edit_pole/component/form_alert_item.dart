import 'package:dio/dio.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';

class FormAlertItem extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final Function(String)? onController;
  final VoidCallback callback;

  const FormAlertItem({Key? key, this.title, this.controller, this.onController, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title!,
              style: ThemeFonts.textDefault,
            ),
            UIHelper.verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                      maxLines: null,
                      controller: controller,
                      decoration: kDecorationDefault(title!)),
                ),
                (title!.toLowerCase().contains("ground line"))
                    ? Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Inch", style: TextStyle(fontSize: 12)),
                      )
                    : Container()
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Container(
              width: double.infinity,
              child: FlatButton(
                child: Text("Save", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  callback();
                  Navigator.of(context).pop();
                },
                color: ColorHelpers.colorButtonDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
