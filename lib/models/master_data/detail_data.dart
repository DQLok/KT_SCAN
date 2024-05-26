import 'package:techable/models/master_data/details_attribute_option.dart';

class DetailsData {
  List<DetailsAttributeOption> attributeOptions;
  bool isDefault;

  DetailsData({
    required this.attributeOptions,
    required this.isDefault,
  });

  factory DetailsData.fromJson(Map<String, dynamic> json) => DetailsData(
        attributeOptions: List<DetailsAttributeOption>.from(
            json["attributeOptions"]
                .map((x) => DetailsAttributeOption.fromJson(x))),
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "attributeOptions":
            List<dynamic>.from(attributeOptions.map((x) => x.toJson())),
        "isDefault": isDefault,
      };
}