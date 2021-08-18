import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';

import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/detail.exports.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ItemLocalPole extends StatelessWidget {
  final AllProjectsModel projects;

  const ItemLocalPole({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<FieldingProvider>()
            .setAllProjectsSelected(projects);
        context
            .read<FieldingProvider>()
            .getJobNumberAttachModel(projects.iD);
        Get.to(DetailFieldingPage(allProjectsModel: projects,));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          color: ColorHelpers.colorBlue,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projects.projectName!,
                          style: TextStyle(
                              color: ColorHelpers.colorBlackText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          projects.layerName ?? "-",
                          style: TextStyle(
                              color: ColorHelpers.colorBlackText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                                (projects.totalPoles != null)
                                    ? projects.totalPoles.toString()
                                    : "0",
                                style: TextStyle(
                                    color: ColorHelpers.colorBlueNumber,
                                    fontSize: 24)),
                            UIHelper.horizontalSpaceSmall,
                            Text("Complete Poles",
                                style: TextStyle(
                                    color: ColorHelpers.colorBlackText,
                                    fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (projects.dueDate != null)
                              ? "${DateFormat("dd/MM/yyyy").format(DateTime.parse(projects.dueDate!))}"
                              : "-",
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        ),
                        Text(
                          (projects.totalPoles != null)
                              ? "Total ${projects.approx} Poles"
                              : "Total 0 Poles",
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Notes",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: ColorHelpers.colorButtonDefault,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future dialogSaveLocal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UIHelper.verticalSpaceMedium,
                Text(
                  'Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorHelpers.colorGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                UIHelper.verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Are you sure delete this pole from local ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorHelpers.colorGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                UIHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorHelpers.colorRed,
                        border: Border.all(color: ColorHelpers.colorRed),
                      ),
                      child: Text(
                        "YES",
                        style: TextStyle(
                            color: ColorHelpers.colorWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                UIHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorHelpers.colorButtonDefault,
                      ),
                      child: Text(
                        "NO",
                        style: TextStyle(
                            color: ColorHelpers.colorWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          );
        });
  }
}
