import 'dart:convert';
import 'dart:io';

import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  String token = '';

  Future editPassowrd() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };
    final msg = {
      "password": password.text,
      "new_password": newPassword.text,
      "confirm_password": confirmPassword.text,
    };
    var body = jsonEncode(msg);

    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/change-password"),
        headers: headers,
        body: body);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Password berhasil di ubah',
          textAlign: TextAlign.center,
        ),
      ));
      Navigator.pushNamedAndRemoveUntil(
          context, '/user-profile', (route) => false);
    } else if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      String messages = body['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          messages,
          textAlign: TextAlign.center,
        ),
      ));
    }

    // return json.decode(response.body)['data'];
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('login')!;
    });
  }

  @override
  void initState() {
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
                "Change Password",
                style: blackTitleTextStyle.copyWith(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SafeArea(child: _contentChangePass()))
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(CupertinoIcons.back),
                  color: Colors.black),
              middle: Text(
                "User Profile",
                style: blackTitleTextStyle.copyWith(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            child: _contentChangePass());
  }

  Widget _contentChangePass() {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Form(
              key: globalKey,
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      TextFormField(
                          controller: password,
                          validator: (onValidateVal) {
                            if (onValidateVal!.isEmpty) {
                              return "Password can't be empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: blueColor,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: blueColor,
                                    width: 2,
                                  )),
                              prefixIcon:
                                  Icon(Icons.vpn_key, color: Colors.redAccent),
                              labelText: "Password",
                              hintText: "Password")),
                      const SizedBox(height: 15),
                      TextFormField(
                          controller: newPassword,
                          validator: (onValidateVal) {
                            if (onValidateVal!.isEmpty) {
                              return "New Password can't be empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: blueColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: bluePrimaryColor,
                                    width: 2,
                                  )),
                              prefixIcon:
                                  Icon(Icons.vpn_key, color: Colors.redAccent),
                              labelText: "New Password",
                              hintText: "New Password")),
                      const SizedBox(height: 15),
                      TextFormField(
                          controller: confirmPassword,
                          validator: (onValidateVal) {
                            if (onValidateVal!.isEmpty) {
                              return "Confirm Password can't be empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: blueColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: bluePrimaryColor,
                                    width: 2,
                                  )),
                              prefixIcon:
                                  Icon(Icons.vpn_key, color: Colors.redAccent),
                              labelText: "Confirm Password",
                              hintText: "Confirm Password")),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          // editPassowrd().then((value) => Navigator.of(context)
                          //     .pushAndRemoveUntil(
                          //         MaterialPageRoute(
                          //             builder: (context) => UserProfile()),
                          //         (route) => false));
                          editPassowrd();
                        },
                        child: Center(
                            child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              color: bluePrimaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text("Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                        )),
                      )
                    ],
                  ))),
        )
      ]),
    );
  }
}
