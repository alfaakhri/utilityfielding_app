import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/supporting_docs/supporting_docs_exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../detail.exports.dart';

class SupportingDocsButton extends StatelessWidget {
  const SupportingDocsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (context.read<FieldingProvider>().jobNumberAttachModel!.length !=
            0) {
          showDialog(
              context: context,
              builder: (context) {
                return SupportingDocsWidget();
              });
        }
      },
      child: Container(
          decoration: BoxDecoration(
            color: (context
                        .read<FieldingProvider>()
                        .jobNumberAttachModel!
                        .length ==
                    0)
                ? ColorHelpers.colorGrey2
                : ColorHelpers.colorGreen2,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            "Supporting Docs",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: (context
                        .read<FieldingProvider>()
                        .jobNumberAttachModel!
                        .length ==
                    0)
                ? ColorHelpers.colorBlackText.withOpacity(0.5) : Colors.white,
              fontSize: 12,
            ),
          )),
    );
  }
}
