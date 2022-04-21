import 'dart:convert';
import 'dart:io';
import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddRolePage extends StatefulWidget {
  const AddRolePage({Key? key}) : super(key: key);

  @override
  State<AddRolePage> createState() => _AddRolePageState();
}

class _AddRolePageState extends State<AddRolePage> {
  final TextEditingController _nameController = TextEditingController();
  String token = '';
  Future addRole() async {
    String url = 'http://10.0.2.2:8000/api/role-management';

    final response = await http.post((Uri.parse(url)), body: {
      "name": _nameController.text,
    }, headers: {
      'Authorization': 'Bearer ' + token
    });
    print(json.decode(response.body));
    return json.decode(response.body);
  }

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
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
              ),
              title: Text(
                "Add Role",
                style: blackTitleTextStyle.copyWith(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: OfflineBuilder(
                connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget? child,
                ) {
                  final bool connected =
                      connectivity != ConnectivityResult.none;
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
                      connected ? _contentAddRole() : const SizedBox(),
                    ],
                  );
                },
                child: const SizedBox(),
              ),
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(CupertinoIcons.back),
                  color: Colors.black),
              middle: Text(
                "Add Role",
                style: blackTitleTextStyle.copyWith(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
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
                    connected ? _contentAddRole() : const SizedBox(),
                  ],
                );
              },
              child: const SizedBox(),
            ));
  }

  Widget _contentAddRole() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  addRole()
                      .then((value) => Navigator.pushNamed(context, '/role'));
                });
              },
              child: const Text('Save'))
        ],
      ),
    );
  }
}
