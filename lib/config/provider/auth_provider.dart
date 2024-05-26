import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techable/objects/account.dart';
import 'package:techable/store_preference/store_preference.dart';
import 'package:techable/views/splash/splash.dart';
import 'package:techable/widgets/toast_cus.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider(this.ref);
  final Ref ref;
  AppPreference appPreference = AppPreference();
  //sign in
  TextEditingController controllerPhoneSi = TextEditingController();
  TextEditingController controllerPasswordSi = TextEditingController();
  bool showAndHidePassSi = true;
  bool saveAccount = true;

  //*sign in
  signInWithAccount(BuildContext context) {
    if (controllerPhoneSi.text.isEmpty) {
      showToastCusCenter("Nhập số điện thoại!!!");
      return;
    }
    if (controllerPasswordSi.text.isEmpty) {
      showToastCusCenter("Nhập mật khẩu!!!");
      return;
    }
    if (saveAccount) {
      Account account = Account(
          phone: controllerPhoneSi.text, password: controllerPasswordSi.text);
      appPreference.setConfig("account", jsonEncode(account.toJson()));
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SplashPage()));
    notifyListeners();
  }

  checkShowAndHidePasswordSignIn() {
    showAndHidePassSi = !showAndHidePassSi;
    notifyListeners();
  }

  checkSAveAccount() {
    saveAccount = !saveAccount;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref);
});