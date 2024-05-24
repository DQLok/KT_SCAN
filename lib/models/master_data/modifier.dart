class Modifier {
  String name;
  int price;

  Modifier({
    required this.name,
    required this.price,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) => Modifier(
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
      };
}