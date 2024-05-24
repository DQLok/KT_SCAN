// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
  String phone;
  String password;

  Account({
    required this.phone,
    required this.password,
  });

  Account copyWith({
    String? phone,
    String? password,
  }) =>
      Account(
        phone: phone ?? this.phone,
        password: password ?? this.password,
      );

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "password": password,
      };

  @override
  String toString() {
    return "$phone - $password";
  }
}
