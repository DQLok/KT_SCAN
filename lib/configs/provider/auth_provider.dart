import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techable/constants/preference_app.dart';
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
  //sign up
  TextEditingController controllerFamilyName = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhoneSu = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPasswordSu = TextEditingController();
  TextEditingController controllerPasswordConfirm = TextEditingController();
  TextEditingController controllerReferCode = TextEditingController();
  bool showAndHidePassSu = true;
  bool showAndHidePassConfrim = true;
  bool accessTermSu = true;

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
      appPreference.setConfig(
          PreferenceApp.keyAccount, jsonEncode(account.toJson()));
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

  //*sign up
  signUpWithAccount(BuildContext context) {
    if (controllerFamilyName.text.isEmpty) {
      showToastCusCenter("Nhập họ!!!");
      return;
    }
    if (controllerName.text.isEmpty) {
      showToastCusCenter("Nhập tên!!!");
      return;
    }
    if (controllerPhoneSu.text.isEmpty) {
      showToastCusCenter("Nhập số điện thoại!!!");
      return;
    }
    if (controllerPasswordSu.text.isEmpty) {
      showToastCusCenter("Nhập mật khẩu!!!");
      return;
    }
    if (controllerPhoneSu.text.isEmpty) {
      showToastCusCenter("Nhập số điện thoại!!!");
      return;
    }
    if (controllerPasswordConfirm.text.isEmpty) {
      showToastCusCenter("Nhập mật khẩu xác nhận!!!");
      return;
    }
    if (controllerPasswordSu.text != controllerPasswordConfirm.text) {
      showToastCusCenter("Mật khẩu và mật khẩu xác nhận không trùng khớp!!!");
      return;
    }
    if (!accessTermSu) {
      showToastCusCenter("Bạn phải đồng ý với điều khoản");
      return;
    }
    Account account = Account(
        phone: controllerPhoneSu.text, password: controllerPasswordSu.text);
    appPreference.setConfig(
        PreferenceApp.keyAccount, jsonEncode(account.toJson()));

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SplashPage()));
    notifyListeners();
  }

  checkShowandHidePassSu() {
    showAndHidePassSu = !showAndHidePassSu;
    notifyListeners();
  }

  checkShowandHidePassConfirm() {
    showAndHidePassConfrim = !showAndHidePassConfrim;
    notifyListeners();
  }

  checkAccessTerm() {
    accessTermSu = !accessTermSu;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref);
});
