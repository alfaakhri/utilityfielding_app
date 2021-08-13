import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/edit_pole/edit_pole.exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ButtonAddTreeTrim extends StatelessWidget {
  final AllProjectsModel? project;
  const ButtonAddTreeTrim({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          var fielding = context.read<FieldingProvider>();
          fielding.setLatLng(0, 0);

          Get.to(EditLatLngPage(
            polesLayerModel:
                context.read<FieldingProvider>().polesByLayerSelected,
            allProjectsModel: project,
            isAddPole: false,
            isAddTreeTrim: true,
          ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              color: ColorHelpers.colorGreen2,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Icon(Icons.add, color: ColorHelpers.colorWhite, size: 15,),
              Text(
                "Add Tree Trim",
                style: TextStyle(color: ColorHelpers.colorWhite, fontSize: 12),
              )
            ],
          ),
        ));
  }
}
