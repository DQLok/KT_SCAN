import 'package:techable/models/master_data/item_attribute_detail_attribute.dart';

class ItemAttributeDetail {
  int id;
  int itemId;
  List<ItemAttributeDetailAttribute> attributes;

  ItemAttributeDetail({
    required this.id,
    required this.itemId,
    required this.attributes,
  });

  factory ItemAttributeDetail.fromJson(Map<String, dynamic> json) =>
      ItemAttributeDetail(
        id: json["id"],
        itemId: json["itemId"],
        attributes: List<ItemAttributeDetailAttribute>.from(json["attributes"]
            .map((x) => ItemAttributeDetailAttribute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemId": itemId,
        "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
      };
}