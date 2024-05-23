import 'package:kt_scan_text/models/master_data/data_mapping_channel.dart';
import 'package:kt_scan_text/objects/text_group.dart';

class KeyValueMasterData {
  KeyValueFilter key;
  DataMappingChannel dataMappingChannel;

  KeyValueMasterData({required this.key, required this.dataMappingChannel});

  factory KeyValueMasterData.fromJson(Map<String, dynamic> json) => KeyValueMasterData(
        key: KeyValueFilter.fromJson(json["key"]),
        dataMappingChannel: DataMappingChannel.fromJson(json["dataMappingChannel"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "dataMappingChannel": dataMappingChannel,
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

    factory KeyValuesChildsMasterData.fromJson(Map<String, dynamic> json) => KeyValuesChildsMasterData(
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