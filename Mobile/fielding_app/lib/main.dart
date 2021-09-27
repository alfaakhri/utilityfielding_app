// @dart=2.9

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:fielding_app/domain/bloc/download_image_bloc/download_image_bloc.dart';
import 'package:fielding_app/domain/bloc/fielding_bloc/fielding_bloc.dart';
import 'package:fielding_app/domain/provider/local_provider.dart';
import 'package:fielding_app/presentation/ui/ui.exports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'data/repository/api_provider.dart';
import 'domain/bloc/auth_bloc/auth_bloc.dart';
import 'domain/bloc/local_bloc/local_bloc.dart';
import 'domain/bloc/location_bloc/location_bloc.dart';
import 'domain/bloc/map_bloc/map_bloc.dart';
import 'domain/bloc/picture_bloc/picture_bloc.dart';
import 'domain/provider/provider.exports.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'domain/provider/symbol_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize('resource://drawable/launcher_icon', // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: "Notification example",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            enableVibration: true),
        NotificationChannel(
            icon: 'resource://drawable/launcher_icon',
            channelKey: 'progress_bar',
            channelName: 'Progress bar notifications',
            channelDescription: 'Notifications with a progress bar layout',
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple,
            vibrationPattern: lowVibrationPattern,
            onlyAlertOnce: true),
        NotificationChannel(
            channelKey: 'grouped',
            channelName: 'Grouped notifications',
            channelDescription: 'Notifications with group functionality',
            groupKey: 'grouped',
            groupSort: GroupSort.Desc,
            groupAlertBehavior: GroupAlertBehavior.Children,
            defaultColor: Colors.lightGreen,
            ledColor: Colors.lightGreen,
            vibrationPattern: lowVibrationPattern,
            playSound: true,
            defaultRingtoneType: DefaultRingtoneType.Notification,
            importance: NotificationImportance.High)
      ]);
  // Create the initialization for your desired push service here
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FlutterDownloader.initialize(debug: true // optional: set false to disable printing logs to console
      );
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    // runApp(DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(), // Wrap your app
    // ));
    runApp(MyApp());
  });
}

// Declared as global, outside of any class
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  // Use this method to automatically convert the push data, in case you gonna use our data standard
  AwesomeNotifications().createNotificationFromJsonData(message.data);
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
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => LocalProvider()),
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProvider(create: (_) => SymbolProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
          BlocProvider<FieldingBloc>(create: (context) => FieldingBloc()),
          BlocProvider<DownloadImageBloc>(create: (context) => DownloadImageBloc()),
          BlocProvider<MapBloc>(create: (context) => MapBloc()),
          BlocProvider<LocalBloc>(create: (context) => LocalBloc()),
          BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
          BlocProvider<PictureBloc>(create: (context) => PictureBloc()),
        ],
        child: StreamProvider<ConnectivityStatus>(
          initialData: ConnectivityStatus.Offline,
          create: (context) => ConnectionProvider().connectionStatusController.stream,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.locale(context), // Add the locale here
            builder: DevicePreview.appBuilder,
            theme: ThemeData(primarySwatch: Colors.blue, fontFamily: GoogleFonts.poppins().fontFamily),
            initialRoute: '/root',
            getPages: [GetPage(name: '/root', page: () => RootPage())],
          ),
        ),
      ),
    );
  }
}
