import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kt_scan_text/objects/text_group.dart';

class DetailResultFilter extends StatefulWidget {
  const DetailResultFilter(
      {super.key, required this.pathIamge, required this.listKeyValues});
  final String pathIamge;
  final List<KeyValueFilter> listKeyValues;

  @override
  State<DetailResultFilter> createState() => _DetailResultFilterState();
}

class _DetailResultFilterState extends State<DetailResultFilter> {
  File fileImge = File("");
  bool checkPathImg = false;

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
                widget.listKeyValues.isEmpty
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          children: List.generate(
                            widget.listKeyValues.length,
                            (index) => SizedBox(
                              height: 100,
                              child: ListView.builder(
                                itemCount: 1 +
                                    widget.listKeyValues
                                        .elementAt(index)
                                        .valueTG
                                        .length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, indexx) {
                                  List<TextGroup> listChild = [
                                    widget.listKeyValues.elementAt(index).keyTG,
                                    ...widget.listKeyValues
                                        .elementAt(index)
                                        .valueTG
                                  ];
                                  return IntrinsicWidth(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, right: 20, bottom: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueAccent)),
                                          child: Text(
                                            listChild.elementAt(indexx).text,
                                            style: const TextStyle(
                                                color: Colors.blue),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons
                                                .lightbulb_outline_rounded))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         IntrinsicWidth(
                            //           child: Container(
                            //             decoration: BoxDecoration(
                            //                 border: Border.all(
                            //                     color: Colors.blueAccent)),
                            //             child: Text(
                            //               widget.listKeyValues
                            //                   .elementAt(index)
                            //                   .keyTG
                            //                   .text,
                            //               style: const TextStyle(
                            //                   color: Colors.blue),
                            //             ),
                            //           ),
                            //         ),
                            //         widget.listKeyValues
                            //                 .elementAt(index)
                            //                 .valueTG
                            //                 .isEmpty
                            //             ? const SizedBox()
                            //             : Expanded(
                            //                 flex: 1,
                            //                 child: Row(
                            //                   mainAxisAlignment:
                            //                       MainAxisAlignment.end,
                            //                   children: List.generate(
                            //                       widget.listKeyValues
                            //                           .elementAt(index)
                            //                           .valueTG
                            //                           .length,
                            //                       (indexChild) => Container(
                            //                             margin:
                            //                                 const EdgeInsets
                            //                                     .only(
                            //                                     left: 20),
                            //                             decoration: BoxDecoration(
                            //                                 border: Border.all(
                            //                                     color: Colors
                            //                                         .blueAccent)),
                            //                             child: Text(
                            //                               widget.listKeyValues
                            //                                   .elementAt(
                            //                                       index)
                            //                                   .valueTG
                            //                                   .elementAt(
                            //                                       indexChild)
                            //                                   .text,
                            //                               style:
                            //                                   const TextStyle(
                            //                                       color: Colors
                            //                                           .blue),
                            //                             ),
                            //                           )),
                            //                 ),
                            //               ),
                            //       ],
                            //     )
                          ),
                        ),
                      )
              ],
            )),
      ]),
    );
  }
}
