import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kt_scan_text/models/master_data/master_data.dart';
import 'package:kt_scan_text/objects/text_group.dart';
import 'package:kt_scan_text/utils/dice_formula.dart';
import 'package:kt_scan_text/utils/levenshtein_formula.dart';
import 'package:kt_scan_text/utils/regex.dart';
import 'package:flutter/services.dart' show rootBundle;

class DefaultDataScan extends StatefulWidget {
  const DefaultDataScan(
      {super.key,
      required this.pathIamge,
      required this.listTextGroup,
      required this.listKeyValues,
      required this.listStandardAngle});
  final String pathIamge;
  final List<TextGroup> listTextGroup;
  final List<KeyValueFilter> listKeyValues;
  final List<TextGroup> listStandardAngle;

  @override
  State<DefaultDataScan> createState() => _DefaultDataScanState();
}

class _DefaultDataScanState extends State<DefaultDataScan> {
  File fileImge = File("");
  bool checkPathImg = false;
  //--------
  String textData = "";
  List<KeyValueFilter> listKeyValuesChild = [];
  MasterData? masterData;
  String testData = "";
  //-------
  bool showHideButton = false;
  bool checkMap = false;
  //------
  String formula = "";

  @override
  void initState() {
    super.initState();
    if (mounted) {
      checkFileinLocal();
      processText();
      readDataFromFileAssets();
    }
  }

  checkFileinLocal() {
    String path = widget.pathIamge;
    if (path.isNotEmpty) {
      fileImge = File(widget.pathIamge);
      if (fileImge.existsSync()) {
        checkPathImg = true;
      } else {
        checkPathImg = false;
      }
    } else {
      checkPathImg = false;
    }
  }

  //read file master data
  readDataFromFileAssets() async {
    textData = "";
    try {
      textData = await rootBundle.loadString("assets/masterdata.txt");
      if (textData.isNotEmpty) {
        masterData = MasterData.fromJson(jsonDecode(textData));
        if (masterData != null) {
          testData = masterData!.dataMappingChannels.first.name;
        }
      }
      setState(() {});
    } catch (e) {
      //
    }
  }

  //format data
  processText() {
    listKeyValuesChild.clear();
    listKeyValuesChild = List.from(widget.listKeyValues);
    if (listKeyValuesChild.isNotEmpty) {
      for (var element in listKeyValuesChild) {
        element.keyTG.text = removeVietnameseAccent(element.keyTG.text);
        if (element.valueTG.isNotEmpty) {
          for (var el in element.valueTG) {
            el.text = removeVietnameseAccent(el.text);
          }
        }
      }
    }
    setState(() {});
  }

  mappingData() {
    checkMap = listKeyValuesChild.any(
      (element) => masterData!.dataMappingChannels.any(
        (el) => removeVietnameseAccent(el.gf.name).contains(element.keyTG.text),
      ),
    );
    print(checkMap);
    List<String> listName = [];
    for (var element in masterData!.dataMappingChannels) {
      listName.add(removeVietnameseAccent(element.gf.name.toLowerCase()));
    }
    String key = listKeyValuesChild.elementAt(6).keyTG.text.toLowerCase();
    print("key: ${listKeyValuesChild.elementAt(6).keyTG.text.toLowerCase()}");
    print("-----Dice----");
    //--------------
    print(DiceFormula.maxRating(key, listName));
    print("-----------");
    print("-----Leven-----");
    print(LevenshteinFormula.maxRating(key, listName));
    setState(() {});
  }

  bool getMaxRating(String key, List<String> values) {
    return max(DiceFormula.maxRating(key, values),
                LevenshteinFormula.maxRating(key, values)) >
            0.5
        ? true
        : false;
  }

  showHideMasterData() {
    setState(() {
      showHideButton = !showHideButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Default Bill".toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(shrinkWrap: true, children: [
        checkPathImg
            ? Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    image: DecorationImage(image: FileImage(fileImge))),
              )
            : const Icon(
                Icons.image,
                size: 200,
              ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Kết Quả Scan:".toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Thông tin"),
              Text("Giá"),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                widget.listTextGroup.isEmpty
                    ? const SizedBox()
                    : Column(
                        children: List.generate(
                          widget.listTextGroup.length,
                          (index) => formatBlocks(
                              index,
                              widget.listTextGroup
                                  .elementAt(index)
                                  .conrnerPoints,
                              widget.listTextGroup.elementAt(index).text),
                        ),
                      ),
                widget.listStandardAngle.isEmpty
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(widget.listStandardAngle.first
                                        .toString()),
                                  ],
                                )),
                                Expanded(
                                    child: Text(widget.listStandardAngle
                                        .elementAt(1)
                                        .toString()))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Full Infor Bill".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(widget.listStandardAngle.last
                                        .toString())),
                                Expanded(
                                    child: Text(widget.listStandardAngle
                                        .elementAt(2)
                                        .toString()))
                              ],
                            )
                          ],
                        ),
                      ),
                widget.listKeyValues.isEmpty
                    ? const SizedBox()
                    : showListKeyValue(widget.listKeyValues),
                const Divider(),
                listKeyValuesChild.isEmpty
                    ? const SizedBox()
                    : showListKeyValue(listKeyValuesChild),
                const Divider(),
                ElevatedButton(
                    onPressed: () {
                      showHideMasterData();
                    },
                    child: const Text("Show Master Data")),
                showHideButton
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  readDataFromFileAssets();
                                },
                                child: const Text("Get Data")),
                            Text(textData),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          mappingData();
                        },
                        child: const Text("Check Data")),
                    Text(checkMap.toString())
                  ],
                )
              ],
            )),
      ]),
    );
  }

  Widget formatBlocks(int index, ConrnerPoints cornerPoints, String text) {
    return Row(
      children: [
        Text("$index: "),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cornerPoints.pointLT.toString()),
                    Text(cornerPoints.pointRT.toString()),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Text(text)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cornerPoints.pointLB.toString()),
                    Text(cornerPoints.pointRB.toString())
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget showListKeyValue(List<KeyValueFilter> keyValues) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: List.generate(
            keyValues.length,
            (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent)),
                          child: Text(
                            "${keyValues.elementAt(index).keyTG.index}: ${keyValues.elementAt(index).keyTG.text}",
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      ),
                      keyValues.elementAt(index).valueTG.isEmpty
                          ? const SizedBox()
                          : Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: List.generate(
                                    keyValues.elementAt(index).valueTG.length,
                                    (indexChild) => Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueAccent)),
                                          child: Text(
                                            keyValues
                                                .elementAt(index)
                                                .valueTG
                                                .elementAt(indexChild)
                                                .text,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12),
                                          ),
                                        )),
                              ),
                            ),
                    ],
                  ),
                )),
      ),
    );
  }
}
