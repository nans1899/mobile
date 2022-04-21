import 'dart:convert';
import 'dart:io';

import 'package:disdukcapil_mobile/screens/user_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class BadgeIndex extends StatefulWidget {
  const BadgeIndex({Key? key}) : super(key: key);

  @override
  _BadgeIndexState createState() => _BadgeIndexState();
}

class _BadgeIndexState extends State<BadgeIndex> {
  Future getProfile() async {
    String url = 'http://10.0.2.2:8000/api/profile';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ' + token,
    });

    log(response.body);
    return json.decode(response.body)["data"];
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
    return FutureBuilder(
        future: getProfile(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 100,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 42,
                    color: Color(0xff18274B).withOpacity(.12),
                    offset: Offset(0, 12),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    blurRadius: 18,
                    color: Color(0xff18274B).withOpacity(.12),
                    offset: Offset(0, 8),
                    spreadRadius: -6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(FeatherIcons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              snapshot.data!["username"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              snapshot.data!["name"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: UserProfile()));
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data!["foto"] ?? ""),
                          maxRadius: 24,
                        ),
                      ),
                    ],
                  ),
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
        });
  }
}
