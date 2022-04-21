import 'dart:convert';
import 'dart:io';

import 'package:disdukcapil_mobile/screens/detail_screen.dart';
import 'package:disdukcapil_mobile/widgets/shimmer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'expansion_tile_item.dart';
import 'list_tile_item.dart';
import 'dart:developer';

import '../shared/api.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  Future<List<dynamic>> _fetchMenus() async {
    var result = await http.get(Uri.parse(apiUrl + '/menus'),
        headers: {'Authorization': 'Bearer ' + token});
    log(result.body);
    return json.decode(result.body)['data'];
  }

  Future<List<dynamic>> _fetchSubMenus(String parentId) async {
    var result = await http.get(
        Uri.parse(
          apiUrl + '/submenus/' + parentId,
        ),
        headers: {'Authorization': 'Bearer ' + token});

    return json.decode(result.body)['data'];
  }

  String token = '';

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('login')!;
    });
  }

  @override
  void initState() {
    super.initState();
    getCred();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchMenus(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              if (snapshot.data![index]['has_child'] == 0) {
                return ListTileItem(
                  title: snapshot.data![index]['name'],
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailScreen(
                              urlview: snapshot.data![index]['urlview']))),
                );
              } else {
                String parentId = snapshot.data![index]['id'].toString();

                return ExpansionTileItem(
                  title: snapshot.data![index]['name'],
                  children: [
                    FutureBuilder<List<dynamic>>(
                      future: _fetchSubMenus(parentId),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) {
                              if (snapshot.data![index]['has_child'] == 0) {
                                return ListTileItem(
                                  title: snapshot.data![index]['name'],
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                              urlview: snapshot.data![index]
                                                  ['urlview']))),
                                );
                              } else {
                                String parentId =
                                    snapshot.data![index]['id'].toString();

                                return ExpansionTileItem(
                                  title: snapshot.data![index]['name'],
                                  children: [
                                    FutureBuilder<List<dynamic>>(
                                      future: _fetchSubMenus(parentId),
                                      builder: (_, snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (_, index) {
                                              if (snapshot.data![index]
                                                      ['has_child'] ==
                                                  0) {
                                                return ListTileItem(
                                                  title: snapshot.data![index]
                                                      ['name'],
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailScreen(
                                                                  urlview: snapshot
                                                                              .data![
                                                                          index]
                                                                      [
                                                                      'urlview']))),
                                                );
                                              } else {
                                                return ExpansionTileItem(
                                                  title: snapshot.data![index]
                                                      ['name'],
                                                );
                                              }
                                            },
                                          );
                                        } else {
                                          return buildShimmer();
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        } else {
                          return buildShimmer();
                        }
                      },
                    ),
                  ],
                );
              }
            },
          );
        } else {
          return buildShimmer();
        }
      },
    );
  }

  Widget loadingData() {
    return Platform.isAndroid
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(child: CupertinoActivityIndicator());
  }

  Widget buildShimmer() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 8,
        itemBuilder: (_, index) {
          return ListTile(
            title: ShimmerWidget.rectangular(height: 16),
          );
        });
  }
}
