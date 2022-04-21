import 'dart:convert';
import 'dart:io';
import 'package:disdukcapil_mobile/models/users.dart';
import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:validators/validators.dart';
import 'index_screen.dart';

class EditUserProfile extends StatefulWidget {
  EditUserProfile({Key? key, required this.profile}) : super(key: key);
  final Map profile;

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  ProfileUsers profile = ProfileUsers();
  String token = '';

  ///Only function post data diri
  Future addProfile() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };
    final msg = {
      "name": profile.name,
      "username": profile.username,
      "email": profile.email,
      "whatsapp": profile.whatsapp,
      "slack": profile.slack
    };
    var body = jsonEncode(msg);

    final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/update-profile"),
        headers: headers,
        body: body);

    print(response.statusCode);
    print(response.body);

    return json.decode(response.body)['data'];
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
                "Edit Profile",
                style: blackTitleTextStyle.copyWith(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
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
                    connected ? _contentEditProfile() : const SizedBox(),
                  ],
                );
              },
              child: const SizedBox(),
            )))
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(CupertinoIcons.back),
                  color: Colors.black),
              middle: Text(
                "Edit Profile",
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
                    connected ? _contentEditProfile() : const SizedBox(),
                  ],
                );
              },
              child: const SizedBox(),
            ));
  }

  Widget _contentEditProfile() {
    return SingleChildScrollView(
        child: Column(children: [
      Form(
        key: globalKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(children: [
                  const SizedBox(height: 20),
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
                          profile.name = onSavedVal;
                        },
                            initialValue: widget.profile['name'],
                            borderColor: blueColor,
                            borderFocusColor: blueColor,
                            borderRadius: 10,
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
                          profile.username = onSavedVal;
                        },
                            initialValue: widget.profile['username'],
                            borderColor: blueColor,
                            borderFocusColor: blueColor,
                            borderRadius: 10,
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
                            (onValidateVal) => !isEmail(onValidateVal!)
                                ? "Please enter valid email"
                                : null, (onSavedVal) {
                          profile.email = onSavedVal;
                        },
                            initialValue: widget.profile['email'],
                            borderColor: blueColor,
                            borderFocusColor: blueColor,
                            borderRadius: 10,
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
                            context, "whatsapp", "Whatsapp", (onValidateVal) {},
                            (onSavedVal) {
                          profile.whatsapp = onSavedVal;
                        },
                            initialValue: widget.profile['whatsapp'] ?? "",
                            borderColor: blueColor,
                            borderFocusColor: blueColor,
                            borderRadius: 10,
                            fontSize: 14,
                            paddingLeft: 0,
                            paddingRight: 0,
                            hintColor: Colors.grey.shade400),
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
                          profile.slack = onSavedVal;
                        },
                            initialValue: widget.profile['slack'] ?? "",
                            borderColor: blueColor,
                            borderFocusColor: blueColor,
                            borderRadius: 10,
                            fontSize: 14,
                            paddingLeft: 0,
                            paddingRight: 0,
                            hintColor: Colors.grey.shade200),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      if (validateAndSave()) {
                        ///Only post data diri
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Data berhasil di ubah')));
                        addProfile().then((value) =>
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IndexScreen()),
                                (route) => false));
                      }
                    },
                    child: Center(
                        child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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
                ]),
              ),
            ]),
      ),
    ]));
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
