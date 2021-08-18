import 'package:fielding_app/data/models/list_fielding/list_fielding.exports.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/widgets/widgets_detail_exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonUploadPole extends StatelessWidget {
  final AllProjectsModel allProjectsModel;
  const ButtonUploadPole({Key? key, required this.allProjectsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return ListPoleLocalWidget(allProjectsModel: allProjectsModel);
              });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              color: ColorHelpers.colorGreen2,
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            "Upload Pole",
            style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 12),
          ),
        ));
  }
}
