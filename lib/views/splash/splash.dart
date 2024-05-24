import 'package:flutter/material.dart';
import 'package:teca/store_preference/store_preference.dart';
import 'package:teca/views/home/home.dart';
import 'package:teca/views/sign_in/sign_in.dart';
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
    String value = await appPreference.getConfig("account");
    timers.timeout(Duration.zero);
    if (value.isNotEmpty) {
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset("assets/splash/scan.json")),
    );
  }
}
