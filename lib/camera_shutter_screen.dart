// A screen that allows users to take a picture using a given camera.
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_8/video_review_screen.dart';

import 'image_review_screen.dart';

class CameraShutterScreen extends StatefulWidget {
  @override
  CameraShutterScreenState createState() => CameraShutterScreenState();
}

class CameraShutterScreenState extends State<CameraShutterScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      _controller =
          new CameraController(cameras.first, ResolutionPreset.medium);
      _initializeControllerFuture = _controller.initialize();
    } on CameraException catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isReady = true;
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      if (_controller != null) {
        _controller.dispose();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _setupCamera();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: _buildContent(context),
      floatingActionButton: _buildFABs(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (!_isReady) {
      return const Center(child: CircularProgressIndicator());
    }
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildFABs(BuildContext context) {
    // TODO: wait until _controller is fully initialized
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        FloatingActionButton(
          heroTag: 'camera_hero',
          onPressed: (_controller.value.isRecordingVideo)
              ? null
              : () async {
                  try {
                    final image = await _controller.takePicture();
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageReviewScreen(imagePath: image.path),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
          child: const Icon(Icons.camera_alt),
        ),
        FloatingActionButton(
          heroTag: 'video_hero',
          onPressed: () async {
            try {
              if (_controller.value.isRecordingVideo) {
                final video = await _controller.stopVideoRecording();
                setState(() {});
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoReviewScreen(videoPath: video.path),
                  ),
                );
              } else {
                await _controller.startVideoRecording();
                setState(() {});
              }
            } catch (e) {
              print(e);
            }
          },
          child: Icon(_controller.value.isRecordingVideo
              ? Icons.stop
              : Icons.play_arrow),
        ),
      ],
    );
  }
}
