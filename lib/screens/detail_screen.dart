import 'dart:io';

import 'package:disdukcapil_mobile/widgets/badge_index.dart';
import 'package:disdukcapil_mobile/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailScreen extends StatefulWidget {
  final String? urlview;
  DetailScreen({this.urlview});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Builder(
        builder: (context) => SafeArea(
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
                connected ? _contentDetailsScreen() : const SizedBox(),
              ],
            );
          },
          child: const SizedBox(),
        )
        ),
      ),
    );
  }

  Widget _contentDetailsScreen(){
    return Column(
            children: [
              BadgeIndex(),
              // FutureBuilder<dynamic>(
              //   builder: (_, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.done) {
              //       if (snapshot.hasData) {
              //         return Expanded(
              //           child: Container(
              //             width: double.infinity,
              //             margin: const EdgeInsets.symmetric(horizontal: 16),
              //             padding: const EdgeInsets.symmetric(horizontal: 24),
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: Column(
              //               children: [
              //                 Expanded(
              //                   child: WebView(
              //                       javascriptMode: JavascriptMode.unrestricted,
              //                       initialUrl: (snapshot.data!['urlview']),
              //                       debuggingEnabled: true),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       } else if (snapshot.hasError) {
              //         return Center(
              //           child: Text('Data Tidak Tampil'),
              //         );
              //       }
              //     }
              //     return Center(child: Text('Data Tidak Tampil Coy'));
              //   },
              //   future: fetchMenus(),
              // ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: WebView(
                            javascriptMode: JavascriptMode.unrestricted,
                            initialUrl: widget.urlview.toString(),
                            debuggingEnabled: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
