import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techable/configs/provider/scan_provider.dart';
import 'package:techable/constants/dimension_app.dart';
import 'package:techable/constants/static_app.dart';
import 'package:techable/views/result_filter/widgets/camera_customer.dart';
import 'package:techable/views/result_filter/widgets/default_data_scan.dart';
import 'package:techable/views/scans/widgets/format_blocks.dart';

class ScanTextPage extends ConsumerWidget {
  const ScanTextPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanPro = ref.watch(scanProvider);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: paddingScreen(context, StaticApp.vertical),
            horizontal: paddingScreen(context, StaticApp.horizontal)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                            alignment: Alignment.topLeft,
                            onPressed: () {
                              scanPro.getPicture(context, ImageSource.camera);
                            },
                            icon: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ))),
                      ),
                      const Expanded(
                        child: Text(
                          "Bill xử lý",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Expanded(child: SizedBox())
                    ],
                  ),
                  scanPro.imageFile != null
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.amber),
                                    image: DecorationImage(
                                        image: FileImage(File(scanPro.imageFile!.path)),
                                        fit: BoxFit.fill)),
                                height:
                                    MediaQuery.of(context).size.height / 1.8,
                                width: MediaQuery.of(context).size.width / 1.3,
                                alignment: Alignment.center,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    scanPro.blocks.isEmpty
                                        ? const SizedBox()
                                        : const FormatBlocks()
                                  ],
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    scanPro.viewDetailScan();
                                  },
                                  child: const Text(
                                    "Xem thông tin tạm thời",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DefaultDataScan(
                                                  pathIamge: scanPro.imageFile != null
                                                      ? scanPro.imageFile!.path
                                                      : "",
                                                  listTextGroup:
                                                      scanPro.listTextGroupBlocks,
                                                  listKeyValues:
                                                      scanPro.listKeyValues,
                                                  listStandardAngle:
                                                      scanPro.listStandardAngle,
                                                )));
                                  },
                                  child: const Text(
                                    "default",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic),
                                  ))
                            ],
                          ),
                        )
                      : const Icon(
                          Icons.image,
                          size: 200,
                        )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 2,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CameraCustomer()));
                        },
                        child: const Text(
                          "Trở về Camera",
                          style: TextStyle(
                              color: Colors.black, fontStyle: FontStyle.normal),
                        ))),
                const Expanded(child: SizedBox()),
                Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        scanPro.saveDataPreference(context);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.redAccent)),
                      child: const Text(
                        "Hoàn thành",
                        style: TextStyle(
                            color: Colors.white, fontStyle: FontStyle.normal),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
