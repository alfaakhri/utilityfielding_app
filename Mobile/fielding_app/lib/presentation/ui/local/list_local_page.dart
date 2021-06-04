import 'package:fielding_app/data/models/models.exports.dart';
import 'package:fielding_app/domain/bloc/local_bloc/local_bloc.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/list/list.exports.dart';
import 'package:fielding_app/presentation/ui/local/widgets/item_pole_local.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ListLocalPage extends StatefulWidget {
  const ListLocalPage({ Key? key }) : super(key: key);

  @override
  _ListLocalPageState createState() => _ListLocalPageState();
}

class _ListLocalPageState extends State<ListLocalPage> {

  @override
  void initState() { 
    super.initState();
    context.read<LocalBloc>().add(GetEditPole());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorHelpers.colorBlackText),
        title: Text(
          "Fielding App",
          style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<LocalBloc, LocalState>(
        builder: (context, state) {
          if (state is GetEditPoleLoading) {
            return _skeletonLoading();
          } else if (state is GetEditPoleFailed) {
            return _handlingWidget(state.message);
          } else if (state is GetEditPoleSuccess) {
            return _content(state.listAddPoleLocal!);
          } else if (state is GetEditPoleEmpty) {
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

  Widget _content(List<AddPoleLocal> poleLocal) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            "Edit Pole Local Storage",
            style: TextStyle(
                color: ColorHelpers.colorBlackText,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          UIHelper.verticalSpaceSmall,
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: poleLocal
                .map((data) => ItemLocalPole(addPoleLocal: data,))
                .toList(),
          ),
        ],
      ),
    );
  }
}