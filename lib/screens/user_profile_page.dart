import 'dart:io';

import 'package:disdukcapil_mobile/screens/edit_user_profile.dart';
import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'change_password.dart';
import 'index_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  ///Get User Profile
  Future getProfile() async {
    String url = 'http://10.0.2.2:8000/api/profile';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ' + token,
    });

    return json.decode(response.body)['data'];
  }

  ///Save Token
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

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  Future uploadImage(String filepath) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://172.16.5.236:8080/api/change-photo"));
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', filepath));
    }
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      'Authorization': 'Bearer ' + token
    });
  }

  Widget _title(String title) {
    return Container(
      child: Text(title,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: blueColor)),
    );
  }

  Widget _contentProfile() {
    return SingleChildScrollView(
      child: Form(
        key: globalKey,
        child: Column(children: [
          Column(
            children: [
              FutureBuilder(
                  future: getProfile(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var profile = snapshot.data!;
                      return Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Foto
                              Container(
                                child: Center(
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                          backgroundImage: imageFile != null
                                              ? FileImage(File(imageFile!.path))
                                                  as ImageProvider
                                              : NetworkImage(
                                                  snapshot.data!["foto"]),
                                          radius: 80),
                                      Positioned(
                                          bottom: 20,
                                          right: 20,
                                          child: InkWell(
                                            onTap: () {
                                              Platform.isAndroid
                                                  ? showModalBottomSheet(
                                                      context: context,
                                                      builder: ((builder) =>
                                                          bottomSheet()))
                                                  : showCupertinoModalPopup(
                                                      context: context,
                                                      builder: ((builder) =>
                                                          _iosBottomSheet()));
                                            },
                                            child: Icon(Icons.camera_alt,
                                                color: Colors.redAccent,
                                                size: 28),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              imageFile != null
                                  ? Column(children: [
                                      Center(
                                        child: Container(
                                          width: 150,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: bluePrimaryColor,
                                          ),
                                          child: TextButton(
                                            onPressed: () async {
                                              if (validateAndSave()) {
                                                ///Only post data diri
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Foto berhasil di ubah')));
                                                uploadImage(imageFile!.path)
                                                    .then((value) => Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        IndexScreen()),
                                                            (route) => false));
                                              }
                                            },
                                            child: Text(
                                              'Save Photo',
                                              style: whiteTextStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])
                                  : Container(),

                              ///Username
                              const SizedBox(height: 20),
                              _title("Username"),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  child: Text(snapshot.data!["username"],
                                      style: TextStyle(
                                        fontSize: 18,
                                      ))),

                              ///Name
                              const SizedBox(
                                height: 20,
                              ),
                              _title("Name"),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(snapshot.data!["name"],
                                    style: TextStyle(
                                      fontSize: 18,
                                    )),
                              ),

                              ///Email
                              const SizedBox(
                                height: 20,
                              ),
                              _title("Email"),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(snapshot.data!["email"],
                                    style: TextStyle(
                                      fontSize: 18,
                                    )),
                              ),

                              ///Whatsapp
                              const SizedBox(
                                height: 20,
                              ),
                              _title("Whatsapp"),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(snapshot.data!["whatsapp"] ?? "",
                                    style: TextStyle(
                                      fontSize: 18,
                                    )),
                              ),

                              ///Slack
                              const SizedBox(
                                height: 20,
                              ),
                              _title("Slack"),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Text(snapshot.data!["slack"] ?? "",
                                    style: TextStyle(
                                      fontSize: 18,
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: bluePrimaryColor,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: EditUserProfile(
                                                    profile: profile,
                                                  )));
                                        },
                                        child: Text(
                                          'Edit Profile',
                                          style: whiteTextStyle,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: bluePrimaryColor,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: ChangePassword()));
                                        },
                                        child: Text(
                                          'Change Password',
                                          style: whiteTextStyle,
                                        ),
                                      ),
                                    ),
                                  ])
                            ]),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Platform.isAndroid
                          ? Center(child: CircularProgressIndicator())
                          : Center(
                              child: CupertinoActivityIndicator(),
                            );
                    } else {
                      return Center(child: Text("Tidak Ada User Profile"));
                    }
                  }),
            ],
          )
        ]),
      ),
    );
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
                "User Profile",
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
                      connected ? _contentProfile() : const SizedBox(),
                    ],
                  );
                },
                child: const SizedBox(),
              ),
            ))
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
                    connected ? _contentProfile() : const SizedBox(),
                  ],
                );
              },
              child: const SizedBox(),
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

  void takePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (validateAndSave()) {
        imageFile = pickedFile;
        Navigator.pop(context);
      }
    });
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text("Choose Profil Photo", style: TextStyle(fontSize: 20)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                label: Text("Gallery"),
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _iosBottomSheet() {
    return CupertinoActionSheet(
      title: Text(
        "Update Photo",
        style: blueTextStyle.copyWith(fontSize: 25),
      ),
      message: Text("Choose profile photo from your gallery",
          style: greyMutedTextStyle.copyWith(fontSize: 15)),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () {
              takePhoto();
            },
            child: Text("Gallery"))
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
