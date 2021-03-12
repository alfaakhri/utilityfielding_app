import 'package:fielding_app/external/color_helpers.dart';
import 'package:flutter/material.dart';

kDecorationDropdown() {
  return InputDecoration(
    filled: true,
    fillColor: ColorHelpers.colorBackground,
    labelStyle: TextStyle(color: Colors.black),
    isDense: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
      color: ColorHelpers.colorBackground,
    )),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: ColorHelpers.colorBackground,
      ),
    ),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
  );
}
