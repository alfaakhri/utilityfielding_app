import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class FormDrawingItem extends StatelessWidget {
  final bool isBlueColor;
  final String title;
  final int lengthValue;
  final Widget classname;

  const FormDrawingItem({Key? key, required this.isBlueColor, required this.title, required this.lengthValue, required this.classname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isBlueColor
              ? ColorHelpers.colorBlueIntro
              : ColorHelpers.colorWhite),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: ThemeFonts.textBoldDefault,
            ),
          ),
          (lengthValue != 0)
              ? Expanded(
                  flex: 2,
                  child: Text(lengthValue.toString(),
                      style: TextStyle(
                          color: ColorHelpers.colorBlackText, fontSize: 14)),
                )
              : Container(),
          InkWell(
            onTap: () {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;

              print("WIDTH : $width, HEIGHT : $height");
              context.read<FieldingProvider>().baseWidth = width;
              context.read<FieldingProvider>().baseHeight = height;
              Get.to(classname);
            },
            child: Container(
              width: 50,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (lengthValue == 0)
                    ? ColorHelpers.colorBlueNumber
                    : ColorHelpers.colorGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text((lengthValue == 0) ? 'Enter' : "Edit",
                  style:
                      TextStyle(color: ColorHelpers.colorWhite, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
