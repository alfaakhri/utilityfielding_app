import 'package:cached_network_image/cached_network_image.dart';
import 'package:fielding_app/data/models/detail_fielding/detail_fielding.exports.dart';
import 'package:fielding_app/data/repository/api_provider.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/bloc/picture_bloc/picture_bloc.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UploadPicturePage extends StatefulWidget {
  final AllPolesByLayerModel pole;

  const UploadPicturePage({Key? key, required this.pole}) : super(key: key);

  @override
  _UploadPicturePageState createState() => _UploadPicturePageState();
}

class _UploadPicturePageState extends State<UploadPicturePage> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

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
    var picture = context.read<PictureBloc>();
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
      body: BlocConsumer<PictureBloc, PictureState>(
        listener: (context, state) {
          if (state is UploadImageSuccess) {
            Fluttertoast.showToast(msg: "Upload Success");
            // context.read<PictureBloc>().add(
            //     GetImageByPole(user.userModel!.data!.token!, widget.pole.id!));
          } else if (state is DeleteImageSuccess) {
            Fluttertoast.showToast(msg: "Delete Success");
            // context.read<PictureBloc>().add(
            //     GetImageByPole(user.userModel!.data!.token!, widget.pole.id!));
          }
        },
        builder: (context, state) {
          if (state is GetImageByPoleLoading) {
            return _loading();
          } else if (state is UploadImageLoading) {
            return _loading();
          } else if (state is GetImageByPoleSuccess) {
            return _listGridPicture(state.imageByPole);
          } else if (state is GetImageByPoleFailed) {
            Fluttertoast.showToast(msg: state.message);
            return _handlingWidget(state.message);
          } else if (state is UploadImageFailed) {
            Fluttertoast.showToast(msg: state.message!);
            return _listGridPicture(picture.imageByPoleModel);
          } else if (state is DeleteImageLoading) {
            return _loading();
          } else if (state is DeleteImageFailed) {
            Fluttertoast.showToast(msg: state.message);
            return _listGridPicture(picture.imageByPoleModel);
          } else if (state is UploadImageCancel) {
            return _listGridPicture(picture.imageByPoleModel);
          } else if (state is DeleteImageSuccess) {
            Fluttertoast.showToast(msg: "Delete Success");

            return _listGridPicture(picture.imageByPoleModel);
          } else if (state is UploadImageSuccess) {
            Fluttertoast.showToast(msg: "Upload Success");

            return _listGridPicture(picture.imageByPoleModel);
          }
          return _loading();
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
              var user = context.read<AuthBloc>();
              context.read<PictureBloc>().add(GetImageByPole(
                  user.userModel!.data!.token!, widget.pole.id!));
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

  Widget _loading() {
    return Center(child: CircularProgressIndicator());
  }

  GridView _listGridPicture(List<ImageByPoleModel> listImage) {
    return GridView(
      padding: EdgeInsets.all(25),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: [
        GestureDetector(
          onTap: () async {
            context.read<PictureBloc>().add(UploadImage(
                context,
                widget.pole.id!,
                context.read<AuthBloc>().userModel!.data!.token!));
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
        ),
        for (var image in listImage)
          GestureDetector(
            onTap: () {
              Get.to(PreviewImage(
                  image: image.filePath!,
                  functionDelete: true,
                  attachmentId: image.id));
            },
            child: Card(
              elevation: 5.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              ColorHelpers.colorButtonDefault),
                        ),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                      imageUrl: BASE_URL + image.filePath!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
