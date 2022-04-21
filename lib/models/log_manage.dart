// To parse this JSON data, do
//
//     final log = logFromJson(jsonString);

import 'dart:convert';

Log logFromJson(String str) => Log.fromJson(json.decode(str));

String logToJson(Log data) => json.encode(data.toJson());

class Log {
    Log({
        this.id,
        this.username,
        this.activity,
        this.module,
        this.url,
        this.from,
        this.createdAt,
    });

    int? id;
    String? username;
    String? activity;
    String? module;
    String? url;
    String? from;
    String? createdAt;

    factory Log.fromJson(Map<String, dynamic> json) => Log(
        id: json["id"] ?? "",
        username: json["username"] ?? "",
        activity: json["activity"] ?? "",
        module: json["module"] ?? "",
        url: json["url"] ?? "",
        from: json["from"] ?? "",
        createdAt: json["created_at"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "activity": activity,
        "module": module,
        "url": url,
        "from": from,
        "created_at": createdAt,
    };
}
