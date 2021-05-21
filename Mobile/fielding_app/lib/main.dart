import 'package:device_preview/device_preview.dart';
import 'package:fielding_app/domain/bloc/download_image_bloc/download_image_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/anchor_provider.dart';
import 'package:fielding_app/domain/provider/intro_provider.dart';
import 'package:fielding_app/presentation/ui/root_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'domain/bloc/auth_bloc/auth_bloc.dart';
import 'domain/bloc/location_bloc/location_bloc.dart';
import 'domain/provider/fielding_provider.dart';
import 'domain/provider/riser_provider.dart';
import 'domain/provider/span_provider.dart';
import 'domain/provider/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    // runApp(DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(), // Wrap your app
    // ));
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FieldingProvider()),
        ChangeNotifierProvider(create: (_) => SpanProvider()),
        ChangeNotifierProvider(create: (_) => RiserProvider()),
        ChangeNotifierProvider(create: (_) => AnchorProvider()),
        ChangeNotifierProvider(create: (_) => IntroProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
          BlocProvider<FieldingBloc>(create: (context) => FieldingBloc()),
          BlocProvider<DownloadImageBloc>(create: (context) => DownloadImageBloc()),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context), // Add the locale here
          builder: DevicePreview.appBuilder,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: GoogleFonts.poppins().fontFamily),
          initialRoute: '/root',
          getPages: [GetPage(name: '/root', page: () => RootPage())],
        ),
      ),
    );
  }
}
