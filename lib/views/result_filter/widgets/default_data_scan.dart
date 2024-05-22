import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kt_scan_text/objects/text_group.dart';

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
  String textData = "";

  @override
  void initState() {
    super.initState();
    if (mounted) {
      checkFileinLocal();
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

  readDataFromFileAssets() async {
    textData = "";
    try {
    final File file = File('.../assets/masterdata.txt');
    textData = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
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
                    : Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          children: List.generate(
                              widget.listKeyValues.length,
                              (index) => Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blueAccent)),
                                            child: Text(
                                              "${widget.listKeyValues.elementAt(index).keyTG.index}: ${widget.listKeyValues.elementAt(index).keyTG.text}",
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        widget.listKeyValues
                                                .elementAt(index)
                                                .valueTG
                                                .isEmpty
                                            ? const SizedBox()
                                            : Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: List.generate(
                                                      widget.listKeyValues
                                                          .elementAt(index)
                                                          .valueTG
                                                          .length,
                                                      (indexChild) => Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 20),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .blueAccent)),
                                                            child: Text(
                                                              widget
                                                                  .listKeyValues
                                                                  .elementAt(
                                                                      index)
                                                                  .valueTG
                                                                  .elementAt(
                                                                      indexChild)
                                                                  .text,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 12),
                                                            ),
                                                          )),
                                                ),
                                              ),
                                      ],
                                    ),
                                  )),
                        ),
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
}
