import 'package:fielding_app/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:fielding_app/domain/provider/provider.exports.dart';
import 'package:fielding_app/external/external.exports.dart';
import 'package:fielding_app/presentation/widgets/widgets.exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'list/list.exports.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  bool _obscureText = true;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  _validator(String value, String textWarning) {
    if (value.isEmpty) {
      return 'Please insert $textWarning';
    }
    return null;
  }

  late AuthBloc authBloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  late var node;

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);

    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is DoLoginSuccess) {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            context.read<UserProvider>().setUserModel(state.userModel);
            context
                .read<LocalProvider>()
                .updateProjectsLocal(state.userModel.data!.user!.iD!);
            context
                .read<ConnectionProvider>()
                .updateForTriggerDialog(state.userModel.data!.user!.iD!);
            Get.offAll(ListFieldingPage());
          } else if (state is DoLoginLoading) {
            LoadingWidget.showLoadingDialog(context, _keyLoader);
          } else if (state is DoLoginFailed) {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            Fluttertoast.showToast(msg: state.message!);
          }
        },
        child: Scaffold(
          backgroundColor: ColorHelpers.colorWhite,
          body: _showForm(),
        ));
  }

  Widget _showForm() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Image.asset('assets/bg_login.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width),
          Container(
            padding: EdgeInsets.symmetric(
                // vertical: MediaQuery.of(context).size.height / 12,
                horizontal: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png',
                    scale: 2,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 250, 0, 0),
                    child: Column(
                      children: <Widget>[
                        showUsernameInput(),
                        UIHelper.verticalSpaceMedium,
                        showPasswordInput(),
                        UIHelper.verticalSpaceMedium,
                        UIHelper.verticalSpaceMedium,
                        showPrimaryButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showPasswordInput() {
    return Opacity(
      opacity: 0.80,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Password",
                style: TextStyle(
                    color: ColorHelpers.colorGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            UIHelper.verticalSpaceVerySmall,
            TextFormField(
              obscureText: _obscureText,
              controller: _password,
              validator: (value) => _validator(value!, 'password'),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(_obscureText ? Icons.lock : Icons.lock_open,
                      color: ColorHelpers.colorGrey, size: 26),
                ),
                filled: true,
                fillColor: ColorHelpers.colorWhite,
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorHelpers.colorGrey)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorHelpers.colorWhite)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorHelpers.colorBorder)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showUsernameInput() {
    return Opacity(
      opacity: 0.80,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email",
                style: TextStyle(
                    color: ColorHelpers.colorGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            UIHelper.verticalSpaceVerySmall,
            TextFormField(
              controller: _username,
              validator: (value) => _validator(value!, 'email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              decoration: InputDecoration(
                filled: true,
                suffixIcon: Icon(
                  Icons.account_circle,
                  color: ColorHelpers.colorGrey,
                  size: 26,
                ),
                fillColor: ColorHelpers.colorWhite,
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorHelpers.colorGrey)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorHelpers.colorWhite)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorHelpers.colorBorder)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showPrimaryButton() {
    return InkWell(
      onTap: () {
        if (formKey.currentState!.validate()) {
          authBloc.add(DoLogin(_username.text, _password.text));
        }
      },
      child: Container(
          height: 50,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: ColorHelpers.colorButtonDefault,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: ColorHelpers.colorBlue.withOpacity(0.3),
                  blurRadius: 7,
                  offset: Offset(0, 3),
                  spreadRadius: 3,
                )
              ]),
          child: Text(
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorHelpers.colorWhite),
          )),
    );
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }
}
