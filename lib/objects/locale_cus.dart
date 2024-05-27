import 'package:flutter/material.dart';

class LocaleCus {
  final String language;
  final String country;
  final String codePhone;
  final String flag;
  final Locale? locale;

  LocaleCus(
      {required this.language,
      required this.country,
      required this.codePhone,
      required this.flag,
      this.locale});

  factory LocaleCus.fromJson(Map<String, dynamic> json) {
    return LocaleCus(
        language: json["language"],
        country: json["country"],
        codePhone: json["codePhone"],
        flag: json["flag"]);
  }

  Map<String, dynamic> toJson() => {
        "language": language,
        "country": country,
        "codePhone": codePhone,
        "flag": flag
      };
}

List<LocaleCus> listLocaleCus = [
  LocaleCus(
      language: "vi",
      country: "VI",
      codePhone: "+84",
      flag: "",
      locale: const Locale("vi", "VI")),
  LocaleCus(
      language: "en",
      country: "GB",
      codePhone: "+44",
      flag: "",
      locale: const Locale("en", "GB")),
];
