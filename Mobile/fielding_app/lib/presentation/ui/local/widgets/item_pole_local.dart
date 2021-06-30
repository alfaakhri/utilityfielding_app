import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/bloc/local_bloc/local_bloc.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        onTap: () {
                          context.read<LocalBloc>().add(PostEditPole(
                              context.read<AuthBloc>().userModel!.data!.token!,
                              addPoleLocal));
                        },
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
                        onTap: () {
                          dialogSaveLocal(context);
                        },
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
                    context.read<LocalBloc>().add(DeletePole(addPoleLocal));
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
