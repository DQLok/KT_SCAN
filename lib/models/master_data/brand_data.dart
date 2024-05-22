import 'package:kt_scan_text/models/master_data/enum_master_data/enum_master_data.dart';
import 'package:kt_scan_text/models/master_data/lang_data.dart';
import 'package:kt_scan_text/models/master_data/master_data.dart';

class BrandData {
  int id;
  int? companyId;
  String name;
  String shortName;
  LangData lang;
  Status status;

  BrandData({
    required this.id,
    this.companyId,
    required this.name,
    required this.shortName,
    required this.lang,
    required this.status,
  });

  factory BrandData.fromJson(Map<String, dynamic> json) => BrandData(
        id: json["id"],
        companyId: json["companyId"],
        name: json["name"],
        shortName: json["shortName"],
        lang: LangData.fromJson(json["lang"]),
        status: statusValues.map[json["status"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "companyId": companyId,
        "name": name,
        "shortName": shortName,
        "lang": lang.toJson(),
        "status": statusValues.reverse[status],
      };
}
