import 'dart:io';

import 'package:flutter/material.dart';
import 'package:techable/main.dart';
import 'package:techable/views/ar/_android/ar_android.dart';
import 'package:techable/views/ar/_ios/ar_ios.dart';

class AR extends StatefulWidget {
  const AR({super.key});

  @override
  State<AR> createState() => _ARState();
}

class _ARState extends State<AR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earth Sample'),
        leading: InkWell(
          onTap: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const HomePage()));
            Navigator.pop(navigatorKey.currentContext!);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Platform.isAndroid
          ? const ARAndroid()
          : Platform.isIOS
              ? const ARIos()
              : const SizedBox(
                  child: Text("AR"),
                ),
    );
  }
}
