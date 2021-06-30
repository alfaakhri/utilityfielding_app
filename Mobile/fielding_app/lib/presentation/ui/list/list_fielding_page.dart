import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/external/service/service.exports.dart';
import 'package:fielding_app/presentation/ui/detail/detail.exports.dart';
import 'package:fielding_app/presentation/ui/list/list.exports.dart';
import 'package:fielding_app/presentation/ui/list/widgets/item_fielding_request.dart';
import 'package:fielding_app/presentation/ui/list/widgets/notes_request_item.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ListFieldingPage extends StatefulWidget {
  @override
  _ListFieldingPageState createState() => _ListFieldingPageState();
}

class _ListFieldingPageState extends State<ListFieldingPage> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi: 
        Fluttertoast.showToast(msg: "Internet available");
        context.read<ConnectionProvider>().setIsConnected(true);
        break;
      case ConnectivityResult.mobile:
        Fluttertoast.showToast(msg: "Internet available");
        context.read<ConnectionProvider>().setIsConnected(true);
        break;
      case ConnectivityResult.none:
        Fluttertoast.showToast(msg: "Internet not available");
        context.read<ConnectionProvider>().setIsConnected(false);
        break;
      default:
        Fluttertoast.showToast(msg: "Internet not available");
        context.read<ConnectionProvider>().setIsConnected(false);
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      context.read<FieldingProvider>().getCurrentLocation((result.index == 2) ? false : true);
      fieldingBloc.add(GetAllProjects(
          context.read<UserProvider>().userModel.data!.token,
          (result.index == 2) ? false : true));
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  late FieldingBloc fieldingBloc;
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    fieldingBloc = BlocProvider.of<FieldingBloc>(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorHelpers.colorBlackText),
        title: Text(
          "Fielding App",
          style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<FieldingBloc, FieldingState>(
        builder: (context, state) {
          if (state is GetAllProjectsLoading) {
            return _skeletonLoading();
          } else if (state is GetAllProjectsFailed) {
            return _handlingWidget(state.message);
          } else if (state is GetAllProjectsSuccess) {
            return _content(state.allProjectsModel!);
          } else if (state is GetAllProjectsEmpty) {
            return _handlingWidget("Fielding Request Empty");
          }
          return _skeletonLoading();
        },
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
              fieldingBloc.add(GetAllProjects(
                  context.read<UserProvider>().userModel.data!.token,
                  context.read<ConnectionProvider>().isConnected));
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

  Widget _skeletonLoading() {
    return SkeletonAnimation(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Card(
                  child: Container(
                width: double.infinity,
                height: 80,
                color: ColorHelpers.colorBackground,
              )),
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }

  Widget _content(List<AllProjectsModel> allProjects) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Fielding Request",
                style: TextStyle(
                    color: ColorHelpers.colorBlackText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Get.to(MapViewNumberPage());
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: ColorHelpers.colorGreen2,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      "Map View",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )),
              ),
            ],
          ),
          UIHelper.verticalSpaceSmall,
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: allProjects
                .map((data) => ItemFieldingRequest(dataProject: data))
                .toList(),
          ),
        ],
      ),
    );
  }
}
