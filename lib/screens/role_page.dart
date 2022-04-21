import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:disdukcapil_mobile/screens/edit_role_page.dart';
import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:disdukcapil_mobile/widgets/badge_index.dart';
import 'package:disdukcapil_mobile/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_offline/flutter_offline.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RolePage extends StatefulWidget {
  const RolePage({Key? key}) : super(key: key);

  @override
  _RolePageState createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  Future<List<dynamic>> getRole() async {
    String url = 'http://10.0.2.2:8000/api/role-management/';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ' + token,
    });

    return json.decode(response.body)['data'];
  }

  Future deleteRole(String roleId) async {
    String url = 'http://172.16.5.236:8080/api/role-management/' + roleId;

    try {
      final response = await http.delete(
        (Uri.parse(url)),
      );
      print(json.decode(response.body));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Roles Berhasil Di Hapus')));
      return json.decode(response.body);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Roles Gagal di Hapus')));
    }
  }

  Future downloadMenu() async {
    var status = await Permission.storage.request();
    try {
      if (status.isGranted) {
        final baseStoreage = await getExternalStorageDirectory();
        await FlutterDownloader.enqueue(
            url: 'http://172.16.5.236:8080/api/export_menu',
            headers: {
              'Authorization': 'Bearer ' + token,
            },
            savedDir: baseStoreage!.path,
            showNotification:
                true, // show download progress in status bar (for Android)
            openFileFromNotification: true,
            fileName:
                'Export Menu.pdf' // click on notification to open downloaded file (for Android)
            );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future downloadUser() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStoreage = await getExternalStorageDirectory();
      try {
        await FlutterDownloader.enqueue(
            url: 'http://172.16.5.236:8080/api/export_user',
            headers: {
              'Authorization': 'Bearer ' + token,
            },
            savedDir: baseStoreage!.path,
            showNotification: true,
            openFileFromNotification: true,
            fileName: 'Export User.pdf');
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('login')!;
    });
  }

  final ReceivePort _port = ReceivePort();

  String token = '';

  @override
  void initState() {
    super.initState();
    // GET Credential Local Storage Token
    getCred();
    // Flutter Download Package
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      setState(() {
        if (status == DownloadTaskStatus.complete) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Download Complete')));
          FlutterDownloader.open(taskId: id);
        }
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
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
                connected ? listItem() : const SizedBox(),
              ],
            );
          },
          child: const SizedBox(),
        ),
      ),
    );
  }

  Widget listItem() {
    return Column(
      children: [
        Builder(builder: (context) {
          return BadgeIndex();
        }),
        Expanded(
          child: SingleChildScrollView(
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
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 30, 0, 10),
                                  child: const Text('Role Management',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/add-role');
                                },
                                child: Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        0, 30, 20, 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff063A69),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Text('Tambah Role',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff)))),
                              ),
                              GestureDetector(
                                onTap: () {
                                  downloadMenu().then((value) =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Download Menu Start'))));
                                },
                                child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 20, 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff063A69),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Text('Export Menu',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff)))),
                              ),
                              GestureDetector(
                                onTap: () {
                                  downloadUser().then((value) =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Download User Start'))));
                                },
                                child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 20, 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff063A69),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Text('Export User',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff)))),
                              ),
                            ],
                          )
                        ]),
                    Container(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FutureBuilder<List<dynamic>>(
                              future: getRole(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  snapshot.data![index]['name'],
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditRolePage(
                                                        role: snapshot
                                                            .data![index],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xfff8d62b),
                                                ),
                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              TextButton(
                                                onPressed: () => Platform
                                                        .isAndroid
                                                    ? showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  title: const Text(
                                                                      'Delete Role'),
                                                                  content:
                                                                      const Text(
                                                                          'Before you delete the role, you must delete the menu relation'),
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
                                                                          deleteRole(snapshot.data![index]['id'].toString())
                                                                              .then((value) {
                                                                            setState(() {
                                                                              Navigator.pop(context);
                                                                            });
                                                                          });
                                                                        }),
                                                                  ],
                                                                ))
                                                    : showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CupertinoAlertDialog(
                                                          title: const Text(
                                                              'Delete Role'),
                                                          content: const Text(
                                                              'Before you delete the role, you must delete the menu relation'),
                                                          actions: [
                                                            CupertinoDialogAction(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context,
                                                                        'Cancel'),
                                                                child: const Text(
                                                                    'Cancel')),
                                                            CupertinoDialogAction(
                                                                child:
                                                                    const Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                onPressed: () {
                                                                  deleteRole(snapshot
                                                                          .data![
                                                                              index]
                                                                              [
                                                                              'id']
                                                                          .toString())
                                                                      .then(
                                                                          (value) {
                                                                    setState(
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                      ),
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xffdc3545),
                                                ),
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                } else if (snapshot.hasError) {
                                  const Text('Error');
                                }
                                return Platform.isAndroid
                                    ? Center(child: CircularProgressIndicator())
                                    : Center(
                                        child: CupertinoActivityIndicator(),
                                      );
                              }),
                        ],
                      ),
                    ),
                  ])),
        ),
      ],
    );
  }
}
