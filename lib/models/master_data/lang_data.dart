class LangData {
  String vn;
  String en;

  LangData({
    required this.vn,
    required this.en,
  });

  factory LangData.fromJson(Map<String, dynamic> json) => LangData(
        vn: json["vn"],
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "vn": vn,
        "en": en,
      };
}
