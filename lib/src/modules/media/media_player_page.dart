import 'dart:io';

import 'package:async/async.dart';
import 'package:benchmark_flutter_app/src/commons/file_extensions.dart';
import 'package:benchmark_flutter_app/src/modules/media/timed_progress_indicator.dart';
import 'package:benchmark_flutter_app/src/modules/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

class MediaPlayerPage extends StatelessWidget {
  const MediaPlayerPage({super.key, required this.config});

  final Config config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('media_page'),
      appBar: AppBar(
        title: const Text('Media'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
        child: SingleChildScrollView(
            child: MediaPlayerScreen(mediaUri: config.mediaUri)),
      ),
    );
  }
}

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen({super.key, required this.mediaUri});

  final String mediaUri;

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  VideoPlayerController? _controller;
  late CancelableOperation _asyncOperation;
  late Future<void> _videoPlayerFuture;
  String fileName = '';
  late Function(BuildContext) btnPressed;

  Future<File> _loadMedia() async {
    return File.fromUri(Uri.file(widget.mediaUri));
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _asyncOperation =
          CancelableOperation.fromFuture(_loadMedia().then((file) {
        setState(() {
          if (mounted) {
            fileName = file.name;
            _controller = VideoPlayerController.file(file);
            _controller!.addListener(() {
              checkVideo(context);
            });

            _videoPlayerFuture =
                _controller!.initialize().then((_) => setState(() {}));
            _controller!.play();
          }
        });
      }));
    });

    super.initState();
  }

  void checkVideo(BuildContext ctx) {
    if (!_controller!.value.isPlaying &&
        _controller?.value.position == _controller?.value.duration) {
      _showSuccessMessage();
      print('MediaPlayerScreen.checkVideo');
      _asyncOperation.cancel();
      _controller?.dispose();
      Future.delayed(
          const Duration(seconds: 1), () => Navigator.pop(context));
    }
  }

  @override
  void dispose() {
    // _asyncOperation.cancel();
    // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(textAlign: TextAlign.left, fileName),
        (_controller != null
            ? FutureBuilder(
                future: _videoPlayerFuture,
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? Container(
                          padding: const EdgeInsets.only(top: 50),
                          child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                VideoPlayer(_controller!),
                                _ControlsOverlay(controller: _controller!),
                                TimedVideoProgressIndicator(_controller!,
                                    colors: _defaultVideoProgressColors(),
                                    allowScrubbing: true)
                                // VideoProgressIndicator(_controller!,
                                //     allowScrubbing: true),
                              ],
                            ),
                          ),
                        )
                      : Container();
                },
              )
            : Container()),
      ],
    );
  }

  void _showSuccessMessage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Media Executed')),
    );
  }

  VideoProgressColors _defaultVideoProgressColors() {
    return const VideoProgressColors(
      playedColor: Color.fromRGBO(20, 255, 200, 0.7),
      bufferedColor: Color.fromRGBO(0, 225, 225, 0.2),
      backgroundColor: Color.fromRGBO(230, 230, 230, 0.5),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 25), //50
          reverseDuration: const Duration(milliseconds: 120), //200
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 80.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
