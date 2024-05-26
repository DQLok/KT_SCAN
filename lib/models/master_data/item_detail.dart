import 'package:techable/models/master_data/detail_data.dart';

class ItemDetail {
  int id;
  int itemId;
  String name;
  String code;
  String posCode;
  String erpCode;
  int price;
  DetailsData? details;

  ItemDetail({
    required this.id,
    required this.itemId,
    required this.name,
    required this.code,
    required this.posCode,
    required this.erpCode,
    required this.price,
    required this.details,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        id: json["id"],
        itemId: json["itemId"],
        name: json["name"],
        code: json["code"],
        posCode: json["posCode"],
        erpCode: json["erpCode"],
        price: json["price"],
        details:
            json["details"] == null ? null : DetailsData.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemId": itemId,
        "name": name,
        "code": code,
        "posCode": posCode,
        "erpCode": erpCode,
        "price": price,
        "details": details?.toJson(),
      };
}