import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/provider/fielding_provider.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/presentation/ui/login_page.dart';
import 'package:fielding_app/presentation/ui/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'fielding/list_fielding_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    context.read<FieldingProvider>().getListAllPoleClass();
    context.read<FieldingProvider>().getListAllPoleCondition();
    context.read<FieldingProvider>().getListAllPoleHeight();
    context.read<FieldingProvider>().getListAllPoleSpecies();
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(StartApp());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is GetAuthSuccess) {
          Get.offAll(ListFieldingPage());
          context.read<UserProvider>().setUserModel(state.userModel);
        } else if (state is GetAuthFailed) {
          Get.offAll(LoginPage());
        } else if (state is GetAuthMustLogin) {
          Get.offAll(LoginPage());
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
