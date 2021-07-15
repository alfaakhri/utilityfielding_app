import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> _listChoice = ["-", "Yes", "No"];

class FormAlertDropdownItem extends StatefulWidget {
  final String? title;
  final Function(String)? onChangeItem;
  final bool? needUnknown;
  final bool? needEstimate;
  final bool? isUnknown;
  final bool? isEstimate;
  final Function()? result;
  final TextEditingController? controller;

  const FormAlertDropdownItem(
      {Key? key,
      this.title,
      this.onChangeItem,
      this.needUnknown,
      this.needEstimate,
      this.isUnknown,
      this.isEstimate,
      this.result,
      this.controller})
      : super(key: key);

  @override
  _FormAlertDropdownItemState createState() => _FormAlertDropdownItemState();
}

class _FormAlertDropdownItemState extends State<FormAlertDropdownItem> {
  bool? isUnknown = false;
  bool? isEstimate = false;
  String? valueDefault;

  @override
  void initState() {
    super.initState();
    valueDefault = widget.controller!.text;
    if (widget.isUnknown != null) isUnknown = widget.isUnknown;
    if (widget.isEstimate != null) isEstimate = widget.isEstimate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: Consumer<FieldingProvider>(
        builder: (context, data, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.title!,
              style: ThemeFonts.textDefault,
            ),
            UIHelper.verticalSpaceSmall,
            (widget.title!.toLowerCase() == "pole length")
                ? Row(
                    children: [
                      Expanded(
                          child: ItemDropdownEditPole(
                              listItem: data.listAllPoleHeight!,
                              onChange: (value) {
                                data.setPoleHeightSelected(value);
                                widget.onChangeItem!(value);
                              },
                              valueItem: (data.poleHeightSelected.id == null)
                                  ? null
                                  : data.poleHeightSelected.text.toString())),
                      UIHelper.horizontalSpaceSmall,
                      Text("Feet", style: TextStyle(fontSize: 12)),
                    ],
                  )
                : (widget.title!.toLowerCase() == "pole class")
                    ? ItemDropdownEditPole(
                        listItem: data.listAllPoleClass!,
                        onChange: (value) {
                          data.setPoleClassSelected(value);
                          widget.onChangeItem!(value);
                        },
                        valueItem: data.poleClassSelected.text ?? null)
                    : (widget.title!.toLowerCase() == "species")
                        ? ItemDropdownEditPole(
                            listItem: data.listAllPoleSpecies!,
                            onChange: (value) {
                              data.setPoleSpeciesSelected(value);
                              widget.onChangeItem!(value);
                            },
                            valueItem: data.poleSpeciesSelected.text ?? null)
                        : (widget.title!.toLowerCase() == "condition")
                            ? ItemDropdownEditPole(
                                listItem: data.listAllPoleCondition!,
                                onChange: (value) {
                                  data.setPoleConditionSelected(value);
                                  widget.onChangeItem!(value);
                                },
                                valueItem:
                                    data.poleConditionSelected.text ?? null)
                            : (widget.title!.toLowerCase() == "fielding type")
                                ? ItemDropdownEditPole(
                                    listItem: data.allFieldingType!,
                                    onChange: (value) {
                                      data.setFieldingTypeSelected(value);
                                      widget.onChangeItem!(value);
                                    },
                                    valueItem:
                                        data.fieldingTypeSelected!.text ?? null)
                                : DropdownButtonFormField<String>(
                                    isDense: true,
                                    decoration: kDecorationDropdown(),
                                    items: _listChoice.map((value) {
                                      return DropdownMenuItem<String>(
                                        child: Text(value,
                                            style: TextStyle(fontSize: 12)),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        valueDefault = value;
                                      });
                                      widget.onChangeItem!(value!);
                                    },
                                    value: (valueDefault == "") ? null : valueDefault ?? null,
                                  ),
            (widget.needUnknown!)
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.all(0),
                      title: Text("Unknown"),
                      value: isUnknown,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        setState(() {
                          isUnknown = value!;
                        });
                      },
                      activeColor: ColorHelpers.colorButtonDefault,
                    ),
                  )
                : Container(),
            (widget.needEstimate!)
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.all(0),
                      title: Text("Estimate"),
                      value: isEstimate,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        setState(() {
                          isEstimate = value!;
                        });
                      },
                      activeColor: ColorHelpers.colorButtonDefault,
                    ),
                  )
                : Container(),
            UIHelper.verticalSpaceSmall,
            Container(
              width: double.infinity,
              child: FlatButton(
                child: Text("Save", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  var fielding = context.read<FieldingProvider>();
                  fielding.setUnknownCurrent(isUnknown);
                  fielding.setIsEstimateCurrent(isEstimate);
                  widget.result!();

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

class ItemDropdownEditPole extends StatelessWidget {
  final List listItem;
  final Function(String) onChange;
  final dynamic valueItem;
  const ItemDropdownEditPole(
      {Key? key,
      required this.listItem,
      required this.onChange,
      required this.valueItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isDense: true,
      decoration: kDecorationDropdown(),
      items: listItem.map((value) {
        return DropdownMenuItem<String>(
          child: Text(value.text.toString(), style: TextStyle(fontSize: 12)),
          value: value.text.toString(),
        );
      }).toList(),
      onChanged: (String? value) {
        onChange(value!);
      },
      value: valueItem,
    );
  }
}
