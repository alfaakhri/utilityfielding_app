import 'package:fielding_app/data/models/list_fielding/list_fielding.exports.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/local_bloc/local_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/detail.exports.dart';
import 'package:fielding_app/presentation/ui/list/widgets/notes_request_item.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';

class ItemFieldingRequestNew extends StatefulWidget {
  final FieldingRequestByJobModel fieldingRequest;

  const ItemFieldingRequestNew({
    Key? key,
    required this.fieldingRequest,
  }) : super(key: key);

  @override
  _ItemFieldingRequestNewState createState() => _ItemFieldingRequestNewState();
}

class _ItemFieldingRequestNewState extends State<ItemFieldingRequestNew> {
  // @override
  // void initState() {
  //   super.initState();
  //    var fielding = context.watch<FieldingProvider>();
  //   var dataList = widget.fieldingRequest.details!
  //       .where(
  //           (element) => element.fieldingProgressStatus == fielding.layerStatus)
  //       .toList();
  //   if (dataList.length == 0) {
  //     fielding.setEmptyListJob(true);
  //   } else {
  //     fielding.setEmptyListJob(false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var fielding = context.watch<FieldingProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ConfigurableExpansionTile(
        headerExpanded: TileTitle(
          fieldingRequest: widget.fieldingRequest,
          iconName: Icons.keyboard_arrow_up,
        ),
        header: TileTitle(
          iconName: Icons.keyboard_arrow_down,
          fieldingRequest: widget.fieldingRequest,
        ),
        onExpansionChanged: (value) {
          print(value);
        },
        children: [
          for (var item in widget.fieldingRequest.details!
              .where((element) =>
                  element.fieldingProgressStatus == fielding.layerStatus)
              .toList())
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
        color: ColorHelpers.colorGrey2,
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

class TileItem extends StatefulWidget {
  final AllProjectsModel detailItem;

  const TileItem({Key? key, required this.detailItem}) : super(key: key);

  @override
  _TileItemState createState() => _TileItemState();
}

class _TileItemState extends State<TileItem> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<FieldingProvider>()
            .setAllProjectsSelected(widget.detailItem);
        context
            .read<FieldingProvider>()
            .getJobNumberAttachModel(widget.detailItem.iD);
        Get.to(DetailFieldingPage(allProjectsModel: widget.detailItem));
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
                          widget.detailItem.projectName!,
                          style: TextStyle(
                              color: ColorHelpers.colorBlackText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.detailItem.layerName ?? "-",
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
                                (widget.detailItem.totalPoles != null)
                                    ? widget.detailItem.totalPoles.toString()
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
                        BlocListener<LocalBloc, LocalState>(
                          listener: (context, state) {
                            if (state is SaveFieldingRequestLoading) {
                              LoadingWidget.showLoadingDialog(
                                  context, _keyLoader);
                            } else if (state is SaveFieldingRequestSuccess) {
                              Navigator.of(_keyLoader.currentContext!,
                                      rootNavigator: true)
                                  .pop();
                              Fluttertoast.showToast(msg: "Download success");
                            } else if (state is SaveFieldingRequestFailed) {
                              Navigator.of(_keyLoader.currentContext!,
                                      rootNavigator: true)
                                  .pop();
                              Fluttertoast.showToast(msg: state.toString());
                            }
                          },
                          child: InkWell(
                            onTap: () {
                              var user = context.read<AuthBloc>().userModel;
                              context.read<LocalBloc>().add(SaveFieldingRequest(
                                  user!.data!.token!,
                                  widget.detailItem.iD!,
                                  widget.detailItem,
                                  user.data!.user!.iD!));
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Download",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: ColorHelpers.colorGreen2,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
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
                          (widget.detailItem.dueDate != null)
                              ? "${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.detailItem.dueDate!))}"
                              : "-",
                          style: TextStyle(
                              fontSize: 12, color: ColorHelpers.colorBlackText),
                        ),
                        Text(
                          (widget.detailItem.totalPoles != null)
                              ? "Total ${widget.detailItem.approx} Poles"
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
                              return NotesRequestItem(
                                  note: widget.detailItem.note);
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
