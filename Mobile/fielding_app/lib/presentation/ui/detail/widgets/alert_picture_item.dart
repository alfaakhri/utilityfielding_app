import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertPictureItem extends StatelessWidget {
  final String? valueAlert;
  final AllPolesByLayerModel? allPolesByLayerModel;
  final AllProjectsModel? allProjectsModel;

  const AlertPictureItem(
      {Key? key,
      required this.valueAlert,
      required this.allPolesByLayerModel,
      required this.allProjectsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Are you sure $valueAlert?',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpaceMedium,
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: ColorHelpers.colorGrey.withOpacity(0.2),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: ColorHelpers.colorBlackText),
                      ),
                    ),
                  ),
                ),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: ColorHelpers.colorGreen,
                      onPressed: () {
                        if (allPolesByLayerModel!.startPolePicture!) {
                          context.read<FieldingBloc>().add(CompletePolePicture(
                            context.read<UserProvider>().userModel.data!.token,
                            allPolesByLayerModel!.id,
                            allProjectsModel!.iD,
                          ));
                        } else {
                          context.read<FieldingBloc>().add(StartPolePicture(
                            context.read<UserProvider>().userModel.data!.token,
                            allPolesByLayerModel!.id,
                            allProjectsModel!.iD,
                          ));
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
