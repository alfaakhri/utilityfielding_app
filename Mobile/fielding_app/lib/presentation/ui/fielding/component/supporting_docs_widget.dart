import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/constants.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportingDocsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Supporting Documents",
            style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
          ),
          UIHelper.verticalSpaceMedium,
          Expanded(
            child: ListView(
              children: context
                  .watch<FieldingProvider>()
                  .jobNumberAttachModel
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
                                    e.fileName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: ColorHelpers.colorBlackText,
                                        fontSize: 12),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    String format = e.fileName.split(".").last;
                                    if (format.toLowerCase() == "jpg" ||
                                        format.toLowerCase() == "jpeg" ||
                                        format.toLowerCase() == "png") {
                                      Navigator.pop(context);
                                      Get.to(PreviewImage(
                                        image: Constants.baseURL + e.filePath,
                                      ));
                                    } else {
                                      String url =
                                          Constants.baseURL + e.filePath;
                                      if (await canLaunch(url)) {
                                        Navigator.pop(context);
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Open",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: ColorHelpers.colorBlueNumber),
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
    );
  }
}
