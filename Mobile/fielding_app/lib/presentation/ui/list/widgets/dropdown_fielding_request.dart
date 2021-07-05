import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';

const List fieldingDropdown = [
  'Fielding Request',
  "Fielding Complete",
  "Fielding Archive"
];

class DropdownFieldingRequest extends StatefulWidget {
  const DropdownFieldingRequest({Key? key}) : super(key: key);

  @override
  _DropdownFieldingRequestState createState() => _DropdownFieldingRequestState();
}

class _DropdownFieldingRequestState extends State<DropdownFieldingRequest> {
  String _value = "Fielding Request";
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
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
          });
        },
        value: _value,
      ),
    );
  }
}
