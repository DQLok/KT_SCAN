import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techable/configs/provider/scan_provider.dart';
import 'package:techable/constants/dimension_app.dart';
import 'package:techable/constants/static_app.dart';
import 'package:techable/routes/routes_path.dart';
import 'package:techable/views/home/home.dart';

class CameraCustomer extends ConsumerWidget {
  const CameraCustomer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanPro = ref.watch(scanProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Center(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.redAccent.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(DimensionApp.size10)),
                  shape: BoxShape.rectangle),
              height: sizeScreen(context, StaticApp.height) / 1.5,
              width: sizeScreen(context, StaticApp.width) / 1.3,
              child: scanPro.cameraController != null
                  ? CameraPreview(scanPro.cameraController!)
                  : const SizedBox()),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: paddingScreen(context, StaticApp.vertical),
              horizontal: paddingScreen(context, StaticApp.horizontal)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: IconButton(
                        alignment: Alignment.topLeft,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        icon: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                            ))),
                  ),
                  Expanded(
                    child: Text(
                      "Quét Bill".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.redAccent,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                      child:
                          // Platform.isAndroid
                          //     ? IconButton(
                          //         alignment: Alignment.centerRight,
                          //         onPressed: () {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       const ScanDocPage()));
                          //         },
                          //         icon: const Icon(
                          //           Icons.document_scanner_outlined,
                          //           color: Colors.white,
                          //         ))
                          //     :
                          SizedBox())
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: IconButton(
                            onPressed: () {
                              scanPro.getPicture(context, ImageSource.gallery);
                            },
                            icon: const Icon(
                                Icons.photo_size_select_actual_rounded)),
                      ),
                      IconButton(
                          onPressed: scanPro.cameraController == null
                              ? null
                              : () {
                                  scanPro.takeAPicture(context);
                                },
                          icon: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.redAccent,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          )),
                      SizedBox(
                        child: IconButton(
                            onPressed: scanPro.cameraController == null
                                ? null
                                : () {
                                    scanPro.switchCamera();
                                  },
                            icon: const Icon(Icons.camera)),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RoutesPath.home);
                            },
                            child: Text(
                              "Trở về Trang chủ".toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontStyle: FontStyle.normal),
                            )),
                      ),
                      const Spacer(),
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RoutesPath.resultFilter);
                          },
                          child: Text(
                            "Danh sách bill".toUpperCase(),
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
