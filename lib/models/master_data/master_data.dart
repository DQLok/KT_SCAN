// To parse this JSON data, do
//
//     final masterData = masterDataFromJson(jsonString);

import 'dart:convert';

import 'package:kt_scan_text/models/master_data/attribute_option.dart';
import 'package:kt_scan_text/models/master_data/brand_data.dart';
import 'package:kt_scan_text/models/master_data/category_element.dart';
import 'package:kt_scan_text/models/master_data/data_mapping_channel.dart';
import 'package:kt_scan_text/models/master_data/item_attribute_detail.dart';
import 'package:kt_scan_text/models/master_data/item_data.dart';
import 'package:kt_scan_text/models/master_data/item_detail.dart';

MasterData masterDataFromJson(String str) =>
    MasterData.fromJson(json.decode(str));

String masterDataToJson(MasterData data) => json.encode(data.toJson());

class MasterData {
  List<BrandData> companies;
  List<BrandData> brands;
  List<CategoryElement> attributes;
  List<MasterDataAttributeOption> attributeOptions;
  List<CategoryElement> menus;
  List<CategoryElement> categories;
  List<ItemData> items;
  List<ItemDetail> itemDetails;
  List<ItemAttributeDetail> itemAttributeDetails;
  List<DataMappingChannel> dataMappingChannels;

  MasterData({
    required this.companies,
    required this.brands,
    required this.attributes,
    required this.attributeOptions,
    required this.menus,
    required this.categories,
    required this.items,
    required this.itemDetails,
    required this.itemAttributeDetails,
    required this.dataMappingChannels,
  });

