// A widget that displays the picture taken by the user.
import 'dart:io';

import 'package:flutter/material.dart';

class ImageReviewScreen extends StatelessWidget {
  final String imagePath;

  const ImageReviewScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Center(
        child: Container(
            margin: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.amber,
                width: 2,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.file(File(imagePath)))),
      ),
    );
  }
}
