import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/upload_picture/upload_picture_page.dart';
import 'package:fielding_app/presentation/ui/edit_pole/edit_pole.exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'alert_picture_item.dart';

class PoleSequenceItem extends StatelessWidget {
  final AllPolesByLayerModel allPolesByLayerModel;

  const PoleSequenceItem({Key? key, required this.allPolesByLayerModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var connect = context.read<ConnectionProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Card(
        color: ColorHelpers.colorGreenCard,
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
                        "Pole Sequence",
                        style: TextStyle(
                            color: ColorHelpers.colorBlackText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                      (allPolesByLayerModel.poleSequence == null)
                          ? "-"
                          : allPolesByLayerModel.poleSequence.toString(),
                      style: TextStyle(
                          color: ColorHelpers.colorGreen2, fontSize: 24)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      var fielding = context.read<FieldingProvider>();
                      fielding.setLatLng(0, 0);
                      fielding.setPolesByLayerSelected(allPolesByLayerModel);
                      Get.to(EditPolePage(
                        allProjectsModel: fielding.allProjectsSelected,
                        poles: allPolesByLayerModel,
                        isStartComplete: false,
                      ));
                    },
                    child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: ColorHelpers.colorGreen2,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  (!connect.isConnected)
                      ? Container()
                      : InkWell(
                          onTap: () {
                            var fielding = context.read<FieldingProvider>();

                            fielding
                                .setPolesByLayerSelected(allPolesByLayerModel);
                            Get.to(UploadPicturePage(
                              pole: allPolesByLayerModel,
                            ));
                          },
                          child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                  color: ColorHelpers.colorGreenCard,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: ColorHelpers.colorButtonDefault)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                "Take Close Up Picture",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorHelpers.colorButtonDefault,
                                  fontSize: 12,
                                ),
                              )),
                        ),
                  UIHelper.verticalSpaceSmall,
                  (!connect.isConnected)
                      ? Container()
                      : InkWell(
                          onTap: () {
                            if (allPolesByLayerModel.startPolePicture!) {
                              dialogAlertPicture("complete pictures", context);
                            } else {
                              dialogAlertPicture(
                                  "additional pictures", context);
                            }
                          },
                          child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                  color: allPolesByLayerModel.startPolePicture!
                                      ? ColorHelpers.colorRed2
                                      : ColorHelpers.colorGreenCard,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color:
                                          allPolesByLayerModel.startPolePicture!
                                              ? ColorHelpers.colorRed2
                                              : ColorHelpers.colorGreen2)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                allPolesByLayerModel.startPolePicture!
                                    ? "Complete Pictures"
                                    : "Additional Pictures",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: allPolesByLayerModel.startPolePicture!
                                      ? ColorHelpers.colorWhite
                                      : ColorHelpers.colorGreen2,
                                  fontSize: 12,
                                ),
                              )),
                        ),
                ],
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
            allPolesByLayerModel: allPolesByLayerModel,
            allProjectsModel:
                context.read<FieldingProvider>().allProjectsSelected,
          );
        });
  }
}
