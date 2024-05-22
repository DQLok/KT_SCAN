import 'package:kt_scan_text/models/master_data/gf.dart';
import 'package:kt_scan_text/models/master_data/spf.dart';

class DataMappingChannel {
  int id;
  String name;
  Gf gf;
  Spf spf;
  String posCode;
  int price;

  DataMappingChannel({
    required this.id,
    required this.name,
    required this.gf,
    required this.spf,
    required this.posCode,
    required this.price,
  });

  factory DataMappingChannel.fromJson(Map<String, dynamic> json) =>
      DataMappingChannel(
        id: json["id"],
        name: json["name"],
        gf: Gf.fromJson(json["gf"]),
        spf: Spf.fromJson(json["spf"]),
        posCode: json["posCode"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gf": gf.toJson(),
        "spf": spf.toJson(),
        "posCode": posCode,
        "price": price,
      };
}