// To parse this JSON data, do
//
//     final masterData = masterDataFromJson(jsonString);

import 'dart:convert';

import 'package:teca/models/master_data/attribute_option.dart';
import 'package:teca/models/master_data/brand_data.dart';
import 'package:teca/models/master_data/category_element.dart';
import 'package:teca/models/master_data/data_mapping_channel.dart';
import 'package:teca/models/master_data/item_attribute_detail.dart';
import 'package:teca/models/master_data/item_data.dart';
import 'package:teca/models/master_data/item_detail.dart';

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
