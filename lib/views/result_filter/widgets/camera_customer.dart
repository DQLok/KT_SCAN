import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kt_scan_text/main.dart';
import 'package:kt_scan_text/views/home/home.dart';
import 'package:kt_scan_text/views/result_filter/result_filter.dart';
import 'package:kt_scan_text/views/scan_doc.dart/scan_doc.dart';
import 'package:kt_scan_text/views/scans/scan_text_gg.dart';

class CameraCustomer extends StatefulWidget {
  const CameraCustomer({super.key});

  @override
  State<CameraCustomer> createState() => _CameraCustomerState();
}

class _CameraCustomerState extends State<CameraCustomer> {
  CameraController? cameraController;
  File? fileImg;
  ImagePicker? imgPicker;

  @override
  void initState() {
    super.initState();
    imgPicker = ImagePicker();
    if (cameras.isEmpty) return;
    cameraController = CameraController(cameras.first, ResolutionPreset.max);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case "CameraAccessDenied":
            break;
          default:
            break;
        }
      }
    });
  }

  takeAPicture() async {
    if (!cameraController!.value.isInitialized) {
      return null;
    }
    if (cameraController!.value.isTakingPicture) {
      return null;
    }

    try {
      await cameraController!.setFlashMode(FlashMode.auto);
      XFile picture = await cameraController!.takePicture();
      if (picture.path.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScanTextGg(
                      xFile: picture,
                    )));
      }
    } on CameraException catch (e) {
      debugPrint("Error occured while taking picture : $e");
      return null;
    }
  }

  Future getImage(ImageSource source) async {
    setState(() {
      imgPicker = ImagePicker();
    });
    final pickedfile = await imgPicker!.pickImage(source: source);
    if (pickedfile != null) {
      if (pickedfile.path.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScanTextGg(
                      xFile: pickedfile,
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingV = MediaQuery.viewPaddingOf(context).vertical;
    double paddingH = MediaQuery.viewPaddingOf(context).horizontal;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Center(
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  shape: BoxShape.rectangle),
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width / 1.3,
              child: cameraController != null
                  ? CameraPreview(cameraController!)
                  : const SizedBox()),
        ),
        Container(
          padding:
              EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
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
                  const Expanded(
                    child: Text(
                      "Quét Bill",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Platform.isAndroid
                          ? IconButton(
                              alignment: Alignment.centerRight,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ScanDocPage()));
                              },
                              icon: const Icon(
                                Icons.document_scanner_outlined,
                                color: Colors.white,
                              ))
                          : const SizedBox())
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
                              getImage(ImageSource.gallery);
                            },
                            icon: const Icon(
                                Icons.photo_size_select_actual_rounded)),
                      ),
                      IconButton(
                          onPressed: cameraController == null
                              ? null
                              : () {
                                  takeAPicture();
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
                            onPressed: () {}, icon: const Icon(Icons.camera)),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            },
                            child: const Text(
                              "Trở về Trang chủ",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontStyle: FontStyle.normal),
                            )),
                      ),
                      const Spacer(),
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResultFilterPage()));
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
