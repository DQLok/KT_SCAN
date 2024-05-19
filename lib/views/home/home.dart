import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kt_scan_text/views/qr_code/qr_code.dart';
import 'package:kt_scan_text/views/result_filter/result_filter.dart';
import 'package:kt_scan_text/views/result_filter/widgets/camera_customer.dart';
import 'package:kt_scan_text/views/result_filter/widgets/result_scan.dart';
import 'package:kt_scan_text/views/scans/scan_text_gg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KT Scan".toUpperCase(),
            style: TextStyle(
              fontSize: 30,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraCustomer()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      child: Text(
                        "Scan Bill",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Expanded(child: SizedBox())
              ],
            ),
            Row(
              children: [
                Expanded(child: SizedBox()),
                Expanded(
                    flex: 2,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QRCode()));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent)),
                        child: Text(
                          "Scan QRCode",
                          style: TextStyle(color: Colors.white),
                        ))),
                Expanded(child: SizedBox()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultFilterPage()));
                    },
                    child: Text(
                      "Danh sách bill của bạn",
                      style: TextStyle(color: Colors.redAccent),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
