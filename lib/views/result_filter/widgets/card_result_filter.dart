import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kt_scan_text/objects/list_bill_status.dart';
import 'package:kt_scan_text/utils/utils.dart';
import 'package:kt_scan_text/views/result_filter/widgets/detail_result_filter.dart';

class CardResultFilter extends StatefulWidget {
  const CardResultFilter({super.key, required this.inforBill});
  final InforBill inforBill;

  @override
  State<CardResultFilter> createState() => _CardResultFilterState();
}

class _CardResultFilterState extends State<CardResultFilter> {
  File fileImge = File("");
  bool checkPathImg = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      checkFileinLocal();
    }
  }

  checkFileinLocal() async {
    String path = widget.inforBill.pathIamge;
    if (path.isNotEmpty) {
      path = await getLocalPathCache(path);
      fileImge = File(path);
      if (fileImge.existsSync()) {
        checkPathImg = true;
      } else {
        checkPathImg = false;
      }
    } else {
      checkPathImg = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailResultFilter(
                      pathIamge: fileImge.path,
                      listKeyValues: widget.inforBill.listKeyValueFilter,
                    )));
      },
      child: Card(
        elevation: .9,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: List.generate(
                          widget.inforBill.listKeyValueFilter.length > 5
                              ? 5
                              : widget.inforBill.listKeyValueFilter.length,
                          (index) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.inforBill.listKeyValueFilter
                                        .elementAt(index)
                                        .keyTG
                                        .text,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )),
                    ),
                  ),
                  checkPathImg
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(image: FileImage(fileImge))),
                        )
                      : const IntrinsicWidth(
                          child: Icon(Icons.photo_size_select_actual_rounded)),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Nhấn để xem chi tiết ->",
                    style: TextStyle(color: Colors.redAccent, fontSize: 10),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
