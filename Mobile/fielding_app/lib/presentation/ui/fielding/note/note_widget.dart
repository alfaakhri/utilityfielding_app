import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:flutter/material.dart';

class NoteWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  const NoteWidget({Key key, this.title, this.controller}) : super(key: key);

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  var textDefault = TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    print(height);
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                content: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: textDefault,
                        ),
                        UIHelper.verticalSpaceSmall,
                        TextFormField(
                          minLines: (height > 750) ? 15 : 10,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: widget.controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: "${widget.title}...",
                            hintStyle: TextStyle(
                                color: ColorHelpers.colorBlackText
                                    .withOpacity(0.3),
                                fontSize: 12),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: ColorHelpers.colorGrey
                                        .withOpacity(0.3))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: ColorHelpers.colorGrey
                                        .withOpacity(0.3))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: ColorHelpers.colorGrey
                                        .withOpacity(0.3))),
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                        Container(
                          width: double.infinity,
                          child: FlatButton(
                            child: Text("Save",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            color: ColorHelpers.colorButtonDefault,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: textDefault,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3.5,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    widget.controller.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorHelpers.colorBlackText,
                        fontSize: 12),
                  ),
                ),
                UIHelper.horizontalSpaceSmall,
                Icon(
                  Icons.arrow_forward_ios,
                  color: ColorHelpers.colorBlackText,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
