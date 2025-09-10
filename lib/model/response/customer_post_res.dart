// To parse this JSON data, do
//
//     final customerPostResponse = customerPostResponseFromJson(jsonString);

import 'dart:convert';

CustomerPostResponse customerPostResponseFromJson(String str) =>
    CustomerPostResponse.fromJson(json.decode(str));

String customerPostResponseToJson(CustomerPostResponse data) =>
    json.encode(data.toJson());

class CustomerPostResponse {
  String message;
  int id;

  CustomerPostResponse({required this.message, required this.id});

  factory CustomerPostResponse.fromJson(Map<String, dynamic> json) =>
      CustomerPostResponse(message: json["message"], id: json["id"]);

  Map<String, dynamic> toJson() => {"message": message, "id": id};
}
