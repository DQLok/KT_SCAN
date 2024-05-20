import 'package:flutter/material.dart';
import 'package:kt_scan_text/views/qr_code/qr_code.dart';
import 'package:kt_scan_text/views/result_filter/result_filter.dart';
import 'package:kt_scan_text/views/result_filter/widgets/camera_customer.dart';

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
            style: const TextStyle(
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
                const Expanded(child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CameraCustomer()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.redAccent)),
                      child: const Text(
                        "Scan Bill",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                const Expanded(child: SizedBox())
              ],
            ),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                    flex: 2,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QRCode()));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.redAccent)),
                        child: const Text(
                          "Scan QRCode",
                          style: TextStyle(color: Colors.white),
                        ))),
                const Expanded(child: SizedBox()),
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
                              builder: (context) => const ResultFilterPage()));
                    },
                    child: const Text(
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
