import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:techable/models/master_data/master_data.dart';
import 'package:techable/objects/key_value_master_data.dart';
import 'package:techable/objects/text_group.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:techable/utils/utils.dart';

class DetailResultFilter extends StatefulWidget {
  const DetailResultFilter(
      {super.key, required this.pathIamge, required this.listKeyValues, required this.blockString});
  final String pathIamge;
  final List<KeyValueFilter> listKeyValues;
  final String blockString;

  @override
  State<DetailResultFilter> createState() => _DetailResultFilterState();
}

class _DetailResultFilterState extends State<DetailResultFilter> {
  File fileImge = File("");
  bool checkPathImg = false;
  //------
  MasterData? masterData;
  List<KeyValuesChildsMasterData> listKeyValueChildMasterData = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      checkFileinLocal();
      mappingData();
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
    String textData = "";
    try {
      textData = await rootBundle.loadString("assets/masterdata.txt");
      if (textData.isNotEmpty) {
        masterData = MasterData.fromJson(jsonDecode(textData));
      }
      setState(() {});
    } catch (e) {
      //
    }
  }

  mappingData() async {
    await readDataFromFileAssets();
    listKeyValueChildMasterData.clear();
    if (masterData == null) return;
    //Step1: get Key first(gr-name)
    masterData!.dataMappingChannels
        .where(
          (element) => widget.listKeyValues.any(
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
        //Step2: get child Key (gr-modifier-name)
        listKeyValueChildMasterData = listKeyValueChildMasterData
            .where(
              (element) => widget.listKeyValues.any(
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
              int priceData = convertPrice(
                  "${element.child.first.dataMappingChannel.gf.modifier.price}");
              int priceBill =
                  convertPrice(element.child.first.key.valueTG.last.text);
              if (priceData == 0 || priceBill == 0) {
                element.child.clear();
              } else {
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
    processPriceAfterMapping();
    setState(() {});
  }

  processPriceAfterMapping() {
    if (listKeyValueChildMasterData.isNotEmpty) {
      for (var element in listKeyValueChildMasterData) {
        //parent
        if (element.parent.key.valueTG.isNotEmpty) {
          int priceParentBill =
              convertPrice(element.parent.key.valueTG.last.text);
          int priceParentData = convertPrice(
              element.parent.dataMappingChannel.gf.price.toString());
          if (priceParentBill != -1) {
            element.parent.quantity = priceParentBill ~/ priceParentData;
            element.parent.price = element.parent.quantity! *
                element.parent.dataMappingChannel.gf.price;
          }
        }
        //child
        if (element.child.isNotEmpty) {
          for (var el in element.child) {
            if (el.key.valueTG.isNotEmpty) {
              int priceChildBill = convertPrice(el.key.valueTG.last.text);
              int priceChildData = convertPrice(
                  el.dataMappingChannel.gf.modifier.price.toString());
              if (priceChildBill != -1) {
                el.quantity = priceChildBill ~/ priceChildData;
                el.price =
                    el.quantity! * el.dataMappingChannel.gf.modifier.price;
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // double paddingV = MediaQuery.viewPaddingOf(context).vertical;
    // double paddingH = MediaQuery.viewPaddingOf(context).horizontal;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết Bill".toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        child: ListView(shrinkWrap: true, children: [
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
                  widget.listKeyValues.isEmpty
                      ? const SizedBox()
                      : Container(
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            children: List.generate(
                              widget.listKeyValues.length,
                              (index) => SizedBox(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blue.shade900)),
                                      child: Text(
                                        widget.listKeyValues
                                            .elementAt(index)
                                            .keyTG
                                            .text,
                                        style: TextStyle(fontSize: 10,
                                            color: Colors.blue.shade900),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: List.generate(
                                          widget.listKeyValues
                                              .elementAt(index)
                                              .valueTG
                                              .length,
                                          (ind) => Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.blueAccent)),
                                              child: Text(
                                                widget.listKeyValues
                                                    .elementAt(index)
                                                    .valueTG
                                                    .elementAt(ind)
                                                    .text,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                    color: Colors.blue),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              )),
          const Divider(),
          Text(widget.blockString),
          const Divider(),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Kết Quả Mapping:".toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
          Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:
                  List.generate(listKeyValueChildMasterData.length, (index) {
                KeyValuesChildsMasterData val =
                    listKeyValueChildMasterData.elementAt(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${index + 1}) ${val.parent.dataMappingChannel.gf.name}",
                          textAlign: TextAlign.start,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  val.parent.quantity.toString(),
                                ),
                                Text(val.parent.price.toString()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Column(
                          children: List.generate(val.child.length, (ind) {
                            KeyValueMasterData val1 = val.child.elementAt(ind);
                            return Row(
                              children: [
                                Text(
                                  val1.dataMappingChannel.gf.modifier.name,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(val1.quantity.toString()),
                                      Text(val1.price.toString()),
                                    ],
                                  ),
                                )
                              ],
                            );
                          }),
                        )),
                  ],
                );
              }),
            ),
          )
        ]),
      ),
    );
  }
}