  factory MasterData.fromJson(Map<String, dynamic> json) => MasterData(
        companies: List<BrandData>.from(
            json["companies"].map((x) => BrandData.fromJson(x))),
        brands: List<BrandData>.from(
            json["brands"].map((x) => BrandData.fromJson(x))),
        attributes: List<CategoryElement>.from(
            json["attributes"].map((x) => CategoryElement.fromJson(x))),
        attributeOptions: List<MasterDataAttributeOption>.from(
            json["attributeOptions"]
                .map((x) => MasterDataAttributeOption.fromJson(x))),
        menus: List<CategoryElement>.from(
            json["menus"].map((x) => CategoryElement.fromJson(x))),
        categories: List<CategoryElement>.from(
            json["categories"].map((x) => CategoryElement.fromJson(x))),
        items:
            List<ItemData>.from(json["items"].map((x) => ItemData.fromJson(x))),
        itemDetails: List<ItemDetail>.from(
            json["itemDetails"].map((x) => ItemDetail.fromJson(x))),
        itemAttributeDetails: List<ItemAttributeDetail>.from(
            json["itemAttributeDetails"]
                .map((x) => ItemAttributeDetail.fromJson(x))),
        dataMappingChannels: List<DataMappingChannel>.from(
            json["dataMappingChannels"]
                .map((x) => DataMappingChannel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "companies": List<dynamic>.from(companies.map((x) => x.toJson())),
        "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
        "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
        "attributeOptions":
            List<dynamic>.from(attributeOptions.map((x) => x.toJson())),
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "itemDetails": List<dynamic>.from(itemDetails.map((x) => x.toJson())),
        "itemAttributeDetails":
            List<dynamic>.from(itemAttributeDetails.map((x) => x.toJson())),
        "dataMappingChannels":
            List<dynamic>.from(dataMappingChannels.map((x) => x.toJson())),
      };
}

// class MasterDataAttributeOption {
//   int id;
//   int attributeId;
//   String name;
//   String shortName;
//   Lang lang;
//   int numering;
//   Status status;

//   MasterDataAttributeOption({
//     required this.id,
//     required this.attributeId,
//     required this.name,
//     required this.shortName,
//     required this.lang,
//     required this.numering,
//     required this.status,
//   });

//   factory MasterDataAttributeOption.fromJson(Map<String, dynamic> json) =>
//       MasterDataAttributeOption(
//         id: json["id"],
//         attributeId: json["attributeId"],
//         name: json["name"],
//         shortName: json["shortName"],
//         lang: Lang.fromJson(json["lang"]),
//         numering: json["numering"],
//         status: statusValues.map[json["status"]]!,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "attributeId": attributeId,
//         "name": name,
//         "shortName": shortName,
//         "lang": lang.toJson(),
//         "numering": numering,
//         "status": statusValues.reverse[status],
//       };
// }

// class Lang {
//   String vn;
//   String en;

//   Lang({
//     required this.vn,
//     required this.en,
//   });

//   factory Lang.fromJson(Map<String, dynamic> json) => Lang(
//         vn: json["vn"],
//         en: json["en"],
//       );

//   Map<String, dynamic> toJson() => {
//         "vn": vn,
//         "en": en,
//       };
// }

// enum Status { ACTIVE }

// final statusValues = EnumValues({"active": Status.ACTIVE});

// class CategoryElement {
//   int brandId;
//   int id;
//   String name;
//   LangData lang;
//   int numering;
//   Status status;
//   int? parent;
//   int? depth;
//   String? objectRef;
//   String? objectIds;

//   CategoryElement({
//     required this.brandId,
//     required this.id,
//     required this.name,
//     required this.lang,
//     required this.numering,
//     required this.status,
//     this.parent,
//     this.depth,
//     this.objectRef,
//     this.objectIds,
//   });

//   factory CategoryElement.fromJson(Map<String, dynamic> json) =>
//       CategoryElement(
//         brandId: json["brandId"],
//         id: json["id"],
//         name: json["name"],
//         lang: LangData.fromJson(json["lang"]),
//         numering: json["numering"],
//         status: statusValues.map[json["status"]]!,
//         parent: json["parent"],
//         depth: json["depth"],
//         objectRef: json["objectRef"],
//         objectIds: json["objectIds"],
//       );

//   Map<String, dynamic> toJson() => {
//         "brandId": brandId,
//         "id": id,
//         "name": name,
//         "lang": lang.toJson(),
//         "numering": numering,
//         "status": statusValues.reverse[status],
//         "parent": parent,
//         "depth": depth,
//         "objectRef": objectRef,
//         "objectIds": objectIds,
//       };
// }

// class Brand {
//   int id;
//   int? companyId;
//   String name;
//   String shortName;
//   LangData lang;
//   Status status;

//   Brand({
//     required this.id,
//     this.companyId,
//     required this.name,
//     required this.shortName,
//     required this.lang,
//     required this.status,
//   });

//   factory Brand.fromJson(Map<String, dynamic> json) => Brand(
//         id: json["id"],
//         companyId: json["companyId"],
//         name: json["name"],
//         shortName: json["shortName"],
//         lang: LangData.fromJson(json["lang"]),
//         status: statusValues.map[json["status"]]!,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "companyId": companyId,
//         "name": name,
//         "shortName": shortName,
//         "lang": lang.toJson(),
//         "status": statusValues.reverse[status],
//       };
// }

// class DataMappingChannel {
//   int id;
//   String name;
//   Gf gf;
//   Spf spf;
//   String posCode;
//   int price;

//   DataMappingChannel({
//     required this.id,
//     required this.name,
//     required this.gf,
//     required this.spf,
//     required this.posCode,
//     required this.price,
//   });

//   factory DataMappingChannel.fromJson(Map<String, dynamic> json) =>
//       DataMappingChannel(
//         id: json["id"],
//         name: json["name"],
//         gf: Gf.fromJson(json["gf"]),
//         spf: Spf.fromJson(json["spf"]),
//         posCode: json["posCode"],
//         price: json["price"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "gf": gf.toJson(),
//         "spf": spf.toJson(),
//         "posCode": posCode,
//         "price": price,
//       };
// }

// class Gf {
//   String id;
//   Name name;
//   int price;
//   Addons addons;

//   Gf({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.addons,
//   });

//   factory Gf.fromJson(Map<String, dynamic> json) => Gf(
//         id: json["id"],
//         name: nameValues.map[json["name"]]!,
//         price: json["price"],
//         addons: Addons.fromJson(json["addons"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": nameValues.reverse[name],
//         "price": price,
//         "addons": addons.toJson(),
//       };
// }

// class Addons {
//   String name;
//   int price;

//   Addons({
//     required this.name,
//     required this.price,
//   });

//   factory Addons.fromJson(Map<String, dynamic> json) => Addons(
//         name: json["name"],
//         price: json["price"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "price": price,
//       };
// }

// enum Name { PIZZA_HI_SN_PESTO_XANH, PIZZA_PH_MAI }

// final nameValues = EnumValues({
//   "Pizza Hải Sản Pesto Xanh": Name.PIZZA_HI_SN_PESTO_XANH,
//   "Pizza Phô Mai": Name.PIZZA_PH_MAI
// });

// class Spf {
//   Spf();

//   factory Spf.fromJson(Map<String, dynamic> json) => Spf();

//   Map<String, dynamic> toJson() => {};
// }

// class ItemAttributeDetail {
//   int id;
//   int itemId;
//   List<ItemAttributeDetailAttribute> attributes;

//   ItemAttributeDetail({
//     required this.id,
//     required this.itemId,
//     required this.attributes,
//   });

//   factory ItemAttributeDetail.fromJson(Map<String, dynamic> json) =>
//       ItemAttributeDetail(
//         id: json["id"],
//         itemId: json["itemId"],
//         attributes: List<ItemAttributeDetailAttribute>.from(json["attributes"]
//             .map((x) => ItemAttributeDetailAttribute.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "itemId": itemId,
//         "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
//       };
// }

// class ItemAttributeDetailAttribute {
//   int id;
//   String name;
//   int numering;
//   bool isPreSelected;
//   List<Option> options;

//   ItemAttributeDetailAttribute({
//     required this.id,
//     required this.name,
//     required this.numering,
//     required this.isPreSelected,
//     required this.options,
//   });

//   factory ItemAttributeDetailAttribute.fromJson(Map<String, dynamic> json) =>
//       ItemAttributeDetailAttribute(
//         id: json["id"],
//         name: json["name"],
//         numering: json["numering"],
//         isPreSelected: json["isPreSelected"],
//         options:
//             List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "numering": numering,
//         "isPreSelected": isPreSelected,
//         "options": List<dynamic>.from(options.map((x) => x.toJson())),
//       };
// }

// class Option {
//   int id;
//   String name;
//   int numering;

//   Option({
//     required this.id,
//     required this.name,
//     required this.numering,
//   });

//   factory Option.fromJson(Map<String, dynamic> json) => Option(
//         id: json["id"],
//         name: json["name"],
//         numering: json["numering"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "numering": numering,
//       };
// }

// class ItemDetail {
//   int id;
//   int itemId;
//   String name;
//   String code;
//   String posCode;
//   String erpCode;
//   int price;
//   Details? details;

//   ItemDetail({
//     required this.id,
//     required this.itemId,
//     required this.name,
//     required this.code,
//     required this.posCode,
//     required this.erpCode,
//     required this.price,
//     required this.details,
//   });

//   factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
//         id: json["id"],
//         itemId: json["itemId"],
//         name: json["name"],
//         code: json["code"],
//         posCode: json["posCode"],
//         erpCode: json["erpCode"],
//         price: json["price"],
//         details:
//             json["details"] == null ? null : Details.fromJson(json["details"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "itemId": itemId,
//         "name": name,
//         "code": code,
//         "posCode": posCode,
//         "erpCode": erpCode,
//         "price": price,
//         "details": details?.toJson(),
//       };
// }

// class Details {
//   List<DetailsAttributeOption> attributeOptions;
//   bool isDefault;

//   Details({
//     required this.attributeOptions,
//     required this.isDefault,
//   });

//   factory Details.fromJson(Map<String, dynamic> json) => Details(
//         attributeOptions: List<DetailsAttributeOption>.from(
//             json["attributeOptions"]
//                 .map((x) => DetailsAttributeOption.fromJson(x))),
//         isDefault: json["isDefault"],
//       );

//   Map<String, dynamic> toJson() => {
//         "attributeOptions":
//             List<dynamic>.from(attributeOptions.map((x) => x.toJson())),
//         "isDefault": isDefault,
//       };
// }

// class DetailsAttributeOption {
//   int attributeId;
//   int optionId;

//   DetailsAttributeOption({
//     required this.attributeId,
//     required this.optionId,
//   });

//   factory DetailsAttributeOption.fromJson(Map<String, dynamic> json) =>
//       DetailsAttributeOption(
//         attributeId: json["attributeId"],
//         optionId: json["optionId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "attributeId": attributeId,
//         "optionId": optionId,
//       };
// }

// class Item {
//   int brandId;
//   int id;
//   int caregoryId;
//   String name;
//   String type;
//   String mType;
//   int numering;
//   LangData lang;
//   Status status;
//   bool isAttribute;

//   Item({
//     required this.brandId,
//     required this.id,
//     required this.caregoryId,
//     required this.name,
//     required this.type,
//     required this.mType,
//     required this.numering,
//     required this.lang,
//     required this.status,
//     required this.isAttribute,
//   });

//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//         brandId: json["brandId"],
//         id: json["id"],
//         caregoryId: json["caregoryId"],
//         name: json["name"],
//         type: json["type"],
//         mType: json["mType"],
//         numering: json["numering"],
//         lang: LangData.fromJson(json["lang"]),
//         status: statusValues.map[json["status"]]!,
//         isAttribute: json["isAttribute"],
//       );

//   Map<String, dynamic> toJson() => {
//         "brandId": brandId,
//         "id": id,
//         "caregoryId": caregoryId,
//         "name": name,
//         "type": type,
//         "mType": mType,
//         "numering": numering,
//         "lang": lang.toJson(),
//         "status": statusValues.reverse[status],
//         "isAttribute": isAttribute,
//       };
// }

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
