import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teca/utils/utils.dart';
import 'package:teca/views/home/home.dart';
import 'package:teca/views/result_filter/result_filter.dart';
import 'package:teca/views/result_filter/widgets/camera_customer.dart';

class ResultScan extends StatefulWidget {
  const ResultScan({super.key, required this.pathIamge});
  final String pathIamge;

  @override
  State<ResultScan> createState() => _ResultScanState();
}

class _ResultScanState extends State<ResultScan> {
  File fileImge = File("");
  bool checkPathImg = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      checkFileinLocal();
    }
  }

  checkFileinLocal() async {
    String path = widget.pathIamge;
    if (path.isNotEmpty) {
      String pathCache = await getLocalPathCache(path);
      fileImge = File(pathCache);
      if (fileImge.existsSync()) {
        checkPathImg = true;
      } else {
        String pathApplication = await getLocalTemporaryPath(path);
        fileImge = File(pathApplication);
        if (fileImge.existsSync()) {
          checkPathImg = true;
        } else {
          checkPathImg = false;
        }
      }
    } else {
      checkPathImg = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double paddingV = MediaQuery.viewPaddingOf(context).vertical;
    double paddingH = MediaQuery.viewPaddingOf(context).horizontal;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.9),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraCustomer()));
                    },
                    icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ))),
                Text(
                  "Hoàn tất".toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 50,
                )
              ],
            ),
            Center(
              child: checkPathImg
                  ? Column(
                      children: [
                        Stack(children: [
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width / 1.5,
                                height: MediaQuery.of(context).size.height / 2,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(fileImge),
                                      fit: BoxFit.fill),
                                  border: Border.all(color: Colors.greenAccent),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              bottom: 0,
                              left: MediaQuery.of(context).size.width / 3.5,
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.greenAccent,
                                size: 50,
                              ))
                        ]),
                        const Text("Thông tin Bill được lưu thành công")
                      ],
                    )
                  : Stack(children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: const Icon(
                          Icons.image,
                          size: 200,
                        ),
                      ),
                    ]),
            ),
            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.redAccent),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
                      child: const Text("Trở về Trang chủ",
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal)),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ResultFilterPage()));
                        },
                        child: const Text("Danh sách Bill",
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal))))
              ],
            )
          ],
        ),
      ),
    );
  }
}
