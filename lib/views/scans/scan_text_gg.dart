import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:techable/objects/list_bill_status.dart';
import 'package:techable/objects/text_group.dart';
import 'package:techable/store_preference/store_preference.dart';
import 'package:techable/utils/utils.dart';
import 'package:techable/views/result_filter/table_filter/table_filter.dart';
import 'package:techable/views/result_filter/widgets/result_scan.dart';
import 'package:techable/views/scans/widgets/gallery_view.dart';

class ScanTextGg extends StatefulWidget {
  const ScanTextGg({super.key, required this.xFile});
  final XFile xFile;

  @override
  State<ScanTextGg> createState() => _ScanTextGgState();
}

class _ScanTextGgState extends State<ScanTextGg> {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  String? _text;
  List<TextBlock> blocks = [];
  //--------------------------------------
  List<TextGroup> listTextGroupBlocks = [];
  List<TextGroup> listStandardAngle = [];
  List<KeyValueFilter> listKeyValues = [];
  //-------------
  AppPreference appPreference = AppPreference();
  bool showAndHide = false;
  bool showAndHidePicture = true;
  String pathImage = "";
  Uint8List? fileSaveIos;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GalleryView(
        title: "",
        text: _text,
        onImage: _processImage,
        onDetectorViewModeChanged: () {},
        blocks: showAndHide ? formatBlocks() : const SizedBox(),
        fileImage: widget.xFile,
        saveData: saveDataPreference,
        viewDetail: viewDetailScan,
        viewDetailPicture: viewDetailPicture,
        showPicture: showAndHidePicture,
        listTextGroup: listTextGroupBlocks,
        listKeyValues: listKeyValues,
        listStandardAngle: listStandardAngle,
        blocksData: blocks,
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
      clearAll();
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      // final painter = TextRecognizerPainter(
      //   recognizedText,
      //   inputImage.metadata!.size,
      //   inputImage.metadata!.rotation,
      //   _cameraLensDirection,
      // );
      // _customPaint = CustomPaint(painter: painter);
    } else {
      blocks = recognizedText.blocks;
      _text = 'Recognized text:\n\n${/*recognizedText.text*/ "---"}';
      // _customPaint = null;
      processBlocks();
      pathImage = inputImage.filePath ?? "";
      fileSaveIos = File(pathImage).readAsBytesSync();
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  clearAll() {
    blocks.clear();
    //-----------------
    listTextGroupBlocks.clear();
    listStandardAngle.clear();
    listKeyValues.clear();
    showAndHide = false;
    pathImage = "";
  }

  void processBlocks() {
    if (blocks.isNotEmpty) {
      filterBlocks();
      processOption2();
    }
  }

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

  processOption2() {
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
    //--------------------------
    //version 2(v3)
    // for (var element in listKeyValues) {
    //   List<TextGroup> listValues = listFilterValueInfors
    //       .where((el) => checkCornerValue(element, el))
    //       .toList();
    //   if (listValues.isNotEmpty) {
    //     element.valueTG.addAll(listValues);
    //   }
    //   element.valueTG.sort(
    //     (a, b) =>
    //         a.conrnerPoints.pointLT.x.compareTo(b.conrnerPoints.pointLT.x),
    //   );
    // }
    //------------------

    //---Step6: final scan----
    listKeyValues.sort(
      (a, b) => int.parse(a.keyTG.index).compareTo(int.parse(b.keyTG.index)),
    );
  }

  List<TextGroup> getValueWithKey(KeyValueFilter key, List<TextGroup> values) {
    //version 1:
    // return values
    //     .where((el) =>
    //         key.keyTG.index != el.index &&
    //         ((key.keyTG.conrnerPoints.pointRT.y - el.conrnerPoints.pointRT.y)
    //                     .abs() <
    //                 10 ||
    //             (key.keyTG.conrnerPoints.pointRB.y - el.conrnerPoints.pointRB.y)
    //                     .abs() <
    //                 10))
    //     .toList();
    //version 2:
    return values
        .where(
            (el) => key.keyTG.index != el.index && (checkCornerValue(key, el)))
        .toList();
  }

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
  //-------------------------------------------------------------------------

  //-------------
  Widget formatBlocks() {
    return Column(
      children: [
        listKeyValues.isEmpty
            ? const SizedBox()
            : Container(
                margin: const EdgeInsets.all(2),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                        listKeyValues.length,
                        (index) => SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blueAccent)),
                                    child: Text(
                                      "${listKeyValues.elementAt(index).keyTG.index}: ${listKeyValues.elementAt(index).keyTG.text}",
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  listKeyValues.elementAt(index).valueTG.isEmpty
                                      ? const SizedBox()
                                      : Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            height: 30,
                                            child: ListView.builder(
                                              itemCount: listKeyValues
                                                  .elementAt(index)
                                                  .valueTG
                                                  .length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, indexV) {
                                                TextGroup textGroup =
                                                    listKeyValues
                                                        .elementAt(index)
                                                        .valueTG
                                                        .elementAt(indexV);
                                                return textGroup.text.isEmpty
                                                    ? const SizedBox.shrink()
                                                    : Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 8),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blueAccent)),
                                                        child: Text(
                                                          textGroup.text,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 10),
                                                        ),
                                                      );
                                              },
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            )),
                  ),
                ),
              )
      ],
    );
  }

  saveDataPreference() async {
    String blocksString = processTableFormat(blocks: blocks);
    if (listKeyValues.isNotEmpty) {
      String value = await appPreference.getConfig("listbill");
      ListBillStatus listBillStatus =
          ListBillStatus(status: "", listInforBill: [],blocksData: blocksString);
      if (value.isNotEmpty) {
        try {
          listBillStatus = ListBillStatus.fromJson(jsonDecode(value));
        } catch (e) {
          // appPreference.clearAll();
        }
      } else {
        listBillStatus = ListBillStatus(status: "ok", listInforBill: [],blocksData: blocksString);
      }
      if (listBillStatus.status == "ok") {
        List<InforBill> listInforBill = listBillStatus.listInforBill;
        if (pathImage.isNotEmpty) {
          List<String> listChar = pathImage.split("/");
          pathImage = listChar.last;
          if (Platform.isIOS) {
            String pathSave = await getLocalTemporaryPath(pathImage);
            File fileSave = File(pathSave);
            if (fileSaveIos != null) {
              fileSave.writeAsBytes(fileSaveIos!);
              List<String> listChar = fileSave.path.split("/");
              pathImage = listChar.last;
            }
          }
        } else {
          pathImage = "";
        }
        listInforBill.add(
            InforBill(pathIamge: pathImage, listKeyValueFilter: listKeyValues));
        //----
        ListBillStatus newListBillStatus =
            ListBillStatus(status: "ok", listInforBill: listInforBill,blocksData: blocksString);
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
                    pathIamge: pathImage,
                  )));
    }
  }

  viewDetailScan() {
    setState(() {
      showAndHide = !showAndHide;
    });
  }

  viewDetailPicture() {
    setState(() {
      showAndHidePicture = !showAndHidePicture;
    });
  }
}
