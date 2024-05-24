import 'package:teca/models/master_data/data_mapping_channel.dart';
import 'package:teca/objects/text_group.dart';

class KeyValueMasterData {
  KeyValueFilter key;
  DataMappingChannel dataMappingChannel;
  int? quantity;
  int? price;

  KeyValueMasterData(
      {required this.key,
      required this.dataMappingChannel,
      this.quantity = 0,
      this.price = 0});

  factory KeyValueMasterData.fromJson(Map<String, dynamic> json) =>
      KeyValueMasterData(
          key: KeyValueFilter.fromJson(json["key"]),
          dataMappingChannel:
              DataMappingChannel.fromJson(json["dataMappingChannel"]),
          quantity: json["quantity"],
          price: json["price"]);

  Map<String, dynamic> toJson() => {
        "key": key,
        "dataMappingChannel": dataMappingChannel,
        "quantity": quantity,
        "price": price
      };

  @override
  String toString() {
    return "${key.keyTG.toString()}: ${dataMappingChannel.toString()}";
  }
}

class KeyValuesChildsMasterData {
  KeyValueMasterData parent;
  List<KeyValueMasterData> child;

  KeyValuesChildsMasterData({required this.parent, required this.child});

  factory KeyValuesChildsMasterData.fromJson(Map<String, dynamic> json) =>
      KeyValuesChildsMasterData(
        parent: KeyValueMasterData.fromJson(json["parent"]),
        child: List<KeyValueMasterData>.from(
            json["child"].map((x) => KeyValueMasterData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "parent": parent,
        "child": List<dynamic>.from(child.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return "${parent.toString()}: ${child.toString()}";
  }
}
