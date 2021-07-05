import 'package:fielding_app/data/models/list_fielding/list_fielding.exports.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/detail.exports.dart';
import 'package:fielding_app/presentation/ui/list/widgets/notes_request_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';

class ItemFieldingRequestNew extends StatelessWidget {
  final FieldingRequestByJobModel fieldingRequest;

  const ItemFieldingRequestNew({Key? key, required this.fieldingRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ConfigurableExpansionTile(
        headerExpanded: TileTitle(
          fieldingRequest: fieldingRequest,
          iconName: Icons.keyboard_arrow_up,
        ),
        header: TileTitle(
          iconName: Icons.keyboard_arrow_down,
          fieldingRequest: fieldingRequest,
        ),
        children: [
          for (var item in fieldingRequest.details!)
            TileItem(
              detailItem: item,
            )
        ],
      ),
    );
  }
}

class TileTitle extends StatelessWidget {
  final FieldingRequestByJobModel fieldingRequest;
  final IconData iconName;

  const TileTitle(
      {Key? key, required this.fieldingRequest, required this.iconName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        color: ColorHelpers.colorBlue,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fieldingRequest.title!,
                    style: TextStyle(
                        color: ColorHelpers.colorBlackText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    (fieldingRequest.lastDueDate != null)
                        ? "${DateFormat("dd/MM/yyyy").format(DateTime.parse(fieldingRequest.lastDueDate!))}"
                        : "-",
                    style: TextStyle(
                        fontSize: 12, color: ColorHelpers.colorBlackText),
                  ),
                  Text(
                    "Total ${fieldingRequest.fieldingRequestCount} request",
                    style: TextStyle(
                        fontSize: 12, color: ColorHelpers.colorBlackText),
                  ),
                ],
              ),
              Icon(iconName),
            ],
          ),
        ),
      ),
    );
  }
}

class TileItem extends StatelessWidget {
  final AllProjectsModel detailItem;

  const TileItem({Key? key, required this.detailItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<FieldingProvider>().setAllProjectsSelected(detailItem);
        context.read<FieldingProvider>().getJobNumberAttachModel(detailItem.iD);
        Get.to(DetailFieldingPage(allProjectsModel: detailItem));
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
                          detailItem.projectName!,
                          style: TextStyle(
                              color: ColorHelpers.colorBlackText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          detailItem.layerName ?? "-",
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
                                (detailItem.totalPoles != null)
                                    ? detailItem.totalPoles.toString()
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
                          (detailItem.dueDate != null)
                              ? "${DateFormat("dd/MM/yyyy").format(DateTime.parse(detailItem.dueDate!))}"
                              : "-",
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        ),
                        Text(
                          (detailItem.totalPoles != null)
                              ? "Total ${detailItem.totalPoles} Poles"
                              : "Total 0 Poles",
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
                              return NotesRequestItem(note: detailItem.note);
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
