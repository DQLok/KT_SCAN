import 'dart:convert';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:techable/objects/list_bill_status.dart';
import 'package:techable/store_preference/store_preference.dart';
import 'package:techable/views/home/home.dart';
import 'package:techable/views/result_filter/widgets/camera_customer.dart';
import 'package:techable/views/result_filter/widgets/card_result_filter.dart';

class ResultFilterPage extends StatefulWidget {
  const ResultFilterPage({super.key});

  @override
  State<ResultFilterPage> createState() => _ResultFilterPageState();
}

class _ResultFilterPageState extends State<ResultFilterPage> {
  int _selectedIndex = 1;
  AppPreference appPreference = AppPreference();
  ListBillStatus listBillStatus = ListBillStatus(status: "", listInforBill: [],blocksData: "");
  bool showAndHide = true;

  @override
  void initState() {
    super.initState();
    getFullValue();
  }

  getFullValue() async {
    String value = await appPreference.getConfig("listbill");
    if (value.isNotEmpty) {
      setState(() {
        listBillStatus = ListBillStatus.fromJson(jsonDecode(value));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Danh sách Bill".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        titleTextStyle:
            const TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(
              Icons.home_rounded,
              color: Colors.white,
            )),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CameraCustomer()));
              },
              icon: const Icon(Icons.camera_alt_outlined))
        ],
      ),
      backgroundColor: Colors.white.withOpacity(.9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FlashyTabBar(
              animationCurve: Curves.linear,
              selectedIndex: _selectedIndex,
              backgroundColor: Colors.white,
              iconSize: 30,
              showElevation: false, // use this to remove appBar's elevation
              onItemSelected: (index) => changeTab(index),
              items: [
                FlashyTabBarItem(
                  icon: const Icon(Icons.list_alt),
                  title: Text('Đang đợi'.toUpperCase()),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.fact_check_outlined),
                  title: Text('Thành công'.toUpperCase()),
                ),
                FlashyTabBarItem(
                  icon: const Icon(Icons.remove_circle_outline_sharp),
                  title: Text('Thất Bại'.toUpperCase()),
                ),
              ],
            ),
            showAndHide
                ? listBillStatus.listInforBill.isEmpty
                    ? const Center(
                        child: SizedBox(
                          child: Text(
                            "Không có Bill nào!",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    : Column(
                        children: List.generate(
                            listBillStatus.listInforBill.length,
                            (index) => CardResultFilter(
                                  inforBill: listBillStatus.listInforBill
                                      .elementAt(index),
                                      blockString: listBillStatus.blocksData,
                                )),
                      )
                : const Center(
                    child: SizedBox(
                      child: Text(
                        "Không có Bill nào!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
          ],
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            setState(() {
              appPreference.clearAll();
              listBillStatus = ListBillStatus(status: "", listInforBill: [],blocksData: "");
            });
          },
          icon: const CircleAvatar(
            backgroundColor: Colors.redAccent,
            child: Icon(
              Icons.delete_forever_outlined,
              color: Colors.white,
            ),
          )),
    );
  }

  changeTab(int index) {
    setState(() {
      setState(() {
        _selectedIndex = index;
        if (index != 1) {
          showAndHide = false;
        } else {
          showAndHide = true;
        }
      });
    });
  }
}
