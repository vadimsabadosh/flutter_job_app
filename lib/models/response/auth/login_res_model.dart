import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final String id;
  final String profile;
  final String token;
  final String username;

  LoginResponse({
    required this.id,
    required this.profile,
    required this.token,
    required this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["_id"],
        profile: json["profile"],
        token: json["token"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "profile": profile,
        "token": token,
        "username": username,
      };
}
