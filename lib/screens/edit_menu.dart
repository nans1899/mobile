import 'dart:io';

import 'package:disdukcapil_mobile/models/menus.dart';
import 'package:disdukcapil_mobile/screens/table_menu.dart';
import 'package:disdukcapil_mobile/service/multi_select_service.dart';
import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:snippet_coder_utils/FormHelper.dart';

class EditMenu extends StatefulWidget {
  EditMenu({Key? key, required this.menus}) : super(key: key);
  final Map menus;

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  Rolemenu roleMenu = Rolemenu();
  String token = '';
  String initialValue = '0';
  String initialParent = '0';
  String initialSite = '0';
  String initialHide = '0';
  String initialNumber = '1';

  ///MultiSelect Role
  late List<Role> roles = [];
  ApiService roleService = ApiService();

  getData() async {
    roles = await roleService.fetchData();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('login')!;
    });
  }

  final MultiSelectController<String> _controller =
      MultiSelectController(deSelectPerpetualSelectedItems: true);

  @override
  void initState() {
    getData();
    getCred();
    super.initState();
  }

  Future editMenus() async {
    String url = 'http://10.0.2.2:8000/api/menu-management/' +
        widget.menus['id'].toString() +
        '/update';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };
    final msg = {
      "parent_id": roleMenu.parentId,
      "site_id": roleMenu.siteId,
      "value": roleMenu.value,
      "name": roleMenu.name,
      "ref": roleMenu.ref,
      "url": roleMenu.url,
      "urlview": roleMenu.urlview,
      "no": roleMenu.no,
      "hide": roleMenu.hide,
      "icon": roleMenu.icon,
      "role": roleMenu.role
    };
    var body = jsonEncode(msg);

    final response =
        await http.put((Uri.parse(url)), headers: headers, body: body);
    print(response.statusCode);
    return json.decode(response.body)['data'];
  }

  //Value
  var itemList = [
    '0',
    '1',
    '2',
  ];

  //Site
  var siteList = [
    '0',
    '1',
    '2',
  ];

  //Parent id
  var parentList = ['0', '1', '2', '3', '4', '5'];

  //Hide
  var hideList = ["0", "1"];

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
                    connected ? _uiWidget() : const SizedBox(),
                  ],
                );
              },
              child: const SizedBox(),
            ));
  }

  Widget _uiWidget() {
    //No
    List<String> doubleList =
        List<String>.generate(99, (int index) => '${index + 1}');
    List<DropdownMenuItem> noList = doubleList
        .map((val) => DropdownMenuItem(value: val, child: Text(val)))
        .toList();
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
                      margin:
                          const EdgeInsets.only(left: 10, top: 15, right: 10),
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
                            roleMenu.name = onSavedVal;
                          },
                              initialValue: widget.menus['name'],
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
                      margin: const EdgeInsets.only(
                          left: 10, top: 15, bottom: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Parent Id",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bluePrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: bluePrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: false,
                              ),
                              value: widget.menus['parent_id'].toString(),
                              onSaved: (onSavedVal) => roleMenu.parentId =
                                  int.parse(onSavedVal.toString()),
                              validator: (onValidateVal) =>
                                  onValidateVal == null
                                      ? "Select Parent Id"
                                      : null,
                              items: parentList
                                  .map((items) => DropdownMenuItem(
                                      value: items, child: Text(items)))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  initialParent = newValue!;
                                });
                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, bottom: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Value",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bluePrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bluePrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: false,
                              ),
                              value: widget.menus['value'].toString(),
                              onSaved: (onSavedVal) => roleMenu.value =
                                  int.parse(onSavedVal.toString()),
                              validator: (onValidateVal) =>
                                  onValidateVal == null ? "Select Value" : null,
                              items: itemList
                                  .map((items) => DropdownMenuItem(
                                      value: items, child: Text(items)))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  initialValue = newValue!;
                                });
                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ref",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          FormHelper.inputFieldWidget(context, "ref", "Ref",
                              (onValidateVal) {
                            if (onValidateVal.isEmpty) {
                              return 'Ref cant be empty';
                            }
                            return null;
                          }, (onSavedVal) {
                            roleMenu.ref = onSavedVal;
                          },
                              initialValue: widget.menus['ref'],
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
                      margin:
                          const EdgeInsets.only(left: 10, top: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Url Website",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          FormHelper.inputFieldWidget(context, "url", "Url",
                              (onValidateVal) {
                            if (onValidateVal.isEmpty) {
                              return 'Url cant be empty';
                            }
                            return null;
                          }, (onSavedVal) {
                            roleMenu.url = onSavedVal;
                          },
                              initialValue: widget.menus['url'],
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
                      margin:
                          const EdgeInsets.only(left: 10, top: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Urlview",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          FormHelper.inputFieldWidget(
                              context, "urlview", "Urlview", (onValidateVal) {
                            if (onValidateVal.isEmpty) {
                              return 'Urlview cant be empty';
                            }
                            return null;
                          }, (onSavedVal) {
                            roleMenu.urlview = onSavedVal;
                          },
                              initialValue: widget.menus['urlview'],
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
                      margin: const EdgeInsets.only(
                          left: 10, top: 15, bottom: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Site_id",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bluePrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bluePrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: false,
                              ),
                              value: widget.menus['site_id'].toString(),
                              onSaved: (onSavedVal) => roleMenu.siteId =
                                  int.parse(onSavedVal.toString()),
                              validator: (onValidateVal) =>
                                  onValidateVal == null ? "Select Value" : null,
                              items: siteList
                                  .map((items) => DropdownMenuItem(
                                      value: items, child: Text(items)))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  initialSite = newValue!;
                                });
                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, bottom: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("No",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<dynamic>(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bluePrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bluePrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: false,
                              ),
                              value: initialNumber,
                              onSaved: (onSavedVal) => roleMenu.no =
                                  int.parse(onSavedVal.toString()),
                              validator: (onValidateVal) =>
                                  onValidateVal == null ? "Select Value" : null,
                              items: noList,
                              onChanged: (newValue) {
                                setState(() {
                                  initialNumber = newValue! as String;
                                });
                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, bottom: 5, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hide",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bluePrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bluePrimaryColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: false,
                              ),
                              value: initialHide,
                              onSaved: (onSavedVal) => roleMenu.hide =
                                  int.parse(onSavedVal.toString()),
                              validator: (onValidateVal) =>
                                  onValidateVal == null ? "Select Value" : null,
                              items: hideList
                                  .map((items) => DropdownMenuItem(
                                      value: items, child: Text(items)))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  initialHide = newValue!;
                                });
                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Icon",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          FormHelper.inputFieldWidget(context, "icon", "Icon",
                              (onValidateVal) {
                            if (onValidateVal.isEmpty) {
                              return 'Icon cant be empty';
                            }
                            return null;
                          }, (onSavedVal) {
                            roleMenu.icon = onSavedVal;
                          },
                              initialValue: widget.menus['icon'],
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
                      margin: EdgeInsets.only(bottom: 30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Akses Role',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Center(
                                child: FutureBuilder(
                                    future: ApiService().fetchData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Stack(
                                          children: [
                                            Container(
                                              child: MultiSelectContainer(
                                                  controller: _controller,
                                                  itemsDecoration:
                                                      MultiSelectDecorations(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .green[200]!),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    selectedDecoration:
                                                        BoxDecoration(
                                                            gradient:
                                                                const LinearGradient(
                                                                    colors: [
                                                                  Colors.green,
                                                                  Colors
                                                                      .lightGreen
                                                                ]),
                                                            border: Border.all(
                                                                color: Colors
                                                                        .green[
                                                                    700]!),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    disabledDecoration:
                                                        BoxDecoration(
                                                            color: Colors.grey,
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey[
                                                                        500]!),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                  ),
                                                  suffix: MultiSelectSuffix(
                                                      selectedSuffix:
                                                          const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                      disabledSuffix:
                                                          const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Icon(
                                                          Icons
                                                              .do_disturb_alt_sharp,
                                                          size: 14,
                                                        ),
                                                      )),
                                                  splashColor: Colors.green,
                                                  textStyles:
                                                      const MultiSelectTextStyles(
                                                          textStyle: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .lightBlue)),
                                                  items: List.generate(
                                                      roles.length,
                                                      (index) =>
                                                          MultiSelectCard(
                                                              value: roles[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              label: roles[
                                                                      index]
                                                                  .name,
                                                              decorations:
                                                                  MultiSelectItemDecorations(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                selectedDecoration: BoxDecoration(
                                                                    color: Colors
                                                                        .redAccent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                              ),
                                                              textStyles: const MultiSelectItemTextStyles(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .redAccent)))),
                                                  onChange: (allSelectedItems,
                                                      selectedItem) {
                                                    roleMenu.role =
                                                        allSelectedItems
                                                            as List<String>;
                                                    print(allSelectedItems);
                                                  }),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Text("Data Kosong");
                                      }
                                    })),
                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 5),
                              child: Text("Akses Role Harus Diisi"),
                            ),
                          ]),
                    ),
                    Center(
                        child: FormHelper.submitButton("Save", () async {
                      if (validateAndSave()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Data berhasil di ubah')));
                        //  roleMenu.toJson();
                        print(roleMenu.toJson());
                        editMenus().then((value) =>
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TableMenu()),
                                (route) => false));
                      }
                    },
                            btnColor: bluePrimaryColor,
                            borderColor: bluePrimaryColor))
                  ],
                ))));
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
