import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/material.dart';

class AnchorButton extends StatelessWidget {
  final Function(bool?)? onItemClick;

  const AnchorButton({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemClick!(true);
      },
      child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: ColorHelpers.colorBlueNumber,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            "Add Anchor",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          )),
    );
  }
}
