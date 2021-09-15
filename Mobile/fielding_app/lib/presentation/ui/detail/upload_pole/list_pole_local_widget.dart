import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/bloc/local_bloc/local_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ListPoleLocalWidget extends StatefulWidget {
  final AllProjectsModel? allProjectsModel;
  const ListPoleLocalWidget({Key? key, this.allProjectsModel}) : super(key: key);

  @override
  _ListPoleLocalWidgetState createState() => _ListPoleLocalWidgetState();
}

class _ListPoleLocalWidgetState extends State<ListPoleLocalWidget> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  void getAllPoles() {
    var user = context.read<UserProvider>();
    context.read<FieldingBloc>().add(GetAllPolesByID(user.userModel.data!.token, widget.allProjectsModel,
        context.read<ConnectionProvider>().isConnected, user.userModel.data!.user!.iD!));
  }

  @override
  Widget build(BuildContext context) {
    var connect = context.read<ConnectionProvider>();
    var user = context.read<UserProvider>().userModel;
    return WillPopScope(
      onWillPop: () {
        getAllPoles();
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                getAllPoles();
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: ColorHelpers.colorBlackText,
              )),
          title: Text(
            "Fielded Poles",
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
          ),
        ),
        body: Consumer<LocalProvider>(
          builder: (context, data, _) => BlocListener<LocalBloc, LocalState>(
            listener: (context, state) {
              if (state is UploadSinglePoleLoading) {
                LoadingWidget.showLoadingDialog(context, _keyLoader);
              } else if (state is UploadSinglePoleFailed) {
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
                Fluttertoast.showToast(msg: state.message!);
              } else if (state is UploadSinglePoleSuccess) {
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
                data.updateProjectsLocal(user.data!.user!.iD!);
                getAllPoles();
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Upload Success");
              } else if (state is UploadStartCompleteLoading) {
                LoadingWidget.showLoadingDialog(context, _keyLoader);
              } else if (state is UploadStartCompleteFailed) {
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
                Fluttertoast.showToast(msg: state.message!);
              } else if (state is UploadStartCompleteSuccess) {
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
                data.updateProjectsLocal(user.data!.user!.iD!);
                getAllPoles();
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Upload Success");
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: (data.projectLocalSelected.startCompleteModel!.isEmpty &&
                      data.projectLocalSelected.addPoleModel!.isEmpty)
                  ? _handlingWidget("List fielded poles is empty")
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                              onTap: () async {
                                var user = context.read<UserProvider>().userModel;
                                context.read<LocalProvider>().uploadAllWithNotif(user.data!.user!.iD!);
                                getAllPoles();
                                Navigator.pop(context);
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
                          (data.projectLocalSelected.startCompleteModel!.isEmpty)
                              ? Container()
                              : ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: data.projectLocalSelected.startCompleteModel!
                                      .map((e) => ItemPoleUpload(
                                            asset: "assets/pin_blue.png",
                                            poleSequence: e.poleSequence!,
                                            onTap: () {
                                              if (!connect.isConnected) {
                                                Fluttertoast.showToast(msg: "Internet not available");
                                              } else {
                                                context.read<LocalBloc>().add(UploadStartComplete(
                                                    widget.allProjectsModel!,
                                                    e,
                                                    user.data!.user!.iD!,
                                                    user.data!.token!));
                                              }
                                            },
                                          ))
                                      .toList(),
                                ),
                          (data.projectLocalSelected.addPoleModel!.isEmpty)
                              ? Container()
                              : ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: data.projectLocalSelected.addPoleModel!
                                      .map((e) => ItemPoleUpload(
                                            asset: "assets/pin_green.png",
                                            poleSequence: e.poleSequence!,
                                            onTap: () {
                                              if (!connect.isConnected) {
                                                Fluttertoast.showToast(msg: "Internet not available");
                                              } else {
                                                context.read<LocalBloc>().add(UploadSinglePole(e,
                                                    widget.allProjectsModel!, user.data!.user!.iD!, user.data!.token!));
                                              }
                                            },
                                          ))
                                      .toList(),
                                ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Column _handlingWidget(String? title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorHandlingWidget(
          title: title,
          subTitle: "Please come back in a moment.",
        ),
        UIHelper.verticalSpaceSmall,
        FittedBox(
          child: InkWell(
            onTap: () {
              var local = context.read<LocalProvider>();
              var user = context.read<UserProvider>();
              local.updateProjectsLocal(user.userModel.data!.user!.iD!);
            },
            child: Container(
              color: ColorHelpers.colorBlueIntro,
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.replay_outlined,
                    color: ColorHelpers.colorGrey,
                  ),
                  Text("Reload"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ItemPoleUpload extends StatelessWidget {
  final String asset;
  final String poleSequence;
  final Function() onTap;

  const ItemPoleUpload({
    Key? key,
    required this.asset,
    required this.poleSequence,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: ColorHelpers.colorGrey2, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      asset,
                      scale: 4.5,
                    ),
                    UIHelper.horizontalSpaceSmall,
                    Text(
                      "Pole Sequence $poleSequence",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 12),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onTap,
                child: Text(
                  "Upload",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: ColorHelpers.colorBlueNumber),
                ),
              ),
            ],
          ),
        ),
        UIHelper.verticalSpaceSmall,
      ],
    );
  }
}
