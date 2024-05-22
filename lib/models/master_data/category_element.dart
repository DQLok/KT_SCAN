import 'package:kt_scan_text/models/master_data/enum_master_data/enum_master_data.dart';
import 'package:kt_scan_text/models/master_data/lang_data.dart';
import 'package:kt_scan_text/models/master_data/master_data.dart';

class CategoryElement {
  int brandId;
  int id;
  String name;
  LangData lang;
  int numering;
  Status status;
  int? parent;
  int? depth;
  String? objectRef;
  String? objectIds;

  CategoryElement({
    required this.brandId,
    required this.id,
    required this.name,
    required this.lang,
    required this.numering,
    required this.status,
    this.parent,
    this.depth,
    this.objectRef,
    this.objectIds,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) =>
      CategoryElement(
        brandId: json["brandId"],
        id: json["id"],
        name: json["name"],
        lang: LangData.fromJson(json["lang"]),
        numering: json["numering"],
        status: statusValues.map[json["status"]]!,
        parent: json["parent"],
        depth: json["depth"],
        objectRef: json["objectRef"],
        objectIds: json["objectIds"],
      );

  Map<String, dynamic> toJson() => {
        "brandId": brandId,
        "id": id,
        "name": name,
        "lang": lang.toJson(),
        "numering": numering,
        "status": statusValues.reverse[status],
        "parent": parent,
        "depth": depth,
        "objectRef": objectRef,
        "objectIds": objectIds,
      };
}