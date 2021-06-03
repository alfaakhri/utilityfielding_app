import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class StreetNameItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: ColorHelpers.colorWhite),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Street Name",
            style: ThemeFonts.textBoldDefault,
          ),
          UIHelper.horizontalSpaceLarge,
          (context.watch<FieldingProvider>().streetName != null)
              ? Expanded(
                  child: Text(
                    (context.watch<FieldingProvider>().streetName != null)
                        ? context.watch<FieldingProvider>().streetName!
                        : "-",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorHelpers.colorBlackText,
                        fontSize: 12),
                  ),
                )
              : Text(
                  "-",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorHelpers.colorBlackText,
                      fontSize: 12),
                ),
        ],
      ),
    );
  }
}
