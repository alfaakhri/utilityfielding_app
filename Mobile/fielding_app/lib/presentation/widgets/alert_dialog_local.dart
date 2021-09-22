import 'package:fielding_app/domain/provider/local_provider.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertDialogLocal extends StatelessWidget {
  final String? titleName;
  final String? layerName;
  const AlertDialogLocal({Key? key, this.titleName, this.layerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Consumer<LocalProvider>(
        builder: (context, local, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            UIHelper.verticalSpaceMedium,
            Text(
              'Information',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorHelpers.colorGrey, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            UIHelper.verticalSpaceMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                textAlign: TextAlign.center,
                softWrap: true,
                text: TextSpan(
                  text: 'Internet is available, do you want upload all data pole sequence in ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '$titleName - $layerName', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: '. After finished you can upload manually job other on menu pole local storage',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpaceMedium,
            UIHelper.verticalSpaceMedium,
            GestureDetector(
              onTap: () async {
                var user = context.read<UserProvider>().userModel;
                local.uploadFirstWithAlert(
                  user.data!.user!.iD!,
                );
                Navigator.pop(context);
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
                    style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 14, fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 14, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
