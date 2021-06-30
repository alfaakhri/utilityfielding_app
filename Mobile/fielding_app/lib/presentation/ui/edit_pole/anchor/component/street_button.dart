import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class StreetButton extends StatelessWidget {
  final Function(bool)? onItemClick;

  const StreetButton({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
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
                "Add Street",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )),
        ),
        UIHelper.verticalSpaceSmall,
        InkWell(
          onTap: () {
            context.read<AnchorProvider>().removeLastStreet();
          },
          child: Container(
              width: 80,
              decoration: BoxDecoration(
                color: Colors.yellow.shade600,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                "Clear Street",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              )),
        )
      ],
    );
  }
}
