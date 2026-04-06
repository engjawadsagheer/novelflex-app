import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class TopBar extends StatelessWidget {
  final String? text;

  final TextStyle? style;
  final String? uniqueHeroTag;
  final Widget? child;

  const TopBar({
    Key? key,
    this.text,
    this.style,
    this.uniqueHeroTag,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.white,
          title: Text(
            text!,
            style: style,
          ),
        ),
        body: child,
      );
    } else {
      return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          heroTag: uniqueHeroTag!,
          border: null,
          transitionBetweenRoutes: false,
          middle: Text(
            text!,
            style: style,
          ),
        ),
        child: child!,
      );
    }
  }
}