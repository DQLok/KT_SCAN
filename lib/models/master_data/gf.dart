import 'package:kt_scan_text/models/master_data/addons.dart';

class Gf {
  String id;
  String name;
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
        name: json["name"],
        price: json["price"],
        addons: Addons.fromJson(json["addons"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "addons": addons.toJson(),
      };
}
