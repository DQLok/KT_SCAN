class OptionData {
  int id;
  String name;
  int numering;

  OptionData({
    required this.id,
    required this.name,
    required this.numering,
  });

  factory OptionData.fromJson(Map<String, dynamic> json) => OptionData(
        id: json["id"],
        name: json["name"],
        numering: json["numering"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "numering": numering,
      };
}
