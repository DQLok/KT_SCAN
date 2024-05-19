import 'dart:convert';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:kt_scan_text/objects/list_bill_status.dart';
import 'package:kt_scan_text/store_preference/store_preference.dart';
import 'package:kt_scan_text/views/home/home.dart';
import 'package:kt_scan_text/views/result_filter/widgets/camera_customer.dart';
import 'package:kt_scan_text/views/result_filter/widgets/card_result_filter.dart';

class ResultFilterPage extends StatefulWidget {
  const ResultFilterPage({super.key});

  @override
  State<ResultFilterPage> createState() => _ResultFilterPageState();
}

class _ResultFilterPageState extends State<ResultFilterPage> {
  int _selectedIndex = 1;
  AppPreference appPreference = AppPreference();
  ListBillStatus listBillStatus = ListBillStatus(status: "", listInforBill: []);
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
        title: Text("Danh sách Bill".toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        titleTextStyle: TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: Icon(
              Icons.home_rounded,
              color: Colors.white,
            )),
        actionsIconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CameraCustomer()));
              },
              icon: Icon(Icons.camera_alt_outlined))
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
                  icon: Icon(Icons.list_alt),
                  title: Text('Đang đợi'),
                ),
                FlashyTabBarItem(
                  icon: Icon(Icons.fact_check_outlined),
                  title: Text('Thành công'),
                ),
                FlashyTabBarItem(
                  icon: Icon(Icons.remove_circle_outline_sharp),
                  title: Text('Thất Bại'),
                ),
              ],
            ),
            showAndHide
                ? listBillStatus.listInforBill.isEmpty
                    ? Center(
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
                                )),
                      )
                : Center(
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
              listBillStatus = ListBillStatus(status: "", listInforBill: []);
            });
          },
          icon: Icon(
            Icons.delete_forever_outlined,
            color: Colors.black,
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
