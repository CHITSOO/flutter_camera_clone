import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_8/camera_shutter_screen.dart';
import 'package:flutter_application_8/video_review_screen.dart';

import 'image_review_screen.dart';

enum MediaType {
  NONE,
  IMAGE,
  VIDEO,
}

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Flutter Play Pen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Camera', style: Theme.of(context).textTheme.headline6),
              ElevatedButton(
                child: Text("Camera"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CameraShutterScreen()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text('Image Picker',
                    style: Theme.of(context).textTheme.headline6),
              ),
              ImagePickerButton(
                  label: "Image from Camera",
                  source: ImageSource.camera,
                  type: MediaType.IMAGE),
              ImagePickerButton(
                  label: "Image from Gallery",
                  source: ImageSource.gallery,
                  type: MediaType.IMAGE),
              ImagePickerButton(
                  label: "Video from Camera",
                  source: ImageSource.camera,
                  type: MediaType.VIDEO),
              ImagePickerButton(
                  label: "Video from Gallery",
                  source: ImageSource.gallery,
                  type: MediaType.VIDEO),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePickerButton extends StatelessWidget {
  const ImagePickerButton(
      {Key? key, required this.label, required this.source, required this.type})
      : super(key: key);

  final String label;
  final ImageSource source;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (type == MediaType.IMAGE) {
            final image = await ImagePicker().pickImage(source: source);
            if (image != null) {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ImageReviewScreen(imagePath: image.path),
                ),
              );
            }
          } else {
            final video = await ImagePicker()
                .pickVideo(source: source, maxDuration: Duration(seconds: 10));
            if (video != null) {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      VideoReviewScreen(videoPath: video.path),
                ),
              );
            }
          }
        },
        child: Text(label));
  }
}
