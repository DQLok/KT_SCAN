import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techable/configs/provider/auth_provider.dart';
import 'package:techable/constants/colors_app.dart';
import 'package:techable/constants/dimension_app.dart';
import 'package:techable/constants/image_app.dart';
import 'package:techable/constants/static_app.dart';
import 'package:techable/constants/text_style.dart';
import 'package:techable/views/auth/sign_in/sign_in.dart';
import 'package:techable/widgets/image_cus.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authPro = ref.watch(authProvider);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: DimensionApp.size20),
        padding: EdgeInsets.only(
            top: MediaQuery.viewPaddingOf(context).top,
            bottom: MediaQuery.viewPaddingOf(context).bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageCus(
                imagePath: ImageApp.logoApp,
                height: sizeScreen(context, StaticApp.height) / 10,
                width: sizeScreen(context, StaticApp.width) / 1.2,
                margin:
                    const EdgeInsets.symmetric(vertical: DimensionApp.size10),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: DimensionApp.size5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: DimensionApp.size20),
                        child: Text(
                          "sign_up".tr(),
                          style: TextStyleApp.inter_s25_b_b_primary.style,
                        )),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: DimensionApp.size10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin:
                            const EdgeInsets.only(right: DimensionApp.size5),
                        child: TextField(
                          controller: authPro.controllerFamilyName,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Họ",
                              prefixIcon: Icon(Icons.person_outline_rounded)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: DimensionApp.size5),
                        child: TextField(
                          controller: authPro.controllerFamilyName,
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
                margin:
                    const EdgeInsets.symmetric(vertical: DimensionApp.size10),
                child: TextField(
                  controller: authPro.controllerPhoneSu,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nhập số điện thoại",
                      prefixIcon: Icon(Icons.local_phone_rounded)),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: DimensionApp.size10),
                child: TextField(
                  controller: authPro.controllerEmail,
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
                margin:
                    const EdgeInsets.symmetric(vertical: DimensionApp.size10),
                child: TextField(
                  controller: authPro.controllerPasswordSu,
                  obscureText: authPro.showAndHidePassSu,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nhập mật khẩu",
                      suffixIcon: IconButton(
                          onPressed: () {
                            authPro.checkShowandHidePassSu();
                          },
                          icon: authPro.showAndHidePassSu
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      prefixIcon: Icon(
                        Icons.password,
                        color: ColorsApp.primary,
                      )),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: DimensionApp.size10),
                child: TextField(
                  controller: authPro.controllerPasswordConfirm,
                  obscureText: authPro.showAndHidePassConfrim,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Xác nhận mật khẩu",
                      suffixIcon: IconButton(
                          onPressed: () {
                            authPro.checkShowandHidePassConfirm();
                          },
                          icon: authPro.showAndHidePassConfrim
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                      prefixIcon: Icon(
                        Icons.password,
                        color: ColorsApp.primary,
                      )),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: DimensionApp.size10),
                child: TextField(
                  controller: authPro.controllerReferCode,
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
                      value: authPro.accessTermSu,
                      onChanged: (val) {
                        authPro.checkAccessTerm();
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
                      authPro.signUpWithAccount(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: DimensionApp.size20),
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
