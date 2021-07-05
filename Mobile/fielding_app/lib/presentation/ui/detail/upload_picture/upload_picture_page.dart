import 'package:fielding_app/data/models/detail_fielding/detail_fielding.exports.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/bloc/picture_bloc/picture_bloc.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class UploadPicturePage extends StatefulWidget {
  final AllPolesByLayerModel pole;

  const UploadPicturePage({Key? key, required this.pole}) : super(key: key);

  @override
  _UploadPicturePageState createState() => _UploadPicturePageState();
}

class _UploadPicturePageState extends State<UploadPicturePage> {
  @override
  void initState() {
    super.initState();
    var user = context.read<AuthBloc>();
    context
        .read<PictureBloc>()
        .add(GetImageByPole(user.userModel!.data!.token!, widget.pole.id!));
  }

  @override
  Widget build(BuildContext context) {
    var fielding = context.read<FieldingBloc>();
    var user = context.read<AuthBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Pole Sequence ${widget.pole.poleSequence}",
          style: TextStyle(color: ColorHelpers.colorBlackText, fontSize: 14),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: ColorHelpers.colorBlackText,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: 1,
        padding: EdgeInsets.all(25.0),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, indexList) {
          if (indexList == 0) {
            return GestureDetector(
              onTap: () async {
                context.read<PictureBloc>().add(UploadImage(context, widget.pole.id!));
              },
              child: Card(
                  color: Color(0xFFDFDFDF),
                  elevation: 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 35,
                        color: Color(0xFFC8C8C8),
                      ),
                      Text(
                        'Add Photos',
                        style: TextStyle(color: Color(0xFFC8C8C8)),
                      ),
                    ],
                  )),
            );
          } else {
            return GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 5.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                        // child: Image.file(
                        //   fotoList,
                        //   height: double.infinity,
                        //   width: double.infinity,
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
