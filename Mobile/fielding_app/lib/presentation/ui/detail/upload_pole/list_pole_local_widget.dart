import 'package:fielding_app/data/models/models.exports.dart';
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

  @override
  Widget build(BuildContext context) {
    var connect = context.read<ConnectionProvider>();
    var userId = context.read<UserProvider>().userModel.data!.user!.iD;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
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
      body: BlocListener<LocalBloc, LocalState>(
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
          builder: (context, data, _) => Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                  (data.projectLocalSelected.startCompleteModel == null)
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
                                        context
                                            .read<LocalBloc>()
                                            .add(UploadStartComplete(widget.allProjectsModel!, e, userId!));
                                      }
                                    },
                                  ))
                              .toList(),
                        ),
                  (data.projectLocalSelected.addPoleModel != null)
                      ? ListView(
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
                                        context
                                            .read<LocalBloc>()
                                            .add(UploadSinglePole(e, widget.allProjectsModel!, userId!));
                                      }
                                    },
                                  ))
                              .toList(),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
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
