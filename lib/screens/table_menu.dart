import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:disdukcapil_mobile/models/menus.dart';
import 'package:disdukcapil_mobile/widgets/badge_index.dart';
import 'package:disdukcapil_mobile/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_menu.dart';
import 'details_menu.dart';
import 'edit_menu.dart';

class TableMenu extends StatefulWidget {
  const TableMenu({Key? key}) : super(key: key);

  @override
  _TableMenuState createState() => _TableMenuState();
}

class _TableMenuState extends State<TableMenu> {
  ///Export PDF
  int progress = 0;

  final ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    sendPort!.send([id, status, progress]);
  }

  ///Get Menus
  String menuPage = "1";
  Future<List<Menus>> getMenus() async {
    var response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/menu-management?page=" + menuPage),
        headers: {
          'Authorization': 'Bearer ' + token,
        });

    if (response.statusCode == 200) {
      var parsed = json.decode(response.body);
      List jsonResponse = parsed['data'] as List;

      return jsonResponse.map((menus) => Menus.fromJson(menus)).toList();
    } else {
      throw Exception('failed load');
    }
  }

  ///Delete Menu
  Future deleteMenu(String id) async {
    String apiUrl = "http://172.16.5.236:8080/api/menu-management/" + id;
    final response = await http.delete(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer ' + token,
    });

    return json.decode(response.body);
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('login')!;
    });
  }

  String token = '';

  @override
  void initState() {
    super.initState();
    getCred();
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      print(progress);
    });
    FlutterDownloader.registerCallback((downloadingCallback));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        body: SafeArea(
          child: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget? child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    height: 28,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0,
                    child: Container(
                      color: connected
                          ? Colors.transparent
                          : const Color(0xFFEE4400),
                      child: Center(
                        child: connected
                            ? const SizedBox()
                            : const Text(
                                'Please Turn On Your Internet Data',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                  connected ? _listTabelMenu() : const SizedBox(),
                ],
              );
            },
            child: const SizedBox(),
          ),
        ));
  }

  Widget _listTabelMenu() {
    List<String> doubleList =
        List<String>.generate(25, (int index) => '${index + 1}');
    List<DropdownMenuItem> menuItemList = doubleList
        .map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();
    return Column(
      children: [
        Builder(builder: (context) {
          return BadgeIndex();
        }),
        Expanded(
          child: FutureBuilder<List<Menus>>(
              future: getMenus(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  List<Menus> data = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 30, 0, 10),
                                    child: const Text('Menu Management',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddMenu())),
                                  child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 30, 20, 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff063A69),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Text('Tambah Menu',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffffffff)))),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final status =
                                        await Permission.storage.request();
                                    if (status.isGranted) {
                                      final externalDir =
                                          await getExternalStorageDirectory();

                                      // ignore: unused_local_variable
                                      final id = await FlutterDownloader.enqueue(
                                          url: "http://172.16.5.236:8080/api/export_menu",
                                          headers: {
                                            'Authorization': 'Bearer ' + token,
                                          },
                                          savedDir: externalDir!.path,
                                          fileName: "Download",
                                          showNotification: true,
                                          openFileFromNotification: true);
                                    } else {
                                      print('Permission denied');
                                    }
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff063A69),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Text('Export PDF',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffffffff)))),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) =>
                                                  const Color(0xffd3d3d3)),
                                      headingRowHeight: 60,
                                      sortColumnIndex: 0,
                                      sortAscending: true,
                                      columns: const [
                                        DataColumn(
                                          label: Text("Nama Menu",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          tooltip: "Menu Name",
                                        ),
                                        DataColumn(
                                          label: Text("Ref",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          tooltip: "Ref",
                                        ),
                                        DataColumn(
                                          label: Text("Url Website",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          tooltip: "Url Website",
                                        ),
                                        DataColumn(
                                          label: Text("Url Tableau",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          tooltip: "Url Tableau",
                                        ),
                                        DataColumn(
                                          label: Text("Parent",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          tooltip: "Parent",
                                        ),
                                        DataColumn(
                                          label: Text("Action",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          tooltip: "Menu Action",
                                        ),
                                      ],
                                      rows: data
                                          .map((menu) => DataRow(cells: [
                                                DataCell(
                                                  Container(
                                                    width: 100,
                                                    child: Text(
                                                      menu.name!,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                    width: 100,
                                                    child: Text(
                                                      menu.ref!,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                    width: 100,
                                                    child: Text(
                                                      menu.url!,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                    width: 100,
                                                    child: Text(
                                                      menu.urlview!,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Container(
                                                    child: Text(
                                                      menu.parentId.toString(),
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DetailsMenu(
                                                                          menus:
                                                                              menu.toJson())));
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0xff063A69),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: const Text(
                                                            'Details',
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFFFFFFFF)),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditMenu(
                                                                            menus:
                                                                                menu.toJson(),
                                                                          )));
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xfff8d62b),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: const Text(
                                                            'Edit',
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFFFFFFFF)),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      GestureDetector(
                                                        onTap: () => Platform
                                                                .isAndroid
                                                            ? showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                  title: const Text(
                                                                      'Delete Menu'),
                                                                  content:
                                                                      const Text(
                                                                          'Are you sure delete this menu?'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                      child: const Text(
                                                                          'Cancel'),
                                                                    ),
                                                                    TextButton(
                                                                        child:
                                                                            const Text(
                                                                          'Delete',
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          deleteMenu(menu.id!.toString())
                                                                              .then((value) {
                                                                            setState(() {
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                content: Text('Menu successfully delete!'),
                                                                              ));
                                                                              Navigator.pop(context);
                                                                            });
                                                                          });
                                                                        }),
                                                                  ],
                                                                ),
                                                              )
                                                            : showCupertinoDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CupertinoAlertDialog(
                                                                  title: const Text(
                                                                      'Delete Menu'),
                                                                  content:
                                                                      const Text(
                                                                          'Are you sure delete this menu?'),
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            'Cancel'),
                                                                        child: const Text(
                                                                            'Cancel')),
                                                                    CupertinoDialogAction(
                                                                        child:
                                                                            const Text(
                                                                          'Delete',
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          deleteMenu(menu.id!.toString())
                                                                              .then((value) {
                                                                            setState(() {
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                content: Text('Menu successfully delete!'),
                                                                              ));
                                                                            });
                                                                          });
                                                                        })
                                                                  ],
                                                                ),
                                                              ),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xffdc3545),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: const Text(
                                                            'Delete',
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFFFFFFFF)),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ]))
                                          .toList()))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Page'),
                            const SizedBox(
                              width: 10,
                            ),
                            DropdownButton<dynamic>(
                              value: menuPage,
                              icon: const Icon(Icons.arrow_forward_rounded),
                              iconSize: 20,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                color: Colors.transparent,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  menuPage = newValue! as String;
                                });
                              },
                              items: menuItemList,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return Platform.isAndroid
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                          child: CupertinoActivityIndicator(),
                        );
                }
              }),
        ),
      ],
    );
  }
}
