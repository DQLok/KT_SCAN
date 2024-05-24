import 'package:kt_scan_text/models/master_data/modifier.dart';

class Gf {
  String id;
  String name;
  int price;
  Modifier modifier;

  Gf({
    required this.id,
    required this.name,
    required this.price,
    required this.modifier,
  });

  factory Gf.fromJson(Map<String, dynamic> json) => Gf(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        modifier: Modifier.fromJson(json["modifier"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "modifier": modifier.toJson(),
      };
}
