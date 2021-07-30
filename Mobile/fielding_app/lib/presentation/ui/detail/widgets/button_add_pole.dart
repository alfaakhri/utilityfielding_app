import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/edit_pole/edit_pole.exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ButtonAddPole extends StatelessWidget {
  final AllProjectsModel? project;
  const ButtonAddPole({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          var fielding = context.read<FieldingProvider>();
          fielding.setLatLng(0, 0);
          // context.read<FieldingBloc>().setPoleByIdModel(PoleByIdModel(
          //     isPoleClassUnknown: false,
          //     isPoleLengthUnknown: false,
          //     isSpeciesUnknown: false,
          //     isGroundLineUnknown: false,
          //     isYearUnknown: false));
          // Get.to(EditPolePage(allProjectsModel: project, isAddPole: true));

          Get.to(EditLatLngPage(
            polesLayerModel:
                context.read<FieldingProvider>().polesByLayerSelected,
            allProjectsModel: project,
            isAddPole: true,
          ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: ColorHelpers.colorGreen2,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Icon(Icons.add, color: ColorHelpers.colorWhite),
              Text(
                "Add Pole",
                style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 12),
              )
            ],
          ),
        ));
  }
}
