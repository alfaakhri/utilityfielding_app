import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/ui/ui.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'list/list_fielding_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    context.read<FieldingProvider>().getListAllPoleClass();
    context.read<FieldingProvider>().getListAllPoleCondition();
    context.read<FieldingProvider>().getListAllPoleHeight();
    context.read<FieldingProvider>().getListAllPoleSpecies();
    context.read<FieldingProvider>().getListAllHoaType();
    context.read<RiserProvider>().getAllDownGuyOwner();
    context.read<RiserProvider>().getRiserAndVGR();
    context.read<AnchorProvider>().getAllAnchorEyes();
    context.read<AnchorProvider>().getAllAnchorSize();
    context.read<AnchorProvider>().getBrokenDownGuySize();
    context.read<AnchorProvider>().getDownGuySize();
    context.read<AnchorProvider>().getAllAnchorCondition();
    context.read<IntroProvider>().getPrivacyPolicy();
    context.read<FieldingProvider>().getFieldingType();
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(StartApp());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is GetAuthSuccess) {
          Get.offAll(ListFieldingPage());
          context.read<UserProvider>().setUserModel(state.userModel!);
        } else if (state is GetAuthFailed) {
          Get.offAll(LoginPage());
        } else if (state is GetAuthMustLogin) {
          Get.offAll(LoginPage());
        } else if (state is FirstInstall) {
          Get.offAll(IntroductionPage());
        }
      },
      builder: (context, state) {
        if (state is GetAuthLoading) {
          return SplashPage();
        }
        return Container(
          color: ColorHelpers.colorWhite,
        );
      },
    );
  }
}
