import 'dart:convert';

///Get & Delete Menus
class Menus {
  int? id;
  int? parentId;
  int? siteId;
  int? value;
  String? name;
  String? ref;
  String? url;
  String? urlview;
  int? no;
  int? hide;
  String? icon;
  String? role;

  Menus(
      {this.id,
      this.parentId,
      this.siteId,
      this.value,
      this.name,
      this.ref,
      this.url,
      this.urlview,
      this.no,
      this.hide,
      this.icon,
      this.role});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      id: json['id'],
      parentId: json['parent_id'],
      siteId: json['site_id'] ?? "",
      value: json['value'] ?? "",
      name: json['name'] ?? "",
      ref: json['ref'] ?? "",
      url: json['url'] ?? "",
      urlview: json['urlview'] ?? "",
      no: json['no'] ?? "",
      hide: json['hide'] ?? "",
      icon: json['icon'] ?? "",
      role: json["roles"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "parent_id": parentId,
      "site_id": siteId,
      "value": value,
      "name": name,
      "ref": ref,
      "url": url,
      "urlview": urlview,
      "no": no,
      "hide": hide,
      "icon": icon,
      "roles": role,
    };
  }
}

List<Menus> menusFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Menus>.from(data.map((item) => Menus.fromJson(item)));
}

String menusToJson(Menus data) {
  final jsonData = data.toJson();
  return jsonEncode(jsonData);
}

///Post & Edit Menus
Rolemenu rolemenuFromJson(String str) => Rolemenu.fromJson(json.decode(str));

String rolemenuToJson(Rolemenu data) => json.encode(data.toJson());

class Rolemenu {
  Rolemenu({
    this.parentId,
    this.siteId,
    this.value,
    this.name,
    this.ref,
    this.url,
    this.urlview,
    this.no,
    this.hide,
    this.icon,
    this.role,
  });

  int? parentId;
  int? siteId;
  int? value;
  String? name;
  String? ref;
  String? url;
  String? urlview;
  int? no;
  int? hide;
  String? icon;
  List<String>? role;

  Rolemenu.fromJson(Map<String, dynamic> json) {
    parentId = json["parent_id"];
    siteId = json["site_id"] ?? null;
    value = json["value"] ?? null;
    name = json["name"];
    ref = json["ref"];
    url = json["url"];
    urlview = json["urlview"] ?? null;
    no = json["no"] ?? "";
    hide = json["hide"];
    icon = json["icon"] ?? "";
    role = json["role"].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["parent_id"] = this.parentId;
    data["site_id"] = this.siteId;
    data["value"] = this.value;
    data["name"] = this.name;
    data["ref"] = this.ref;
    data["url"] = this.url;
    data["urlivew"] = this.urlview;
    data["no"] = this.no;
    data["hide"] = this.hide;
    data["icon"] = this.icon;
    data["role"] = this.role;
    return data;
  }
}

///Get Role
class Role {
  Role({
     this.id,
     this.name,
  });

  final int? id;
  final String? name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
