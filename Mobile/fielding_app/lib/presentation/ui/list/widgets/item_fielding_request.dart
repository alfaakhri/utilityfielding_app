import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/detail.exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'notes_request_item.dart';

class ItemFieldingRequest extends StatelessWidget {
  final AllProjectsModel dataProject;

  const ItemFieldingRequest({Key? key, required this.dataProject}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<FieldingProvider>().setAllProjectsSelected(dataProject);
        context.read<FieldingProvider>().getJobNumberAttachModel(dataProject.iD);
        Get.to(DetailFieldingPage(allProjectsModel: dataProject));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                          dataProject.projectName!,
                          style: TextStyle(
                              color: ColorHelpers.colorBlackText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          dataProject.layerName!,
                          style: TextStyle(
                              color: ColorHelpers.colorBlackText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                (dataProject.totalPoles != null)
                                    ? dataProject.totalPoles.toString()
                                    : "0",
                                style: TextStyle(
                                    color: ColorHelpers.colorBlueNumber,
                                    fontSize: 24)),
                            UIHelper.horizontalSpaceSmall,
                            Text("Poles",
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
                          (dataProject.dueDate != null)
                              ? "Due Date ${DateFormat("dd MMM yyyy").format(DateTime.parse(dataProject.dueDate!))}"
                              : "Due Date -",
                          // "Due Date ${data.dueDate  }",
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        ),
                        Text(
                          (dataProject.approx != null)
                              ? "Approx ${dataProject.approx} Poles"
                              : "Approx 0 Poles",
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return NotesRequestItem(note: dataProject.note);
                            });
                      },
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
}
