import 'package:kt_scan_text/models/master_data/enum_master_data/enum_master_data.dart';
import 'package:kt_scan_text/models/master_data/lang_data.dart';
import 'package:kt_scan_text/models/master_data/master_data.dart';

class MasterDataAttributeOption {
  int id;
  int attributeId;
  String name;
  String shortName;
  LangData lang;
  int numering;
  Status status;

  MasterDataAttributeOption({
    required this.id,
    required this.attributeId,
    required this.name,
    required this.shortName,
    required this.lang,
    required this.numering,
    required this.status,
  });

  factory MasterDataAttributeOption.fromJson(Map<String, dynamic> json) =>
      MasterDataAttributeOption(
        id: json["id"],
        attributeId: json["attributeId"],
        name: json["name"],
        shortName: json["shortName"],
        lang: LangData.fromJson(json["lang"]),
        numering: json["numering"],
        status: statusValues.map[json["status"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributeId": attributeId,
        "name": name,
        "shortName": shortName,
        "lang": lang.toJson(),
        "numering": numering,
        "status": statusValues.reverse[status],
      };
}