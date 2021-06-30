import 'package:fielding_app/domain/provider/riser_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class RiserFenceButton extends StatelessWidget {
  final Function(bool)? onItemClick;

  const RiserFenceButton({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                "Add Fence",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )),
        ),
        UIHelper.horizontalSpaceSmall,
        InkWell(
          onTap: () {
            context.read<RiserProvider>().removeLastRiserFence();
          },
          child: Container(
              width: 80,
              decoration: BoxDecoration(
                color: Colors.yellow.shade600,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                "Clear Fence",
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
