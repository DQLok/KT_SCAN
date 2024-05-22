import 'package:kt_scan_text/models/master_data/addons.dart';
import 'package:kt_scan_text/models/master_data/enum_master_data/enum_master_data.dart';

class Gf {
  String id;
  Name name;
  int price;
  Addons addons;

  Gf({
    required this.id,
    required this.name,
    required this.price,
    required this.addons,
  });

  factory Gf.fromJson(Map<String, dynamic> json) => Gf(
        id: json["id"],
        name: nameValues.map[json["name"]]!,
        price: json["price"],
        addons: Addons.fromJson(json["addons"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "price": price,
        "addons": addons.toJson(),
      };
}