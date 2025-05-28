import 'package:techable/objects/text_group.dart';

class ListBillStatus {
  String status;
  List<InforBill> listInforBill;
  String blocksData;

  ListBillStatus({required this.status, required this.listInforBill, required this.blocksData});

  factory ListBillStatus.fromJson(Map<String, dynamic> json) => ListBillStatus(
        status: json["status"] ?? "",
        listInforBill: List<InforBill>.from(
            json["listInforBill"].map((x) => InforBill.fromJson(x))),
        blocksData: json["blocksData"] ?? ""
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "listInforBill":
            List<dynamic>.from(listInforBill.map((x) => x.toJson())),
        "blocksData": blocksData
      };
}

class InforBill {
  String pathIamge;
  List<KeyValueFilter> listKeyValueFilter;

  InforBill({required this.pathIamge, required this.listKeyValueFilter});

  factory InforBill.fromJson(Map<String, dynamic> json) => InforBill(
        pathIamge: json["pathIamge"],
        listKeyValueFilter: List<KeyValueFilter>.from(
            json["listKeyValueFilter"].map((x) => KeyValueFilter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pathIamge": pathIamge,
        "listKeyValueFilter":
            List<dynamic>.from(listKeyValueFilter.map((x) => x.toJson())),
      };
}
