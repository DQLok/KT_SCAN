import 'package:flutter/material.dart';
import 'package:techable/constants/image_app.dart';
import 'package:techable/constants/preference_app.dart';
import 'package:techable/routes/routes_path.dart';
import 'package:techable/store_preference/store_preference.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AppPreference appPreference = AppPreference();
  Future<dynamic> timers = Future(() {});

  @override
  void initState() {
    super.initState();
    if (mounted) {
      timers =
          Future.delayed(const Duration(seconds: 2), () => getAccountSaved());
    }
  }

  getAccountSaved() async {
    String value = await appPreference.getConfig(PreferenceApp.keyAccount);
    timers.timeout(Duration.zero);
    if (value.isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, RoutesPath.home);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, RoutesPath.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset(ImageApp.splash)),
    );
  }
}
