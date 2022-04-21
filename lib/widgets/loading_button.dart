import 'dart:io';

import 'package:disdukcapil_mobile/shared/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: bluePrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              child: Platform.isAndroid ? CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  Colors.white,
                ),
              ) : CupertinoActivityIndicator(),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Loading',
              style: whiteTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
