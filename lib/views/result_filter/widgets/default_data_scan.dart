import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:techable/models/master_data/master_data.dart';
import 'package:techable/objects/key_value_master_data.dart';
import 'package:techable/objects/text_group.dart';
import 'package:techable/utils/dice_formula.dart';
import 'package:techable/utils/levenshtein_formula.dart';
import 'package:techable/utils/regex.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:techable/utils/utils.dart';

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
  //------
  List<KeyValuesChildsMasterData> listKeyValueChildMasterData = [];

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
    listKeyValueChildMasterData.clear();
    //Step1: get Key first(gr-name)
    masterData!.dataMappingChannels
        .where(
          (element) => listKeyValuesChild.any(
            (el) {
              bool check = comapreTwoStringCus(element.gf.name, el.keyTG.text);
              if (comapreTwoStringCus(element.gf.name, el.keyTG.text)) {
                listKeyValueChildMasterData.add(KeyValuesChildsMasterData(
                    parent: KeyValueMasterData(
                        key: el, dataMappingChannel: element),
                    child: []));
              }
              return check;
            },
          ),
        )
        .toList();
    if (listKeyValueChildMasterData.isNotEmpty) {
      if (listKeyValueChildMasterData.any(
        (element) =>
            element.parent.dataMappingChannel.gf.modifier.name.isNotEmpty,
      )) {
        //Step2: get child Key (gr-addons-name)
        listKeyValueChildMasterData = listKeyValueChildMasterData
            .where(
              (element) => listKeyValuesChild.any(
                (el) {
                  bool check = comapreTwoStringCus(
                      element.parent.dataMappingChannel.gf.modifier.name,
                      el.keyTG.text);
                  if (check) {
                    element.child.add(KeyValueMasterData(
                        key: el,
                        dataMappingChannel: element.parent.dataMappingChannel));
                  }
                  return check;
                },
              ),
            )
            .toList();
        //Step3: get child Key (gr-modifier-name) with child >1
        if (listKeyValueChildMasterData.isNotEmpty &&
            listKeyValueChildMasterData.length > 1) {
          for (var element in listKeyValueChildMasterData) {
            if (element.child.isNotEmpty) {
              int priceData = int.parse(removeChartGetOnlyNumber(
                  "${element.child.first.dataMappingChannel.gf.modifier.price}"));
              int priceBill = int.parse(removeChartGetOnlyNumber(
                  element.child.first.key.valueTG.last.text));
              if (priceData == 0 || priceBill == 0) {
                element.child.clear();
              } else {
                // int numberDiv = priceBill ~/ priceData;
                int numberMod = priceBill % priceData;
                if (numberMod != 0) {
                  element.child.clear();
                }
              }
            }
          }
          //Step4: get final child
          listKeyValueChildMasterData.removeWhere(
            (element) => element.child.isEmpty,
          );
        }
      } else {}
    } else {}
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
                ),
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
                  width: double.infinity,
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
                                color: Colors.blue, fontSize: 10),
                          ),
                        ),
                      ),
                      keyValues.elementAt(index).valueTG.isEmpty
                          ? const SizedBox()
                          : Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  itemCount:
                                      keyValues.elementAt(index).valueTG.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, indexV) {
                                    TextGroup textGroup = keyValues
                                        .elementAt(index)
                                        .valueTG
                                        .elementAt(indexV);
                                    return textGroup.text.isEmpty
                                        ? const SizedBox.shrink()
                                        : Container(
                                            margin:
                                                const EdgeInsets.only(left: 8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blueAccent)),
                                            child: Text(
                                              textGroup.text,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 10),
                                            ),
                                          );
                                  },
                                ),
                              )
                              //  Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children:
                              //   List.generate(
                              //       keyValues.elementAt(index).valueTG.length,
                              //       (indexChild) => Container(
                              //             margin:
                              //                 const EdgeInsets.only(left: 8),
                              //             decoration: BoxDecoration(
                              //                 border: Border.all(
                              //                     color: Colors.blueAccent)),
                              //             child: Text(
                              //               keyValues
                              //                   .elementAt(index)
                              //                   .valueTG
                              //                   .elementAt(indexChild)
                              //                   .text,
                              //               overflow: TextOverflow.ellipsis,
                              //               style: const TextStyle(
                              //                   color: Colors.blue,
                              //                   fontSize: 10),
                              //             ),
                              //           )),
                              // ),
                              ),
                    ],
                  ),
                )),
      ),
    );
  }
}
