import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';

class QRCode extends StatefulWidget {
  const QRCode({super.key});

  @override
  State<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  bool isScanComplete = false;
  MobileScannerController controller = MobileScannerController();
  String resultQr = "";

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
    isScanComplete= false;
    resultQr = "";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QRCode"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width / 1.2,
            child: MobileScanner(
              controller: controller,
              onDetect: (barcodes) {
                if (!isScanComplete) {
                  List<dynamic> listChild = [];
                  bool check = false;
                  if ( barcodes.raw != null) {
                    listChild= barcodes.raw as List;
                    check = true;
                  } else {
                    check = false;
                  }
                  
                  resultQr = check ? listChild.first["rawValue"]: "";
                  isScanComplete = true;
                  
                } else{
                  isScanComplete = false;
                }
                setState(() {
                    
                  });
              },
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  child: Text(
                    "Tính năng đang phát triển!!!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  child: resultQr.isEmpty? SizedBox(): Text(
                    "Kết quả: $resultQr",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(onPressed: (){
                  setState(() {
                    isScanComplete = false;
                    resultQr = "";
                  });
                }, child: Text("Reset"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
