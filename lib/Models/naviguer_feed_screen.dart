import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Feed/feed_screen.dart';

void naviguerFeedScreen(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => FeedScreen()),
    );
  }
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => FeedScreen()),
  );
}
