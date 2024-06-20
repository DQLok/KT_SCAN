import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:techable/views/ar/ar.dart';
import 'package:techable/views/qr_code/qr_code.dart';
import 'package:techable/views/result_filter/result_filter.dart';
import 'package:techable/views/result_filter/widgets/camera_customer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getImage();
  }

  getImage() async {
    http.Response response = await http.get(
      Uri.parse('https://images.indianexpress.com/2019/09/toys.jpg'),
    );
    Uint8List value = response.bodyBytes;
    print(value);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset("assets/logo/logo.png"))),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CameraCustomer()));
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.redAccent)),
                            child: const Text(
                              "Scan Bill",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      const Expanded(child: SizedBox())
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                          flex: 2,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const QRCode()));
                              },
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.redAccent)),
                              child: const Text(
                                "Scan QRCode",
                                style: TextStyle(color: Colors.white),
                              ))),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                          flex: 2,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AR()));
                              },
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.redAccent)),
                              child: const Text(
                                "AR",
                                style: TextStyle(color: Colors.white),
                              ))),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  // CachedNetworkImage(
                  //   width: 100,
                  //   height: 300,
                  //   imageUrl:
                  //       "https://images.indianexpress.com/2019/09/toys.jpg",
                  //   // "http://cropper-sz.oss-cn-shenzhen.aliyuncs.com/SCH/RLM2003EI/BUILD_MAP/1cd5bc.png",
                  //   imageBuilder: (context, imageProvider) {
                  //     imageProvider
                  //         .obtainKey(createLocalImageConfiguration(context))
                  //         .then((value) {
                  //       imageProvider.resolve(value, (bytes,
                  //           {allowUpscaling = true,
                  //           cacheHeight = 200,
                  //           cacheWidth = 200}) async {
                  //         var asUint8List = bytes.buffer.asUint8List();

                  //         var f = File(pt.path + "/m.jpg");
                  //         file = await f.writeAsBytes(asUint8List);
                  //         setState(() {
                  //           file;
                  //         });

                  //         return instantiateImageCodec(asUint8List);
                  //       });
                  //       print(value);
                  //     });

                  //     return Image(
                  //       image: imageProvider,
                  //     );
                  //   },
                  //   placeholder: (context, url) => CircularProgressIndicator(),
                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResultFilterPage()));
                          },
                          child: const Text(
                            "Danh sách bill của bạn",
                            style: TextStyle(color: Colors.redAccent),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
