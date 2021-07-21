import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List fieldingDropdown = [
  "Fielding Request",
  "Fielding Complete",
  "Fielding Archive"
];

class DropdownFieldingRequest extends StatefulWidget {
  const DropdownFieldingRequest({Key? key}) : super(key: key);

  @override
  _DropdownFieldingRequestState createState() =>
      _DropdownFieldingRequestState();
}

class _DropdownFieldingRequestState extends State<DropdownFieldingRequest> {
  String _value = "Fielding Request";

  @override
  Widget build(BuildContext context) {
    var fielding = context.read<FieldingProvider>();
    return Container(
      width: MediaQuery.of(context).size.width / 2.2,
      height: 50,
      child: DropdownButtonFormField<String>(
        isDense: true,
        decoration: kDecorationDropdown(),
        items: fieldingDropdown.map((value) {
          return DropdownMenuItem<String>(
            child: Text(value, style: TextStyle(fontSize: 12)),
            value: value,
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _value = value!;
            switch (value) {
              case "Fielding Request":
                fielding.setLayerStatus(1);
                break;
              case "Fielding Complete":
                fielding.setLayerStatus(2);
                break;
              case "Fielding Archive":
                fielding.setLayerStatus(3);
                break;
            }
          });
        },
        value: _value,
      ),
    );
  }
}
