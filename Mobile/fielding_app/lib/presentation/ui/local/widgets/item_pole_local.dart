import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/material.dart';

class ItemLocalPole extends StatelessWidget {
  final AddPoleLocal addPoleLocal;

  const ItemLocalPole({Key? key, required this.addPoleLocal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Text(
                    "Pole Sequence " +
                        addPoleLocal.allPolesByLayerModel!.poleSequence!
                            .toString(),
                    style: TextStyle(
                        color: ColorHelpers.colorBlackText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
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
                        addPoleLocal.allProjectsModel!.projectName!,
                        // "Due Date ${data.dueDate  }",
                        style: TextStyle(
                            fontSize: 12, color: ColorHelpers.colorBlackText),
                      ),
                      Text(
                        addPoleLocal.allProjectsModel!.layerName!,
                        style: TextStyle(
                            fontSize: 12, color: ColorHelpers.colorBlackText),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: 75,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Update",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: ColorHelpers.colorButtonDefault,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      UIHelper.horizontalSpaceVerySmall,
                      InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: 75,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Delete",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: ColorHelpers.colorRed,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
