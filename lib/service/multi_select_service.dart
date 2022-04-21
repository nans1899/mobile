import 'dart:convert';
import 'package:disdukcapil_mobile/models/menus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final _url = "http://172.16.5.236:8080/api/role-management";
  String token = '';

  Future fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('login')!;
    try {
      final response = await http.get(Uri.parse(_url), headers: {
        'Authorization': 'Bearer ' + token,
      });

      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = jsonDecode(response.body)['data'];
        List<Role> roleModel = it.map((e) => Role.fromJson(e)).toList();
        return roleModel;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class MenuService {
  final _url = "http://172.16.5.236:8080/api/role-management";
  String token = '';

  Future fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('login')!;
    try {
      final response = await http.get(Uri.parse(_url), headers: {
        'Authorization': 'Bearer ' + token,
      });

      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = jsonDecode(response.body)['data'];
        List<Menus> menuModel = it.map((e) => Menus.fromJson(e)).toList();
        return menuModel;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
