import 'package:fielding_app/data/models/user_model.dart';
import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/provider/user_provider.dart';
import 'package:fielding_app/external/color_helpers.dart';
import 'package:fielding_app/external/ui_helpers.dart';
import 'package:fielding_app/presentation/ui/local/list_local_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  UserModel userModel = UserModel();
  late AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    userModel = context.watch<UserProvider>().userModel;
    authBloc = BlocProvider.of<AuthBloc>(context);
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Image.asset('assets/logo.png', scale: 2,),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userModel.data!.user!.companyName!,
                    style: TextStyle(
                        color: ColorHelpers.colorGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  UIHelper.verticalSpaceVerySmall,
                  Text(
                    userModel.data!.user!.email!,
                    style: TextStyle(color: ColorHelpers.colorGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.storage,
                    color: ColorHelpers.colorGrey,
                  ),
                  UIHelper.horizontalSpaceSmall,
                  Text(
                    'Pole Local Storage',
                    style: TextStyle(
                      color: ColorHelpers.colorGrey,
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Get.to(ListLocalPage());
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.logout,
                    color: ColorHelpers.colorGrey,
                  ),
                  UIHelper.horizontalSpaceSmall,
                  Text(
                    'Log Out',
                    style: TextStyle(
                      color: ColorHelpers.colorGrey,
                    ),
                  )
                ],
              ),
              onTap: () {
                authBloc.add(DoLogout());
              },
            ),
          ],
        ),
      ),
    );
  }
}
