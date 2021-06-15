import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/edit_pole/edit_pole.exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'alert_picture_item.dart';

class PoleSequenceSelectedItem extends StatelessWidget {
  final AllPolesByLayerModel? poleModelSelected;
  final VoidCallback? callback;

  const PoleSequenceSelectedItem({
    Key? key,
    required this.poleModelSelected,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fielding = context.read<FieldingProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Card(
        color: ColorHelpers.colorYellowCard,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pole Sequences",
                        style: TextStyle(
                            color: ColorHelpers.colorBlackText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                      (poleModelSelected!.poleSequence == null)
                          ? "-"
                          : poleModelSelected!.poleSequence.toString(),
                      style: TextStyle(
                          color: ColorHelpers.colorOrange, fontSize: 24)),
                ],
              ),
              (poleModelSelected!.fieldingStatus == 2)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            callback!();
                            fielding
                                .setPolesByLayerSelected(poleModelSelected!);

                            Get.to(EditPolePage(
                              allProjectsModel: fielding.allProjectsSelected,
                              poles: poleModelSelected,
                            ));
                          },
                          child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                color: ColorHelpers.colorOrange,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                "Edit Pole Information",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              )),
                        ),
                        UIHelper.verticalSpaceSmall,
                        InkWell(
                          onTap: () {
                            if (poleModelSelected!.startPolePicture!) {
                              dialogAlertPicture("complete pictures", context);
                            } else {
                              dialogAlertPicture(
                                  "additional pictures", context);
                            }
                          },
                          child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                  color: poleModelSelected!.startPolePicture!
                                      ? ColorHelpers.colorButtonDefault
                                      : ColorHelpers.colorYellowCard,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color:
                                          poleModelSelected!.startPolePicture!
                                              ? ColorHelpers.colorButtonDefault
                                              : ColorHelpers.colorOrange)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                poleModelSelected!.startPolePicture!
                                    ? "Complete Pictures"
                                    : "Additional Pictures",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: poleModelSelected!.startPolePicture!
                                      ? ColorHelpers.colorWhite
                                      : ColorHelpers.colorOrange,
                                  fontSize: 12,
                                ),
                              )),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        context.read<FieldingBloc>().add(StartFielding(
                            context.read<UserProvider>().userModel.data!.token,
                            poleModelSelected!.id,
                            true,
                            fielding.allProjectsSelected.iD));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: ColorHelpers.colorOrange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            "Start",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future dialogAlertPicture(String valueAlert, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertPictureItem(
            valueAlert: valueAlert,
            allPolesByLayerModel: poleModelSelected,
            allProjectsModel:
                context.read<FieldingProvider>().allProjectsSelected,
          );
        });
  }
}
