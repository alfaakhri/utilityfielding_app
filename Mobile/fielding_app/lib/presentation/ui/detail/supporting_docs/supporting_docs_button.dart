import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/supporting_docs/supporting_docs_exports.dart';
import 'package:flutter/material.dart';

import '../detail.exports.dart';

class SupportingDocsButton extends StatelessWidget {
  const SupportingDocsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return SupportingDocsWidget();
            });
      },
      child: Container(
          decoration: BoxDecoration(
            color: ColorHelpers.colorGreen2,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            "Supporting Docs",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          )),
    );
  }
}
