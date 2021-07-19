import 'package:dio/dio.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormAlertItem extends StatefulWidget {
  final String? title;
  final TextEditingController? controller;
  final Function(String)? onController;
  final VoidCallback result;
  final bool? isUnknown;
  final bool? isEstimate;
  final bool? needUnk;
  final bool? needEst;

  const FormAlertItem(
      {Key? key,
      this.title,
      this.controller,
      this.onController,
      required this.result,
      this.isUnknown,
      required this.needUnk,
      this.isEstimate,
      required this.needEst})
      : super(key: key);

  @override
  _FormAlertItemState createState() => _FormAlertItemState();
}

class _FormAlertItemState extends State<FormAlertItem> {
  bool? _isUnknown = false;
  bool? _isEstimate = false;

  @override
  void initState() {
    super.initState();
    if (widget.isUnknown != null) _isUnknown = widget.isUnknown;
    if (widget.isEstimate != null) _isEstimate = widget.isEstimate;
  }

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
              widget.title!,
              style: ThemeFonts.textDefault,
            ),
            UIHelper.verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                      maxLines: null,
                      controller: widget.controller,
                      decoration: kDecorationDefault(widget.title!)),
                ),
                (widget.title!.toLowerCase().contains("ground line"))
                    ? Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Inch", style: TextStyle(fontSize: 12)),
                      )
                    : Container()
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: (widget.needUnk!)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: CheckboxListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(0),
                            title: Text("UNK"),
                            value: _isUnknown,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (_isEstimate!)
                                ? null
                                : (value) {
                                    setState(() {
                                      _isUnknown = value;
                                    });
                                  },
                            activeColor: ColorHelpers.colorButtonDefault,
                          ),
                        )
                      : Container(),
                ),
                Expanded(
                  child: (widget.needEst!)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: CheckboxListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(0),
                            title: Text("EST"),
                            value: _isEstimate,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (_isUnknown!)
                                ? null
                                : (value) {
                                    setState(() {
                                      _isEstimate = value;
                                    });
                                  },
                            activeColor: ColorHelpers.colorButtonDefault,
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Container(
              width: double.infinity,
              child: FlatButton(
                child: Text("Save", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  var fielding = context.read<FieldingProvider>();
                  fielding.setUnknownCurrent(_isUnknown);
                  fielding.setIsEstimateCurrent(_isEstimate);
                  widget.result();
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
