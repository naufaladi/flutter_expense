import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function onPress;

  AdaptiveButton(this.text, this.onPress);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            padding: EdgeInsets.only(top: 20, bottom: 30),
            child: CupertinoButton(
                color: Colors.amber[700],
                child: Text(text),
                onPressed: onPress),
          )
        : Container(
            margin: EdgeInsets.only(top: 10),
            child: RaisedButton(
              child: Text(text),
              textColor: Colors.white,
              color: Colors.amber[800],
              onPressed: onPress,
            ),
          );
  }
}
