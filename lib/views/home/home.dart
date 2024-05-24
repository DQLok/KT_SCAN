import 'package:flutter/material.dart';
import 'package:teca/views/qr_code/qr_code.dart';
import 'package:teca/views/result_filter/result_filter.dart';
import 'package:teca/views/result_filter/widgets/camera_customer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset("assets/logo/logo.jpg"))),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                                    builder: (context) =>
                                        const CameraCustomer()));
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
                                  builder: (context) =>
                                      const ResultFilterPage()));
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
        ],
      ),
    );
  }
}
