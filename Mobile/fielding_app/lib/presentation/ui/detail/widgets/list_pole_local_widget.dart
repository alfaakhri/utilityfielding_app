import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/local_bloc/local_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ListPoleLocalWidget extends StatefulWidget {
  final AllProjectsModel? allProjectsModel;
  const ListPoleLocalWidget({Key? key, this.allProjectsModel})
      : super(key: key);

  @override
  _ListPoleLocalWidgetState createState() => _ListPoleLocalWidgetState();
}

class _ListPoleLocalWidgetState extends State<ListPoleLocalWidget> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    var connect = context.read<ConnectionProvider>();

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: BlocListener<LocalBloc, LocalState>(
        listener: (context, state) {
          if (state is UploadSinglePoleLoading) {
            LoadingWidget.showLoadingDialog(context, _keyLoader);
          } else if (state is UploadSinglePoleFailed) {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            Fluttertoast.showToast(msg: state.message!);
          } else if (state is UploadSinglePoleSuccess) {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Upload Success");
          }
        },
        child: Consumer<LocalProvider>(
          builder: (context, data, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Fielded Poles",
                style:
                    TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
              ),
              UIHelper.verticalSpaceMedium,
              InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    var user = context.read<UserProvider>().userModel;
                    context.read<LocalProvider>().uploadAllWithNotif(user.data!.user!.iD!);
                  },
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
                  children: data.projectLocalSelected.addPoleModel!
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
                                      onTap: () {
                                        var userId = context
                                            .read<UserProvider>()
                                            .userModel
                                            .data!
                                            .user!
                                            .iD;
                                        if (!connect.isConnected) {
                                          Fluttertoast.showToast(
                                              msg: "Internet not available");
                                        } else {
                                          context.read<LocalBloc>().add(
                                              UploadSinglePole(
                                                  e,
                                                  widget.allProjectsModel!,
                                                  userId!));
                                        }
                                      },
                                      child: Text(
                                        "Upload",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color:
                                                ColorHelpers.colorBlueNumber),
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
        ),
      ),
    );
  }
}
