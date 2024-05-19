import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kt_scan_text/main.dart';
import 'package:kt_scan_text/views/home/home.dart';
import 'package:kt_scan_text/views/result_filter/result_filter.dart';
import 'package:kt_scan_text/views/scans/scan_text_gg.dart';

class CameraCustomer extends StatefulWidget {
  const CameraCustomer({super.key});

  @override
  State<CameraCustomer> createState() => _CameraCustomerState();
}

class _CameraCustomerState extends State<CameraCustomer> {
  late CameraController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(cameras.first, ResolutionPreset.max);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case "CameraAccessDenied":
            print("access was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  takeAPicture() async {
    if (!cameraController.value.isInitialized) {
      return null;
    }
    if (cameraController.value.isTakingPicture) {
      return null;
    }

    try {
      await cameraController.setFlashMode(FlashMode.auto);
      XFile picture = await cameraController.takePicture();
      if (picture.path.isNotEmpty) {
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
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  shape: BoxShape.rectangle),
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width/1.3,
              child: CameraPreview(cameraController)),
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
                                  builder: (context) => HomePage()));
                        },
                        icon: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                            ))),
                  ),
                  Expanded(
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
                      child: SizedBox())
                ],
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        takeAPicture();
                      },
                      icon: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                },
                                child: Text(
                                  "Trở về Trang chủ",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontStyle: FontStyle.normal),
                                )),
                          )),
                      Expanded(child: Spacer()),
                      Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResultFilterPage()));
                              },
                              child: Text(
                                "Danh sách bill".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ))
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
