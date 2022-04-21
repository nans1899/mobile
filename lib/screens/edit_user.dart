import 'dart:io';

import 'package:disdukcapil_mobile/models/menus.dart';
import 'package:disdukcapil_mobile/models/users.dart';
import 'package:disdukcapil_mobile/service/multi_select_service.dart';
import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:validators/validators.dart';

import 'table_user.dart';

class EditUser extends StatefulWidget {
  EditUser({Key? key, required this.user}) : super(key: key);
  final Map user;

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  SingleUsers user = SingleUsers();
  String token = '';

  ///Edit User
  Future editUser() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };
    final msg = {
      "name": user.name,
      "email": user.email,
      "username": user.username,
      "whatsapp": user.whatsapp,
      "slack": user.slack,
      "role_id": user.roleId
    };
    var body = jsonEncode(msg);

    final response = await http.put(
        Uri.parse("http://10.0.2.2:8000/api/user-management/" +
            widget.user['id'].toString() +
            '/update'),
        headers: headers,
        body: body);

    print(response.statusCode);
    print(response.body);

    return json.decode(response.body)['data'];
  }

  //=============================================================//
  late List<Role> roles = [];
  ApiService roleService = ApiService();

  String? idRole;

  getData() async {
    roles = await roleService.fetchData();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('login')!;
    });
  }

  @override
  void initState() {
    getData();
    getCred();
    super.initState();
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
                "Edit User",
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
                      connected ? _uiWidget() : const SizedBox(),
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
                "Edit User",
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
                    connected ? _uiWidget() : const SizedBox(),
                  ],
                );
              },
              child: const SizedBox(),
            ));
  }

  Widget _uiWidget() {
    return Form(
        key: globalKey,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 15, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        FormHelper.inputFieldWidget(context, "name", "Name",
                            (onValidateVal) {
                          if (onValidateVal.isEmpty) {
                            return 'Name cant be empty';
                          }
                          return null;
                        }, (onSavedVal) {
                          user.name = onSavedVal;
                        },
                            initialValue: widget.user['name'],
                            borderColor: bluePrimaryColor,
                            borderFocusColor: bluePrimaryColor,
                            borderRadius: 20,
                            fontSize: 14,
                            paddingLeft: 0,
                            paddingRight: 0,
                            hintColor: Colors.grey.shade200),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 15, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        FormHelper.inputFieldWidget(
                            context,
                            "email",
                            "Email",
                            (onValidateVal) => !isEmail(onValidateVal)
                                ? "Please enter valid email"
                                : null, (onSavedVal) {
                          user.email = onSavedVal;
                        },
                            initialValue: widget.user['email'],
                            borderColor: bluePrimaryColor,
                            borderFocusColor: bluePrimaryColor,
                            borderRadius: 20,
                            fontSize: 14,
                            paddingLeft: 0,
                            paddingRight: 0,
                            hintColor: Colors.grey.shade200),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 15, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Username",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        FormHelper.inputFieldWidget(
                            context, "username", "Username", (onValidateVal) {
                          if (onValidateVal.isEmpty) {
                            return 'Username cant be empty';
                          }
                          return null;
                        }, (onSavedVal) {
                          user.username = onSavedVal;
                        },
                            initialValue: widget.user['username'],
                            borderColor: bluePrimaryColor,
                            borderFocusColor: bluePrimaryColor,
                            borderRadius: 20,
                            fontSize: 14,
                            paddingLeft: 0,
                            paddingRight: 0,
                            hintColor: Colors.grey.shade200),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 15, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Whatsapp",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        FormHelper.inputFieldWidget(
                            context,
                            "whatsapp",
                            "Whatsapp",
                            (onValidateVal) => !isNumeric(onValidateVal)
                                ? "Please enter valid Phone Number"
                                : null, (onSavedVal) {
                          user.whatsapp = onSavedVal;
                        },
                            initialValue: widget.user['whatsapp'],
                            borderColor: bluePrimaryColor,
                            borderFocusColor: bluePrimaryColor,
                            borderRadius: 20,
                            fontSize: 14,
                            paddingLeft: 0,
                            paddingRight: 0,
                            hintColor: Colors.grey.shade200),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 15, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Slack",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        FormHelper.inputFieldWidget(
                            context, "slack", "Slack", (onValidateVal) {},
                            (onSavedVal) {
                          user.slack = onSavedVal;
                        },
                            initialValue: widget.user['slack'],
                            borderColor: bluePrimaryColor,
                            borderFocusColor: bluePrimaryColor,
                            borderRadius: 20,
                            fontSize: 14,
                            paddingLeft: 0,
                            paddingRight: 0,
                            hintColor: Colors.grey.shade200),
                      ],
                    ),
                  ),
                  Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Akses Role',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        FutureBuilder(
                            future: ApiService().fetchData(),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                    padding: EdgeInsets.all(15.0),
                                    child: Column(
                                      children: <Widget>[
                                        DecoratedBox(
                                            decoration: BoxDecoration(
                                                border: new Border.all(
                                                    color: bluePrimaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  2, 5, 0, 0),
                                              child: Stack(
                                                children: <Widget>[
                                                  Text(
                                                    "Role:",
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                    ),
                                                  ),
                                                  DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                        items: List.generate(
                                                            roles.length,
                                                            (index) {
                                                          return new DropdownMenuItem(
                                                            child: new Text(
                                                              roles[index]
                                                                  .name
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 13.0,
                                                              ),
                                                            ),
                                                            value: roles[index]
                                                                .id
                                                                .toString(),
                                                          );
                                                        }).toList(),
                                                        onChanged: (newVal) {
                                                          setState(() {
                                                            user.roleId = newVal
                                                                as String;
                                                            print(newVal);
                                                          });
                                                        },
                                                        value: idRole =
                                                            user.roleId),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ],
                                    ));
                              } else {
                                return Platform.isAndroid
                                    ? Center(child: CircularProgressIndicator())
                                    : Center(
                                        child: CupertinoActivityIndicator(),
                                      );
                              }
                            })
                      ])),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 5, bottom: 30),
                    child: Text("Role Harus Diisi"),
                  ),
                  Center(
                      child: FormHelper.submitButton("Save", () async {
                    if (validateAndSave()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data berhasil di update')));
                      print(user.toJson());
                      editUser().then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => TableUser()),
                          (route) => false));
                    }
                  }, btnColor: bluePrimaryColor, borderColor: bluePrimaryColor))
                ],
              )),
        ));
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
