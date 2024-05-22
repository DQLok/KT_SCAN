class DetailsAttributeOption {
  int attributeId;
  int optionId;

  DetailsAttributeOption({
    required this.attributeId,
    required this.optionId,
  });

  factory DetailsAttributeOption.fromJson(Map<String, dynamic> json) =>
      DetailsAttributeOption(
        attributeId: json["attributeId"],
        optionId: json["optionId"],
      );

  Map<String, dynamic> toJson() => {
        "attributeId": attributeId,
        "optionId": optionId,
      };
}