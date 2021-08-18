import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/local_bloc/local_bloc.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ListPoleLocalWidget extends StatefulWidget {
  final AllProjectsModel allProjectsModel;
  const ListPoleLocalWidget({Key? key, required this.allProjectsModel})
      : super(key: key);

  @override
  _ListPoleLocalWidgetState createState() => _ListPoleLocalWidgetState();
}

class _ListPoleLocalWidgetState extends State<ListPoleLocalWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Fielded Poles",
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
          ),
          UIHelper.verticalSpaceMedium,
          InkWell(
              onTap: () async {},
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: ColorHelpers.colorGreen2,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  "Upload All",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              )),
          UIHelper.verticalSpaceSmall,
          Expanded(
            child: ListView(
              children: context
                  .watch<LocalBloc>()
                  .allProjectModel!
                  .where((element) => element.iD == widget.allProjectsModel.iD)
                  .first
                  .addPoleModel!
                  .map((e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: ColorHelpers.colorGrey2,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Pole Sequence ${e.poleSequence!}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: ColorHelpers.colorBlackText,
                                        fontSize: 12),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {},
                                  child: Text(
                                    "Upload",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: ColorHelpers.colorBlueNumber),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
