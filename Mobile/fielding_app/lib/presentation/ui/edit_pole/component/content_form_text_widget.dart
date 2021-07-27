import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../edit_pole.exports.dart';

class ContentFormTextWidget extends StatefulWidget {
  final String? title;
  final TextEditingController controller;
  final bool? isButtonGrey;
  final bool? isDropdown;
  final bool? isBlueColor;
  final bool? isValidation;
  final bool needUnk;
  final bool needEst;
  final Function()? result;
  final bool? isUnk;
  final bool? isEst;

  const ContentFormTextWidget(
      {Key? key,
      required this.title,
      required this.controller,
      required this.isDropdown,
      required this.isBlueColor,
      this.isValidation,
      required this.needUnk,
      required this.needEst,
      required this.result,
      this.isUnk,
      this.isEst,
      required this.isButtonGrey})
      : super(key: key);

  @override
  _ContentFormTextWidgetState createState() => _ContentFormTextWidgetState();
}

class _ContentFormTextWidgetState extends State<ContentFormTextWidget> {
  late String valueContent;

  @override
  Widget build(BuildContext context) {
    valueContent = context.read<FieldingProvider>().valueTextContent(
        widget.title!, widget.controller,
        isUnk: widget.isUnk ?? false, isEst: widget.isEst ?? false);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: widget.isBlueColor!
              ? ColorHelpers.colorBlueIntro
              : ColorHelpers.colorWhite),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title!,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeFonts.textBoldDefault,
                ),
                (widget.isValidation == null)
                    ? Container()
                    : widget.isValidation!
                        ? Text(
                            (widget.title!.toLowerCase().contains("pole sequence")) ? " *number already existed" : " *need to fill",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : Container()
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              valueContent,
              style:
                  TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12),
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.isDropdown!) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return FormAlertDropdownItem(
                          title: widget.title,
                          controller: widget.controller,
                          needUnknown: widget.needUnk,
                          needEstimate: widget.needEst,
                          isUnknown: widget.isUnk,
                          isEstimate: widget.isEst,
                          result: () {
                            widget.result!();
                          },
                          onChangeItem: (value) {
                            setState(() {
                              widget.controller.text = value;
                            });
                          });
                    });
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return FormAlertItem(
                          title: widget.title,
                          controller: widget.controller,
                          isUnknown: widget.isUnk,
                          isEstimate: widget.isEst,
                          needEst: widget.needEst,
                          needUnk: widget.needUnk,
                          result: () {
                            widget.result!();
                          });
                    });
              }
            },
            child: Container(
              width: 50,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (widget.isButtonGrey!)
                    ? ColorHelpers.colorGreyIntro
                    : (widget.controller.text.isEmpty ||
                            widget.controller.text == "-")
                        ? ColorHelpers.colorBlueNumber
                        : ColorHelpers.colorGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                  (widget.controller.text.isEmpty ||
                          widget.controller.text == "-")
                      ? 'Enter'
                      : "Edit",
                  style: TextStyle(
                      color: ColorHelpers.colorWhite,
                      fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
