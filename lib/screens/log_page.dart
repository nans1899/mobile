import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:disdukcapil_mobile/widgets/badge_index.dart';
import 'package:disdukcapil_mobile/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:disdukcapil_mobile/models/log_manage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  ///Export PDF
  int progress = 0;

  final ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    sendPort!.send([id, status, progress]);
  }

  Future<List<Log>> getLog() async {
    var response = await http
        .get(Uri.parse("http://10.0.2.2:8000/api/log-management"), headers: {
      'Authorization': 'Bearer ' + token,
    });

    if (response.statusCode == 200) {
      var parsed = json.decode(response.body);
      List jsonResponse = parsed['data'] as List;

      return jsonResponse.map((log) => Log.fromJson(log)).toList();
    } else {
      throw Exception('failed load');
    }
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
                connected ? _listTableLog() : const SizedBox(),
              ],
            );
          },
          child: const SizedBox(),
        ),
      ),
    );
  }

  Widget _listTableLog() {
    return Column(
      children: [
        Builder(builder: (context) {
          return BadgeIndex();
        }),
        Expanded(
            child: FutureBuilder<List<Log>>(
          future: getLog(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<Log> data = snapshot.data!;
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
                                margin:
                                    const EdgeInsets.fromLTRB(20, 30, 0, 10),
                                child: const Text('Log Management',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
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
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xffd3d3d3)),
                              headingRowHeight: 60,
                              sortColumnIndex: 0,
                              sortAscending: true,
                              columns: const [
                                DataColumn(
                                  label: Text("Username",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  tooltip: "Username",
                                ),
                                DataColumn(
                                  label: Text("Activity",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  tooltip: "Activity",
                                ),
                                DataColumn(
                                  label: Text("Module",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  tooltip: "Module",
                                ),
                                DataColumn(
                                  label: Text("Url",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  tooltip: "Url",
                                ),
                                DataColumn(
                                  label: Text("From",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  tooltip: "From",
                                ),
                                DataColumn(
                                  label: Text("Created_at",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  tooltip: "Created_at",
                                ),
                              ],
                              rows: data
                                  .map((log) => DataRow(cells: [
                                        DataCell(
                                          Container(
                                            width: 100,
                                            child: Text(
                                              log.username!,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 100,
                                            child: Text(
                                              log.activity!,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 100,
                                            child: Text(
                                              log.module!,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 100,
                                            child: Text(
                                              log.url!,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 100,
                                            child: Text(
                                              log.from!,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 100,
                                            child: Text(
                                              log.createdAt!,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ]))
                                  .toList()),
                        ),
                      ),
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
          },
        ))
      ],
    );
  }
}
