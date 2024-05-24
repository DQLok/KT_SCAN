import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teca/objects/account.dart';
import 'package:teca/store_preference/store_preference.dart';
import 'package:teca/views/splash/splash.dart';
import 'package:teca/widgets/toast_cus.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  AppPreference appPreference = AppPreference();

  signInWithAccount() {
    if (controllerPhone.text.isEmpty) {
      showToastCusCenter("Nhập số điện thoại!!!");
      return;
    }
    if (controllerPassword.text.isEmpty) {
      showToastCusCenter("Nhập mật khẩu!!!");
      return;
    }
    Account account =
        Account(phone: controllerPhone.text, password: controllerPassword.text);
    appPreference.setConfig("account", jsonEncode(account.toJson()));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SplashPage()));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double paddingV = MediaQuery.viewPaddingOf(context).vertical;
    double paddingH = MediaQuery.viewPaddingOf(context).horizontal;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Image.asset("assets/logo/logo.jpg"),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text("Số điện thoại",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                  TextField(
                    controller: controllerPhone,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text("Mật khẩu",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                  TextField(
                    controller: controllerPassword,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(
            10, 0, 10, MediaQuery.viewPaddingOf(context).bottom),
        child: ElevatedButton(          
            onPressed: () {
              signInWithAccount();
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20),backgroundColor: Colors.redAccent,),
            child: const Text(
              "Đăng nhập",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
