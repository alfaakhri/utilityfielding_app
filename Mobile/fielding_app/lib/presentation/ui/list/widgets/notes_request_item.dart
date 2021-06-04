import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/material.dart';

class NotesRequestItem extends StatelessWidget {
  final String? note;

  const NotesRequestItem({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Notes",
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12),
          ),
          UIHelper.verticalSpaceSmall,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: ColorHelpers.colorGrey),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(10),
            child: Text(note!, softWrap: true),
          ),
        ],
      ),
    );
  }
}
