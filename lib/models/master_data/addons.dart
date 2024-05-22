class Addons {
  String name;
  int price;

  Addons({
    required this.name,
    required this.price,
  });

  factory Addons.fromJson(Map<String, dynamic> json) => Addons(
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
      };
}