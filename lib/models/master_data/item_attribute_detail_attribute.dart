import 'package:teca/models/master_data/option_data.dart';

class ItemAttributeDetailAttribute {
  int id;
  String name;
  int numering;
  bool isPreSelected;
  List<OptionData> options;

  ItemAttributeDetailAttribute({
    required this.id,
    required this.name,
    required this.numering,
    required this.isPreSelected,
    required this.options,
  });

  factory ItemAttributeDetailAttribute.fromJson(Map<String, dynamic> json) =>
      ItemAttributeDetailAttribute(
        id: json["id"],
        name: json["name"],
        numering: json["numering"],
        isPreSelected: json["isPreSelected"],
        options:
            List<OptionData>.from(json["options"].map((x) => OptionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "numering": numering,
        "isPreSelected": isPreSelected,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}