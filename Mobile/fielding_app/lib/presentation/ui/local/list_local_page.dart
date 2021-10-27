import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/bloc/local_bloc/local_bloc.dart';
import 'package:fielding_app/domain/provider/local_provider.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/list/list.exports.dart';
import 'package:fielding_app/presentation/ui/local/widgets/item_pole_local.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ListLocalPage extends StatefulWidget {
  const ListLocalPage({Key? key}) : super(key: key);

  @override
  _ListLocalPageState createState() => _ListLocalPageState();
}

class _ListLocalPageState extends State<ListLocalPage> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    context.read<LocalBloc>().add(GetListFielding(context.read<AuthBloc>().userModel!.data!.user!.iD!));
  }

  @override
  Widget build(BuildContext context) {
    var connect = context.read<ConnectionProvider>();

    return WillPopScope(
      onWillPop: () {
        context
            .read<FieldingBloc>()
            .add(GetFieldingRequest(context.read<UserProvider>().userModel.data!.token, connect.isConnected));

        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context
                  .read<FieldingBloc>()
                  .add(GetFieldingRequest(context.read<UserProvider>().userModel.data!.token, connect.isConnected));

              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: ColorHelpers.colorBlackText,
            ),
          ),
          iconTheme: IconThemeData(color: ColorHelpers.colorBlackText),
          title: Text(
            "Fielding App",
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: BlocConsumer<LocalBloc, LocalState>(
          listener: (context, state) {
            if (state is PostEditPoleFailed) {
              Fluttertoast.showToast(msg: state.message!);
            } else if (state is DeletePoleFailed) {
              Fluttertoast.showToast(msg: state.message!);
            } else if (state is GetListFieldingSuccess) {
              context.read<LocalProvider>().setAllProjectsModel(state.allProjectsModel);
            }
          },
          builder: (context, state) {
            if (state is GetListFieldingLoading) {
              return _skeletonLoading();
            } else if (state is GetListFieldingFailed) {
              return _handlingWidget(state.message);
            } else if (state is GetListFieldingSuccess) {
              return _content();
            } else if (state is GetListFieldingEmpty) {
              return _handlingWidget("Fielding Request Empty");
            } else if (state is PostEditPoleSuccess) {
              return _content();
            } else if (state is DeletePoleSuccess) {
              return _content();
            }
            return _content();
          },
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
              context.read<LocalBloc>().add(GetListFielding(context.read<AuthBloc>().userModel!.data!.user!.iD!));
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

  Widget _content() {
    var localBloc = context.read<LocalBloc>();
    return (localBloc.allProjectModel!.length == 0)
        ? _handlingWidget("Fielding Request Empty")
        : Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  "Edit Pole Local Storage",
                  style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                UIHelper.verticalSpaceSmall,
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: localBloc.allProjectModel!
                      .map((data) => ItemLocalPole(
                            projects: data,
                          ))
                      .toList(),
                ),
              ],
            ),
          );
  }
}
