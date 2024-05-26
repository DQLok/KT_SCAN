import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:techable/static_app/colors_app.dart';
import 'package:techable/objects/account.dart';
import 'package:techable/store_preference/store_preference.dart';
import 'package:techable/views/sign_in/sign_in.dart';
import 'package:techable/views/splash/splash.dart';
import 'package:techable/widgets/toast_cus.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AppPreference appPreference = AppPreference();
  TextEditingController controllerFamilyName = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPasswordConfirm = TextEditingController();
  TextEditingController controllerReferCode = TextEditingController();
  bool showAndHidePass = true;
  bool showAndHidePassConfrim = true;
  bool accessTerm = true;

  checkShowandHidePass() {
    setState(() {
      showAndHidePass = !showAndHidePass;
    });
  }

  checkShowandHidePassConfirm() {
    setState(() {
      showAndHidePassConfrim = !showAndHidePassConfrim;
    });
  }

  checkAccessTerm() {
    setState(() {
      accessTerm = !accessTerm;
    });
  }

  signUpWithAccount() {
    if (controllerFamilyName.text.isEmpty) {
      showToastCusCenter("Nhập số điện thoại!!!");
      return;
    }
    if (controllerName.text.isEmpty) {
      showToastCusCenter("Nhập số điện thoại!!!");
      return;
    }
    if (controllerPhone.text.isEmpty) {
      showToastCusCenter("Nhập số điện thoại!!!");
      return;
    }
    if (controllerPassword.text.isEmpty) {
      showToastCusCenter("Nhập mật khẩu!!!");
      return;
    }
    if (controllerPhone.text.isEmpty) {
      showToastCusCenter("Nhập số điện thoại!!!");
      return;
    }
    if (controllerPasswordConfirm.text.isEmpty) {
      showToastCusCenter("Nhập mật khẩu xác nhận!!!");
      return;
    }
    if (controllerPassword.text != controllerPasswordConfirm.text) {
      showToastCusCenter("Mật khẩu và mật khẩu xác nhận không trùng khớp!!!");
      return;
    }
    if (!accessTerm) {
      showToastCusCenter("Bạn phải đồng ý với điều khoản");
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
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.only(
            top: MediaQuery.viewPaddingOf(context).top,
            bottom: MediaQuery.viewPaddingOf(context).bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Image.asset("assets/logo/icon.jpg"),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(
                              color: ColorsApp.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        )),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: TextField(
                          controller: controllerFamilyName,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Họ",
                              prefixIcon: Icon(Icons.person_outline_rounded)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: TextField(
                          controller: controllerFamilyName,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Tên",
                              prefixIcon: Icon(Icons.person_outline_rounded)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: controllerPhone,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nhập số điện thoại",
                      prefixIcon: Icon(Icons.local_phone_rounded)),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nhập Email",
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: ColorsApp.primary,
                      )),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: controllerPassword,
                  obscureText: showAndHidePass,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nhập mật khẩu",
                      suffixIcon: IconButton(
                          onPressed: () {
                            checkShowandHidePass();
                          },
                          icon: showAndHidePass
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      prefixIcon: Icon(
                        Icons.password,
                        color: ColorsApp.primary,
                      )),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: controllerPasswordConfirm,
                  obscureText: showAndHidePassConfrim,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Xác nhận mật khẩu",
                      suffixIcon: IconButton(
                          onPressed: () {
                            checkShowandHidePassConfirm();
                          },
                          icon: showAndHidePassConfrim
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      prefixIcon: Icon(
                        Icons.password,
                        color: ColorsApp.primary,
                      )),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: controllerReferCode,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nhập mã giới thiệu",
                      prefixIcon: Icon(
                        Icons.code_rounded,
                        color: ColorsApp.primary,
                      )),
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: accessTerm,
                      onChanged: (val) {
                        checkAccessTerm();
                      },
                      activeColor: ColorsApp.primary,
                    ),
                    Text(
                      "Tôi đồng ý với các điều khoản!",
                      style: TextStyle(color: ColorsApp.primary),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      signUpWithAccount();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: ColorsApp.primary,
                    ),
                    child: const Text(
                      "Đăng ký",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()));
                    },
                    child: Text(
                      "Trở về đăng nhập",
                      style: TextStyle(color: ColorsApp.primary),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
