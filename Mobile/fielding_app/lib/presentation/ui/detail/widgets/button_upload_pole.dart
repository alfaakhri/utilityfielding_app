import 'package:fielding_app/data/models/list_fielding/list_fielding.exports.dart';
import 'package:fielding_app/domain/bloc/local_bloc/local_bloc.dart';
import 'package:fielding_app/domain/provider/local_provider.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/widgets/widgets_detail_exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ButtonUploadPole extends StatelessWidget {
  final AllProjectsModel allProjectsModel;
  const ButtonUploadPole({Key? key, required this.allProjectsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var connect = context.read<ConnectionProvider>();
    return Consumer<LocalProvider>(
      builder: (context, data, _) => InkWell(
          onTap: () {
            Get.to(ListPoleLocalWidget(
              allProjectsModel: allProjectsModel,
            ));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                color: (connect.isConnected) ? ColorHelpers.colorGreen2 : ColorHelpers.colorGrey2,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              "Upload Pole",
              style: TextStyle(
                  color: (connect.isConnected) ? ColorHelpers.colorWhite : ColorHelpers.colorBlackText.withOpacity(0.5),
                  fontSize: 12),
            ),
          )),
    );
  }
}
