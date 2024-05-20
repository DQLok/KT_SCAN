import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
        title: const Text("Scan QRCode"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
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
                const SizedBox(
                  child: Text(
                    "Tính năng đang phát triển!!!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  child: resultQr.isEmpty? const SizedBox(): Text(
                    "Kết quả: $resultQr",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(onPressed: (){
                  setState(() {
                    isScanComplete = false;
                    resultQr = "";
                  });
                }, child: const Text("Reset"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
