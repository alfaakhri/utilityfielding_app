import 'package:fielding_app/data/models/list_fielding/list_fielding.exports.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/detail/supporting_docs/supporting_docs_exports.dart';
import 'package:fielding_app/presentation/ui/detail/widgets/widgets_detail_exports.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitleMapItem extends StatelessWidget {
  final AllProjectsModel allProjectsModel;
  const TitleMapItem({Key? key, required this.allProjectsModel})
      : super(key: key);

  Widget _itemTitleMapDefault(BuildContext context) {
    var connect = context.read<ConnectionProvider>();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Fielded Request",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: ColorHelpers.colorBlackText),
              ),
              (!connect.isConnected)
                  ? ButtonUploadPole(allProjectsModel: allProjectsModel,)
                  : ButtonAddPole(project: allProjectsModel),
            ],
          ),
          UIHelper.verticalSpaceVerySmall,
          (!connect.isConnected)
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SupportingDocsButton(),
                    ButtonAddTreeTrim(project: allProjectsModel),

                    // UIHelper.horizontalSpaceSmall,
                    // itemFieldingType(fielding), //HIDE DULU
                  ],
                ),
        ],
      ),
    );
  }

  Row _itemTitleMapLarge(BuildContext context) {
    var connect = context.read<ConnectionProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "Fielded Request",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: ColorHelpers.colorBlackText),
            ),
            UIHelper.horizontalSpaceSmall,
            (!connect.isConnected) ? ButtonUploadPole(allProjectsModel: allProjectsModel,) : SupportingDocsButton(),
            // UIHelper.horizontalSpaceSmall,
            // itemFieldingType(fielding), //HIDE DULU
          ],
        ),
        (!connect.isConnected)
            ? Container()
            : Row(
                children: [
                  ButtonAddPole(project: allProjectsModel),
                  UIHelper.horizontalSpaceSmall,
                  ButtonAddTreeTrim(project: allProjectsModel),
                ],
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double newWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: (newWidth > 480)
          ? _itemTitleMapLarge(context)
          : _itemTitleMapDefault(context),
    );
  }
}
