import 'package:techable/models/master_data/lang_data.dart';

class ItemData {
  int brandId;
  int id;
  int caregoryId;
  String name;
  String type;
  String mType;
  int numering;
  LangData lang;
  String status;
  bool isAttribute;

  ItemData({
    required this.brandId,
    required this.id,
    required this.caregoryId,
    required this.name,
    required this.type,
    required this.mType,
    required this.numering,
    required this.lang,
    required this.status,
    required this.isAttribute,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
        brandId: json["brandId"],
        id: json["id"],
        caregoryId: json["caregoryId"],
        name: json["name"],
        type: json["type"],
        mType: json["mType"],
        numering: json["numering"],
        lang: LangData.fromJson(json["lang"]),
        status: json["status"],
        isAttribute: json["isAttribute"],
      );

  Map<String, dynamic> toJson() => {
        "brandId": brandId,
        "id": id,
        "caregoryId": caregoryId,
        "name": name,
        "type": type,
        "mType": mType,
        "numering": numering,
        "lang": lang.toJson(),
        "status": status,
        "isAttribute": isAttribute,
      };
}
