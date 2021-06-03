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

kDecorationDefault(String title) {
  return InputDecoration(
    border: InputBorder.none,
    isDense: true,
    hintText: "$title...",
    hintStyle: TextStyle(
        color: ColorHelpers.colorBlackText.withOpacity(0.3), fontSize: 12),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: ColorHelpers.colorGrey.withOpacity(0.3))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: ColorHelpers.colorGrey.withOpacity(0.3))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: ColorHelpers.colorGrey.withOpacity(0.3))),
  );
}
