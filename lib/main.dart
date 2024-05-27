import 'dart:convert';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techable/constants/colors_app.dart';
import 'package:techable/constants/image_app.dart';
import 'package:techable/constants/preference_app.dart';
import 'package:techable/constants/static_app.dart';
import 'package:techable/objects/locale_cus.dart';
import 'package:techable/routes/routes_generator.dart';
import 'package:techable/routes/routes_path.dart';
import 'package:techable/store_preference/store_preference.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: settingInitLanguageApp(),
      path: ImageApp.translations,
      fallbackLocale: const Locale("vi", "VI"),
      useOnlyLangCode: true,
      child: const ProviderScope(child: MyApp())));
}

settingInitLanguageApp() {
  List<Locale> listLocale = [];
  LocaleCus localeCus = listLocaleCus.first;
  int index = listLocaleCus.indexWhere(
    // ignore: deprecated_member_use
    (element) => element.country == window.locale.countryCode,
  );
  if (index == -1) {
    for (var element in listLocaleCus) {
      listLocale.add(element.locale!);
    }
    localeCus = listLocaleCus.first;
  } else {
    listLocale.add(listLocaleCus.elementAt(index).locale!);
    for (var i = 0; i < listLocaleCus.length; i++) {
      if (i != index) {
        listLocale.add(listLocaleCus.elementAt(i).locale!);
      }
    }
    localeCus = listLocaleCus.elementAt(index);
  }
  AppPreference appPreference = AppPreference();
  appPreference.setConfig(
      PreferenceApp.keyLanguage, jsonEncode(localeCus.toJson()));
  return listLocale;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StaticApp.nameApp,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorsApp.primary),
        useMaterial3: true,
      ),
      initialRoute: RoutesPath.splash,
      onGenerateRoute: RoutesGenerator.getRoutes,
      navigatorKey: navigatorKey,
    );
  }
}
