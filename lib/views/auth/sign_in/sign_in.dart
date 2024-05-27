import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techable/configs/provider/auth_provider.dart';
import 'package:techable/constants/colors_app.dart';
import 'package:techable/constants/dimension_app.dart';
import 'package:techable/constants/image_app.dart';
import 'package:techable/constants/static_app.dart';
import 'package:techable/constants/text_style.dart';
import 'package:techable/views/auth/sign_up/sign_up.dart';
import 'package:techable/widgets/image_cus.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authPro = ref.watch(authProvider);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(
            vertical: paddingScreen(context, StaticApp.vertical),
            horizontal: paddingScreen(context, StaticApp.horizontal)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageCus(
                imagePath: ImageApp.logoApp,
                height: sizeScreen(context, StaticApp.height) / 10,
                width: sizeScreen(context, StaticApp.width) / 1.2,
                margin: const EdgeInsets.symmetric(vertical: 10),
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
                          "sign_in".tr(),
                          style: TextStyleApp.inter_s25_b_b_primary.style,
                        )),
                    TextField(
                      controller: authPro.controllerPhoneSi,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Nhập số điện thoại",
                          prefixIcon: Icon(Icons.local_phone_rounded)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: authPro.controllerPasswordSi,
                  obscureText: authPro.showAndHidePassSi,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nhập mật khẩu",
                      suffixIcon: IconButton(
                          onPressed: () {
                            authPro.checkShowAndHidePasswordSignIn();
                          },
                          icon: authPro.showAndHidePassSi
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      prefixIcon: Icon(
                        Icons.password,
                        color: ColorsApp.primary,
                      )),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: authPro.saveAccount,
                            onChanged: (val) {
                              authPro.checkSAveAccount();
                            },
                            activeColor: ColorsApp.primary,
                          ),
                          Text(
                            "Ghi nhớ tài khoản",
                            style: TextStyle(color: ColorsApp.primary),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Quên mật khẩu?",
                                  style: TextStyle(color: ColorsApp.primary),
                                ))))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Điều khoản",
                      style: TextStyle(color: ColorsApp.primary),
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      authPro.signInWithAccount(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: ColorsApp.primary,
                    ),
                    child: const Text(
                      "Đăng nhập",
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
                              builder: (context) => const SignUpPage()));
                    },
                    child: Text(
                      "Đăng kí tài khoản mới",
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
