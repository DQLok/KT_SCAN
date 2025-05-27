import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techable/objects/list_bill_status.dart';
import 'package:techable/objects/text_group.dart';
import 'package:techable/store_preference/store_preference.dart';
import 'package:techable/utils/utils.dart';
import 'package:techable/views/result_filter/widgets/camera_customer.dart';
import 'package:techable/views/result_filter/widgets/result_scan.dart';
import 'package:techable/views/scans/scan_text_gg.dart';

class ScanProvider with ChangeNotifier {
  ScanProvider(this.ref);
  final Ref ref;
  AppPreference appPreference = AppPreference();
  //
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  XFile? imageFile;
  ImagePicker imagePicker = ImagePicker();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  List<TextBlock> blocks = [];
  List<TextGroup> listTextGroupBlocks = [];
  List<TextGroup> listStandardAngle = [];
  List<KeyValueFilter> listKeyValues = [];
  bool showHideDetail = false;

  getInitCamera() async {
    cameras = await availableCameras();
    if (cameras.isEmpty) return;
    cameraController = CameraController(cameras.first, ResolutionPreset.max,
        enableAudio: false);
    cameraController!
        .initialize()
        .then(
          (value) {},
        )
        .catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case "CameraAccessDenied":
            break;
          default:
            break;
        }
      }
    });
    notifyListeners();
  }

  takeAPicture(BuildContext context) async {
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
          (value) {},
        );
    notifyListeners();
  }

  viewDetailScan() {
    showHideDetail = !showHideDetail;
    notifyListeners();
  }

  //select picture
  getPicture(BuildContext context, ImageSource source) async {
    imageFile = await imagePicker.pickImage(source: source);
    if (imageFile != null) {
      CroppedFile? croppedFile;
      if (imageFile!.path != "") {
        croppedFile = await ImageCropper().cropImage(
            sourcePath: imageFile!.path,
            //     aspectRatioPresets: [
            //   CropAspectRatioPreset.square,
            //   CropAspectRatioPreset.ratio3x2,
            //   CropAspectRatioPreset.original,
            //   CropAspectRatioPreset.ratio4x3,
            //   CropAspectRatioPreset.ratio16x9
            // ]
            // ,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Chọn vùng dữ liệu',
                toolbarColor: Colors.redAccent,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false,
              ),
              IOSUiSettings(
                title: 'Cropper',
                aspectRatioPresets: [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                ],
              ),
            ]);
      }
      if (croppedFile != null) {
        imageFile = XFile(croppedFile.path);
        InputImage inputImage = InputImage.fromFilePath(croppedFile.path);
        await processImage(inputImage);
         Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => ScanTextGg(
                      xFile: imageFile!,
                    )));       
      } else {
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CameraCustomer()));
      }
    }
  }

  Future processImage(InputImage inputImage) async {
    blocks.clear();
    listTextGroupBlocks.clear();
    listStandardAngle.clear();
    listKeyValues.clear();
    final recognizedText = await textRecognizer.processImage(inputImage);
    if (inputImage.metadata?.size == null ||
        inputImage.metadata?.rotation == null) {
      blocks = recognizedText.blocks;
      filterBlocks();
      processOption();
    }
  }

  //filter blocks
  filterBlocks() {
    blocks.sort(
      (a, b) => a.cornerPoints.first.y.compareTo(b.cornerPoints.first.y),
    );
    for (var i = 0; i < blocks.length; i++) {
      List<Point> list = [
        Point(
            x: blocks.elementAt(i).cornerPoints.first.x,
            y: blocks.elementAt(i).cornerPoints.first.y),
        Point(
            x: blocks.elementAt(i).cornerPoints.elementAt(1).x,
            y: blocks.elementAt(i).cornerPoints.elementAt(1).y),
        Point(
            x: blocks.elementAt(i).cornerPoints.elementAt(2).x,
            y: blocks.elementAt(i).cornerPoints.elementAt(2).y),
        Point(
            x: blocks.elementAt(i).cornerPoints.last.x,
            y: blocks.elementAt(i).cornerPoints.last.y)
      ];
      listTextGroupBlocks.add(TextGroup(
          index: "$i",
          conrnerPoints: ConrnerPoints(
              pointLT: list.first,
              pointRT: list.elementAt(1),
              pointRB: list.elementAt(2),
              pointLB: list.last),
          text: blocks.elementAt(i).text));
    }
  }

  //process blocks
  processOption() {
    //---Step1: get 4 corner----
    TextGroup pointL = listTextGroupBlocks.reduce((value, element) => value
                    .conrnerPoints.pointLT.x <
                element.conrnerPoints.pointLT.x ||
            value.conrnerPoints.pointLT.x < element.conrnerPoints.pointLB.x ||
            value.conrnerPoints.pointLB.x < element.conrnerPoints.pointLT.x ||
            value.conrnerPoints.pointLB.x < element.conrnerPoints.pointLB.x
        ? value
        : element);
    TextGroup pointR = listTextGroupBlocks.reduce((value, element) => value
                    .conrnerPoints.pointRT.x >
                element.conrnerPoints.pointRT.x ||
            value.conrnerPoints.pointRT.x > element.conrnerPoints.pointRB.x ||
            value.conrnerPoints.pointRB.x > element.conrnerPoints.pointRT.x ||
            value.conrnerPoints.pointRB.x > element.conrnerPoints.pointRB.x
        ? value
        : element);
    TextGroup pointT = listTextGroupBlocks.reduce((value, element) => value
                    .conrnerPoints.pointLT.y <
                element.conrnerPoints.pointLT.y ||
            value.conrnerPoints.pointLT.y < element.conrnerPoints.pointRT.y ||
            value.conrnerPoints.pointRT.y < element.conrnerPoints.pointLT.y ||
            value.conrnerPoints.pointRT.y < element.conrnerPoints.pointRT.y
        ? value
        : element);
    TextGroup pointB = listTextGroupBlocks.reduce((value, element) => value
                    .conrnerPoints.pointLB.y >
                element.conrnerPoints.pointLB.y ||
            value.conrnerPoints.pointLB.y > element.conrnerPoints.pointRB.y ||
            value.conrnerPoints.pointRB.y > element.conrnerPoints.pointLB.y ||
            value.conrnerPoints.pointRB.y > element.conrnerPoints.pointRB.y
        ? value
        : element);
    listStandardAngle.addAll([pointL, pointR, pointT, pointB]);

    //---Step2: get key min left-top and create list key(not empty)-value(empty)------
    List<TextGroup> listKeys = listTextGroupBlocks
        .where((element) =>
            element.conrnerPoints.pointLT.x -
                    listStandardAngle.first.conrnerPoints.pointLT.x <=
                10 ||
            element.conrnerPoints.pointLB.x -
                    listStandardAngle.first.conrnerPoints.pointLT.x <=
                10)
        .toList();
    for (var element in listKeys) {
      listKeyValues.add(KeyValueFilter(keyTG: element, valueTG: []));
    }

    //---Step3: delete list key in default list-----
    List<TextGroup> listFilterValueInfors = List.from(listTextGroupBlocks);
    listFilterValueInfors.removeWhere(
        (element) => listKeys.any((el) => el.index == element.index));
    //---coppy list value & infor----
    List<TextGroup> listFilterInfors = List.from(listFilterValueInfors);

    //---Step4: add value with key----
    for (int i = 0; i < listKeyValues.length; i++) {
      KeyValueFilter key = listKeyValues.elementAt(i);
      List<TextGroup> values = getValueWithKey(key, listFilterValueInfors);
      listFilterInfors.removeWhere(
          (element) => values.any((el) => el.index == element.index));
      listKeyValues[i].valueTG = values;
    }

    //---Step5: list only information----
    //---filter list information => key-value
    List<List<TextGroup>> listKeyValueWithInfor = [];
    while (listFilterInfors.isNotEmpty) {
      List<TextGroup> listChild = [];
      listChild.add(listFilterInfors.first);
      List<TextGroup> values = getValueWithKey(
          KeyValueFilter(keyTG: listChild.first, valueTG: []),
          listFilterInfors);

      listChild.addAll(values);
      listChild.sort(
        (a, b) =>
            a.conrnerPoints.pointLT.x.compareTo(b.conrnerPoints.pointLT.x),
      );

      listFilterInfors
          .removeWhere((el) => listChild.any((el1) => el1.index == el.index));

      listKeyValueWithInfor.add(listChild);
    }
    //version 1: value & infor => key-value
    for (var element in listKeyValueWithInfor) {
      listKeyValues.add(
          KeyValueFilter(keyTG: element.first, valueTG: element.sublist(1)));
    }

    //---Step6: final scan----
    listKeyValues.sort(
      (a, b) => int.parse(a.keyTG.index).compareTo(int.parse(b.keyTG.index)),
    );
    notifyListeners();
  }

  //match key-value
  List<TextGroup> getValueWithKey(KeyValueFilter key, List<TextGroup> values) {
    return values
        .where(
            (el) => key.keyTG.index != el.index && (checkCornerValue(key, el)))
        .toList();
  }

  //check horizontal key-value
  bool checkCornerValue(KeyValueFilter key, TextGroup value) {
    List<int> keyY = [
      key.keyTG.conrnerPoints.pointLT.y,
      key.keyTG.conrnerPoints.pointRT.y,
      key.keyTG.conrnerPoints.pointRB.y,
      key.keyTG.conrnerPoints.pointLB.y
    ];
    keyY.sort(
      (a, b) => a.compareTo(b),
    );
    //---------
    List<int> valY = [
      value.conrnerPoints.pointLT.y,
      value.conrnerPoints.pointRT.y,
      value.conrnerPoints.pointRB.y,
      value.conrnerPoints.pointLB.y
    ];
    valY.sort(
      (a, b) => a.compareTo(b),
    );
    if ((keyY.first - valY.first).abs() <= 10 ||
        (keyY.first - valY.last).abs() <= 10 ||
        (keyY.last - valY.first).abs() <= 10 ||
        (keyY.last - valY.last).abs() <= 10) {
      return true;
    }
    return false;
  }

  saveDataPreference(BuildContext context) async {
    if (listKeyValues.isNotEmpty) {
      String value = await appPreference.getConfig("listbill");
      ListBillStatus listBillStatus =
          ListBillStatus(status: "", listInforBill: []);
      if (value.isNotEmpty) {
        try {
          listBillStatus = ListBillStatus.fromJson(jsonDecode(value));
        } catch (e) {
          // appPreference.clearAll();
        }
      } else {
        listBillStatus = ListBillStatus(status: "ok", listInforBill: []);
      }
      if (listBillStatus.status == "ok") {
        List<InforBill> listInforBill = listBillStatus.listInforBill;
        String pathImage = "";
        if (imageFile != null) {
          pathImage = imageFile!.path;
          Uint8List fileSaveIos = File(pathImage).readAsBytesSync();
          if (pathImage.isNotEmpty) {
            List<String> listChar = pathImage.split("/");
            pathImage = listChar.last;
            if (Platform.isIOS) {
              String pathSave = await getLocalTemporaryPath(pathImage);
              File fileSave = File(pathSave);
              if (fileSaveIos.isNotEmpty) {
                fileSave.writeAsBytes(fileSaveIos);
                List<String> listChar = fileSave.path.split("/");
                pathImage = listChar.last;
              }
            }
          } else {
            pathImage = "";
          }
        }
        listInforBill.add(
            InforBill(pathIamge: pathImage, listKeyValueFilter: listKeyValues));
        //----
        ListBillStatus newListBillStatus =
            ListBillStatus(status: "ok", listInforBill: listInforBill);
        //----
        appPreference.setConfig(
            "listbill", jsonEncode(newListBillStatus.toJson()));
      }

      //------
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => ResultScan(
                    pathIamge: /*pathImage*/ "",
                  )));
    }
  }
}

final scanProvider = ChangeNotifierProvider<ScanProvider>(
  (ref) => ScanProvider(ref),
);
