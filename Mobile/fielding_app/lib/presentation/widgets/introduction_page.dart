import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/constants.dart';
import 'package:fielding_app/external/service/location_service.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/login_page.dart';
import 'package:fielding_app/presentation/widgets/open_intro_webview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:location/location.dart';

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  AuthBloc authBloc;

  void getCurrentLocation() async {
    LocationService location = LocationService();
    LocationData data = await location.getCurrentLocation();
    print("latlng: ${data.latitude.toString()} ${data.longitude.toString()}");
    context
        .read<FieldingProvider>()
        .setCurrentPosition(LatLng(data.latitude, data.longitude));
    context.read<FieldingProvider>().setCurrentLocationData(data);
  }

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  int _page;

  void _onIntroEnd(context) {
    Get.offAll(LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 14.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.all(0),
      pageColor: Colors.transparent,
      imagePadding: EdgeInsets.zero,
    );

    return Container(
      color: ColorHelpers.colorWhite,
      child: Column(
        children: [
          Expanded(
            child: IntroductionScreen(
              onChange: (value) {
                if (value == 1) {
                  getCurrentLocation();
                }
                setState(() {
                  _page = value;
                });
              },
              key: introKey,
              pages: [
                PageViewModel(
                  titleWidget: _titleWidget("Location Data Access"),
                  bodyWidget: Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text: Constants.bodyIntro1,
                          style: TextStyle(
                              fontSize: 16, color: ColorHelpers.colorGreyIntro),
                          children: [
                            TextSpan(
                                text: Constants.privacyPolicy,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: ColorHelpers.colorBlueNumber),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(OpenIntroWebview(
                                      url: Constants.urlPrivacy,
                                    ));
                                  }),
                            TextSpan(text: Constants.bodySubIntro1),
                          ]),
                    ),
                  ),
                  image: _imageIntro(context, "assets/intro_1.png"),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  titleWidget: _titleWidget("Privacy Policy"),
                  bodyWidget: Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text: Constants.bodyIntro2,
                          style: TextStyle(
                              fontSize: 16, color: ColorHelpers.colorGreyIntro),
                          children: [
                            TextSpan(
                                text: Constants.privacyPolicy,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: ColorHelpers.colorBlueNumber),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(OpenIntroWebview(
                                      url: Constants.urlPrivacy,
                                    ));
                                  }),
                            TextSpan(text: Constants.bodySubIntro2),
                          ]),
                    ),
                  ),
                  image: _imageIntro(context, "assets/intro_2.png"),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  titleWidget: _titleWidget("EULA & Terms"),
                  bodyWidget: Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16, color: ColorHelpers.colorGreyIntro),
                          children: [
                            TextSpan(
                                text: Constants.eula,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: ColorHelpers.colorBlueNumber),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(OpenIntroWebview(
                                        url: Constants.urlEula));
                                  }),
                            TextSpan(text: Constants.bodyIntro3),
                            TextSpan(
                                text: Constants.terms,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: ColorHelpers.colorBlueNumber),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(OpenIntroWebview(
                                      url: Constants.urlTerms,
                                    ));
                                  }),
                            TextSpan(text: Constants.bodySubIntro3),
                            TextSpan(
                                text: Constants.disclaimer + ".",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: ColorHelpers.colorBlueNumber),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(OpenIntroWebview(
                                      url: Constants.urlDisclaimer,
                                    ));
                                  }),
                          ]),
                    ),
                  ),
                  image: _imageIntro(context, "assets/intro_3.png"),
                  decoration: pageDecoration,
                ),
              ],
              onDone: () => _onIntroEnd(context),
              //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
              skipFlex: 0,
              nextFlex: 0,
              next: Row(
                children: [
                  Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 22, color: ColorHelpers.colorButtonDefault),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      color: ColorHelpers.colorButtonDefault, size: 20),
                ],
              ),
              
              done: Column(
                children: [],
              ),

              dotsDecorator: const DotsDecorator(
                activeColor: ColorHelpers.colorButtonDefault,
                size: Size(10.0, 8.0),
                color: ColorHelpers.colorGreyIntro,
                activeSize: Size(22.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          (_page == 2)
              ? Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: FlatButton(
                        color: ColorHelpers.colorButtonDefault,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          authBloc.add(SaveFirstInstall());
                          Get.offAll(LoginPage());
                        },
                        child: Text("Agree",
                            style: TextStyle(
                                fontSize: 16, color: ColorHelpers.colorWhite)),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: FlatButton(
                        color: ColorHelpers.colorWhite,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: ColorHelpers.colorButtonDefault),
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: Text("Decline",
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorHelpers.colorButtonDefault)),
                      ),
                    ),
                    UIHelper.verticalSpaceSmall,
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Container _titleWidget(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
      ),
    );
  }

  Container _imageIntro(BuildContext context, String asset) {
    return Container(
      color: ColorHelpers.colorBlueIntro,
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            asset,
          ),
          Positioned(
            right: 25,
            top: 50,
            child: InkWell(
              onTap: () {
                SystemNavigator.pop();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ColorHelpers.colorWhite,
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.close,
                  color: ColorHelpers.colorButtonDefault,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
