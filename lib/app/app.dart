import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

import 'theme.dart';

class ChewieDemo extends StatefulWidget {
  const ChewieDemo({
    Key? key,
    this.title = 'Demo',
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController2 =
        VideoPlayerController.network('http://192.168.1.21:8081/a.mp4');
    await Future.wait([_videoPlayerController2.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
      autoPlay: true,
      looping: true,
      showOptions: false,
      showControls: false,
      allowMuting: false,
      fullScreenByDefault: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light.copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                child: Stack(
                  children: [
                    if (_chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized)
                      Chewie(
                        controller: _chewieController!,
                      )
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            action(icon: Icon(Icons.thumb_up),),
                            action(icon: Icon(Icons.thumb_down),),
                            action(icon: FaIcon(FontAwesomeIcons.comment),),
                            action(icon: FaIcon(FontAwesomeIcons.share),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class action extends StatelessWidget {
  final icon;
  const action({
    Key? key,
    this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          color: Colors.white,
          icon: this.icon,
        ),
        Text("0", style: TextStyle(color: Colors.white),)
      ],
    );
  }
}
