import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teca/main.dart';
import 'package:teca/views/home/home.dart';
import 'package:teca/views/result_filter/result_filter.dart';
import 'package:teca/views/scans/scan_text_gg.dart';

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
        Navigator.push(
            // ignore: use_build_context_synchronously
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
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => ScanTextGg(
                      xFile: pickedfile,
                    )));
      }
    }
  }

  switchCamera() {
    if (cameras.isEmpty) return;
    if (cameraController == null) return;
    final lensDirection = cameraController!.description.lensDirection;
    if (lensDirection == CameraLensDirection.front) {
      cameraController = CameraController(cameras.first, ResolutionPreset.high);
    } else {
      cameraController = CameraController(cameras.last, ResolutionPreset.high);
    }
    cameraController!.initialize().then(
      (value) {
        if (!mounted) return;
        setState(() {});
      },
    );
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
              decoration: BoxDecoration(
                  color: Colors.redAccent.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                            onPressed: cameraController == null
                                ? null
                                : () {
                                    switchCamera();
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
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
