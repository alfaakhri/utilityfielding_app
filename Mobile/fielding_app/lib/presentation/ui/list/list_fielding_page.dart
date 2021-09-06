
import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/list/list.exports.dart';
import 'package:fielding_app/presentation/ui/list/widgets/dropdown_fielding_request.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skeleton_text/skeleton_text.dart';

import 'widgets/item_fielding_request_new.dart';

class ListFieldingPage extends StatefulWidget {
  @override
  _ListFieldingPageState createState() => _ListFieldingPageState();
}

class _ListFieldingPageState extends State<ListFieldingPage> {
  late FieldingBloc fieldingBloc;
  @override
  void initState() {
    super.initState();

    fieldingBloc = BlocProvider.of<FieldingBloc>(context);
    var connect = context.read<ConnectionProvider>();
    fieldingBloc.add(GetFieldingRequest(
        context.read<UserProvider>().userModel.data!.token,
        connect.isConnected));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorHelpers.colorBlackText),
        title: InkWell(
          onTap: () {},
          child: Text(
            "Fielding App",
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<FieldingBloc, FieldingState>(
        builder: (context, state) {
          if (state is GetFieldingRequestLoading) {
            return _skeletonLoading();
          } else if (state is GetFieldingRequestFailed) {
            return _handlingWidget(state.message);
          } else if (state is GetFieldingRequestSuccess) {
            return _content(state.fieldingRequest);
          } else if (state is GetFieldingRequestEmpty) {
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
              fieldingBloc.add(GetFieldingRequest(
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
          itemCount: 10,
        ),
      ),
    );
  }

  Widget _content(List<FieldingRequestByJobModel> fieldingRequest) {
    var fielding = context.watch<FieldingProvider>();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownFieldingRequest(),
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
            children: fieldingRequest
                .map((data) => (data.details!
                            .where((e) =>
                                e.fieldingProgressStatus ==
                                fielding.layerStatus)
                            .toList()
                            .length ==
                        0)
                    ? Container()
                    : ItemFieldingRequestNew(
                        fieldingRequest: data,
                      ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
