import 'package:fielding_app/data/models/list_fielding/list_fielding.exports.dart';
import 'package:fielding_app/domain/bloc/local_bloc/local_bloc.dart';
import 'package:fielding_app/domain/provider/local_provider.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/widgets/widgets_detail_exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonUploadPole extends StatelessWidget {
  final AllProjectsModel allProjectsModel;
  const ButtonUploadPole({Key? key, required this.allProjectsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalProvider>(
      builder: (context, data, _) => InkWell(
          onTap: () {
            if (data.projectLocalSelected.addPoleModel != null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ListPoleLocalWidget();
                  });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                color: (data.projectLocalSelected.addPoleModel == null)
                    ? ColorHelpers.colorGrey2
                    : ColorHelpers.colorGreen2,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              "Upload Pole",
              style: TextStyle(
                  color: (data.projectLocalSelected.addPoleModel == null
                          )
                      ? ColorHelpers.colorBlackText.withOpacity(0.5)
                      : ColorHelpers.colorWhite,
                  fontSize: 12),
            ),
          )),
    );
  }
}
