import 'dart:convert';

class Users{
  int? id;
  String? name;
  String? email;
  String? username;
  String? foto;
  String? whatsapp;
  String? slack;
  String? roleId;

  Users({
    this.id,
    this.name,
    this.email,
    this.username,
    this.foto,
    this.whatsapp,
    this.slack,
    this.roleId
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    username: json["username"],
    foto: json["foto"],
    whatsapp: json["whatsapp"] ?? "",
    slack: json["slack"] ?? "",
    roleId: json["role_id"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "username": username,
    "foto": foto,
    "whatsapp": whatsapp,
    "slack": slack,
    "role_id": roleId
  };
}

 Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());


class SingleUsers{
  String? name;
  String? email;
  String? username;
  String? whatsapp;
  String? slack;
  String? roleId;

  SingleUsers({
    this.name,
    this.email,
    this.username,
    this.whatsapp,
    this.slack,
    this.roleId
  });

  factory SingleUsers.fromJson(Map<String, dynamic> json) => SingleUsers(
    name: json["name"],
    email: json["email"],
    username: json["username"],
    whatsapp: json["whatsapp"] ?? "",
    slack: json["slack"] ?? "",
    roleId: json["role_id"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "username": username,
    "whatsapp": whatsapp,
    "slack": slack,
    "role_id": roleId
  };
}

 SingleUsers userFromJson(String str) => SingleUsers.fromJson(json.decode(str));

String userToJson(SingleUsers data) => json.encode(data.toJson());


class ProfileUsers{
  String? name;
  String? email;
  String? foto;
  String? username;
  String? whatsapp;
  String? slack;
  String? roleId;

  ProfileUsers({
    this.name,
    this.email,
    this.foto,
    this.username,
    this.whatsapp,
    this.slack,
    this.roleId
  });

  factory ProfileUsers.fromJson(Map<String, dynamic> json) => ProfileUsers(
    name: json["name"],
    email: json["email"],
    foto: json["foto"],
    username: json["username"],
    whatsapp: json["whatsapp"] ?? "",
    slack: json["slack"] ?? "",
    roleId: json["role_id"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "foto": foto,
    "username": username,
    "whatsapp": whatsapp,
    "slack": slack,
    "role_id": roleId
  };
}

 ProfileUsers profileuserFromJson(String str) => ProfileUsers.fromJson(json.decode(str));

String profileuserToJson(ProfileUsers data) => json.encode(data.toJson());