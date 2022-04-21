import 'dart:convert';
import 'dart:io';
import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditRolePage extends StatefulWidget {
  EditRolePage({Key? key, required this.role}) : super(key: key);
  final Map role;

  @override
  State<EditRolePage> createState() => _EditRolePageState();
}

class _EditRolePageState extends State<EditRolePage> {
  final TextEditingController _nameController = TextEditingController();

  Future editRole() async {
    String url = 'http://10.0.2.2:8000/api/role-management/' +
        widget.role['id'].toString() +
        '/update';

    final response = await http.put((Uri.parse(url)), body: {
      "name": _nameController.text,
    }, headers: {
      'Authorization': 'Bearer ' + token,
    });

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to Update Role');
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
                "Edit Menu",
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
                      connected ? _editContentRole() : const SizedBox(),
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
                "Edit Menu",
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
                    connected ? _editContentRole() : const SizedBox(),
                  ],
                );
              },
              child: const SizedBox(),
            ));
  }

  Widget _editContentRole() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _nameController..text = widget.role['name'],
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data berhasil di Update')));
              editRole().then((value) => Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false));
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
