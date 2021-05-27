import 'package:fielding_app/data/models/all_projects_model.dart';
import 'package:fielding_app/data/models/user_model.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/service/location_service.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/fielding/map_view_number_page.dart';
import 'package:fielding_app/presentation/widgets/drawer_widget.dart';
import 'package:fielding_app/presentation/widgets/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_text/skeleton_text.dart';

import 'detail_fielding_page.dart';

class ListFieldingPage extends StatefulWidget {
  @override
  _ListFieldingPageState createState() => _ListFieldingPageState();
}

class _ListFieldingPageState extends State<ListFieldingPage> {
  void getCurrentLocation() async {
    LocationService location = LocationService();
    LocationData data = await location.getCurrentLocation();
    print("latlng: ${data.latitude.toString()} ${data.longitude.toString()}");
    context
        .read<FieldingProvider>()
        .setCurrentPosition(LatLng(data.latitude, data.longitude));
    context.read<FieldingProvider>().setCurrentLocationData(data);
  }

  FieldingBloc fieldingBloc;
  @override
  void initState() {
    super.initState();
    fieldingBloc = BlocProvider.of<FieldingBloc>(context);
    fieldingBloc
        .add(GetAllProjects(context.read<UserProvider>().userModel.data.token));
    getCurrentLocation();
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
            return _content(state.allProjectsModel);
          } else if (state is GetAllProjectsEmpty) {
            return _handlingWidget("Fielding Request Empty");
          }
          return _skeletonLoading();
        },
      ),
    );
  }

  Column _handlingWidget(String title) {
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
                  context.read<UserProvider>().userModel.data.token));
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
                .map((data) => GestureDetector(
                      onTap: () {
                        context
                            .read<FieldingProvider>()
                            .setAllProjectsSelected(data);
                        context
                            .read<FieldingProvider>()
                            .getJobNumberAttachModel(data.iD);
                        Get.to(DetailFieldingPage(allProjectsModel: data));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Card(
                          color: ColorHelpers.colorBlue,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.projectName ?? "-",
                                          style: TextStyle(
                                              color:
                                                  ColorHelpers.colorBlackText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          data.layerName ?? "-",
                                          style: TextStyle(
                                              color:
                                                  ColorHelpers.colorBlackText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                (data.totalPoles != null)
                                                    ? data.totalPoles
                                                            .toString() ??
                                                        "0"
                                                    : "0",
                                                style: TextStyle(
                                                    color: ColorHelpers
                                                        .colorBlueNumber,
                                                    fontSize: 24)),
                                            UIHelper.horizontalSpaceSmall,
                                            Text("Poles",
                                                style: TextStyle(
                                                    color: ColorHelpers
                                                        .colorBlackText,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                UIHelper.verticalSpaceSmall,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (data.dueDate != null)
                                              ? "Due Date ${DateFormat("dd MMM yyyy").format(DateTime.parse(data.dueDate)) ?? "-"}"
                                              : "Due Date -",
                                          // "Due Date ${data.dueDate  ?? "-"}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  ColorHelpers.colorBlackText),
                                        ),
                                        Text(
                                          (data.approx != null)
                                              ? "Approx ${data.approx} Poles"
                                              : "Approx 0 Poles",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  ColorHelpers.colorBlackText),
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0))),
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      "Notes",
                                                      style: TextStyle(
                                                          color: ColorHelpers
                                                              .colorBlackText,
                                                          fontSize: 12),
                                                    ),
                                                    UIHelper.verticalSpaceSmall,
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: ColorHelpers
                                                                .colorGrey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                          data.note ?? "-",
                                                          softWrap: true),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Notes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                ColorHelpers.colorButtonDefault,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
