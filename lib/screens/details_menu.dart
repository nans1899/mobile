import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class DetailsMenu extends StatelessWidget {
  DetailsMenu({Key? key, required this.menus}) : super(key: key);

  final Map menus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                connected ? _contentDetailsMenu(context) : const SizedBox(),
              ],
            );
          },
          child: const SizedBox(),
        )),
    );
  }

  Widget _contentDetailsMenu(BuildContext context){
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back))),
                  Spacer(),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: const Text('Details Menu',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  Spacer()
                ],
              ),
            ),
            Column(
              children: [
                Container(
                    margin: EdgeInsets.all(15),
                    child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: {
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(6)
                        },
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text("Name ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  )
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(menus['name'] ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ])
                          ]),
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text("Ref ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  )
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(menus['ref'] ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ])
                          ]),
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text("Url Website ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  )
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(menus['url'] ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ])
                          ]),
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text("Url Tableau ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  )
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(menus['urlview'] ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ])
                          ]),
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text("Parent Id ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  )
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(menus['parent_id'].toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ])
                          ]),
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text("No ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  )
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(menus['no'].toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ])
                          ]),
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text("Hide ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  )
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(menus['hide'].toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ])
                          ]),
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text("Icons ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  )
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(menus['icon'] ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ])
                          ]),
                          TableRow(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text("Roles ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  )
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(menus['roles'] ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ])
                          ]),
                        ])),
              ],
            )
          ],
        ),
      );
  }
}
