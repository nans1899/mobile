import 'dart:io';

import 'package:disdukcapil_mobile/screens/index_screen.dart';
import 'package:disdukcapil_mobile/screens/log_page.dart';
import 'package:disdukcapil_mobile/screens/role_page.dart';
import 'package:disdukcapil_mobile/screens/table_menu.dart';
import 'package:disdukcapil_mobile/screens/table_user.dart';
import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:disdukcapil_mobile/widgets/expansion_tile_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu_widget.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String token = '';
  String roles = '';
  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      try {
        token = pref.getString('login')!;
        roles = pref.getString('role')!;
        print('masuk sini home ' + token);
      } catch (e) {
        print(e.toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCred();
  }

  @override
  Widget build(BuildContext context) {
    Widget footer = Container();
    if (roles == "superadmin") {
      footer = drawerFooter(context);
    }

    Widget logout() {
      return Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Platform.isAndroid
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: bluePrimaryColor,
                  ),
                  child: TextButton.icon(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      await pref.clear();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    icon: Icon(Icons.logout_outlined, color: Colors.white),
                    label: Text(
                      'Logout',
                      style: whiteTextStyle,
                    ),
                  ))
              : Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 50,
                  child: CupertinoButton(
                      color: bluePrimaryColor,
                      borderRadius: BorderRadius.circular(12),
                      child: Text('Logout', style: whiteTextStyle),
                      onPressed: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        await pref.clear();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      }),
                ),
        ],
      ));
    }

    return Drawer(
      child: ListView(
        children: [drawerHeader(context), MenuWidget(), footer, logout()],
        // children: [drawerHeader(context), MenuWidget(), logout()],
      ),
    );
  }

  Widget drawerHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 17, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LOGO
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => IndexScreen()));
                },
                child: Image.asset(
                  'assets/images/sidebarLogo.png',
                  height: 50,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              FeatherIcons.x,
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerFooter(BuildContext context) {
    return Container(
      child: Align(
        alignment: FractionalOffset.bottomLeft,
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              expansionTileItem(context,
                  text: "Management item",
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: ListTileTheme(
                              tileColor: Colors.transparent,
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TableMenu())),
                                child: Text('Menu Management',
                                    style:
                                        blueTextStyle.copyWith(fontSize: 16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: ListTileTheme(
                              tileColor: Colors.transparent,
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TableUser())),
                                child: Text('User Management',
                                    style:
                                        blueTextStyle.copyWith(fontSize: 16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: ListTileTheme(
                              tileColor: Colors.transparent,
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RolePage())),
                                child: Text('Role Management',
                                    style:
                                        blueTextStyle.copyWith(fontSize: 16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: ListTileTheme(
                              tileColor: Colors.transparent,
                              child: TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LogPage())),
                                child: Text('Log Management',
                                    style:
                                        blueTextStyle.copyWith(fontSize: 16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget expansionTileItem(BuildContext context,
      {required String text, required Widget child}) {
    const inActiveTextNavigationColor = Color(0xFF625F6E);
    return ListTileTheme(
      tileColor: Color(0xfff2ad10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            unselectedWidgetColor: inActiveTextNavigationColor),
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 5),
          child: ExpansionTile(
            title: Text(text,
                style: TextStyle(
                    color: inActiveTextNavigationColor, fontSize: 16)),
            children: [child],
          ),
        ),
      ),
    );
  }
}
