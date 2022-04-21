import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class DetailsUser extends StatelessWidget {
  DetailsUser({Key? key, required this.user}) : super(key: key);
  final Map user;

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
                connected ? _contentDetailsUser(context) : const SizedBox(),
              ],
            );
          },
          child: const SizedBox(),
        ),),
    );
  }

  Widget _contentDetailsUser(BuildContext context){
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
                              child: const Text('Detail Users',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                          Spacer(),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          child: Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            columnWidths:{
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(6)
                            },
                            border: TableBorder.all(),
                            children: [
                              TableRow(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text("Name ",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
                                        ),
                                      )
                                    ]
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(user['name'] ?? "",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      )
                                    ]
                                  )
                                ]
                              ),
                              TableRow(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text("Email ",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
                                        ),
                                      )
                                    ]
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(user['email'] ?? "",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      )
                                    ]
                                  )
                                ]
                              ),
                              TableRow(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text("Username ",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
                                        ),
                                      )
                                    ]
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(user['username'] ?? "",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      )
                                    ]
                                  )
                                ]
                              ),
                              TableRow(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text("Whatsapp ",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
                                        ),
                                      )
                                    ]
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(user['whatsapp'] ?? "",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      )
                                    ]
                                  )
                                ]
                              ),
                              TableRow(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text("Slack ",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
                                        ),
                                      )
                                    ]
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(user['slack'] ?? "",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      )
                                    ]
                                  )
                                ]
                              ),
                              TableRow(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text("Role Id ",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
                                        ),
                                      )
                                    ]
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(user['role_id'] ?? "",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      )
                                    ]
                                  )
                                ]
                              ),
                            ]
                          ),
                        )
                      ]
                    )
                  ]));
  }
}
