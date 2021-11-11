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

class Video {
  VideoPlayerController controller;
  int likes = 0;
  int disLikes = 0;
  int comments = 0;

  Video(this.controller) {}
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;

  ChewieController? _chewieController;

  List<Video> videos = <Video>[
    Video(VideoPlayerController.network("https://firebasestorage.googleapis.com/v0/b/navin-56e04.appspot.com/o/a.mp4?alt=media&token=38b85337-723c-4fbd-90c7-9a91ee847341")),
    Video(VideoPlayerController.network("https://firebasestorage.googleapis.com/v0/b/navin-56e04.appspot.com/o/b.mp4?alt=media&token=1d7440e2-fb4e-44da-baec-51703e328ccc"))
  ];

  int index = -1;

  @override
  void initState() {
    super.initState();
    init();
    _next();
  }

  Future<void> init() async {
    await Future.wait([
      this.videos[0].controller.initialize(),
      this.videos[1].controller.initialize()
    ]);

  }

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    this.index++;
    this.index = this.index % 2;
    _chewieController = ChewieController(
      videoPlayerController: this.videos[this.index].controller,
      autoPlay: true,
      looping: true,
      showOptions: false,
      showControls: false,
      allowMuting: false,
    );
    setState(() {});
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
                child: Column(
                  children: [
                    if (_chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized)
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _next();
                            },
                            child: Chewie(
                              controller: _chewieController!,
                            ),
                          ),
                        ],
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
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              action(
                count: this.videos[this.index].likes,
                callFunc: () {
                  setState(() {
                    this.videos[this.index].likes++;
                  });
                },
                icon: Icon(Icons.thumb_up),
              ),
              action(
                count: this.videos[this.index].disLikes,
                callFunc: () {
                  setState(() {
                    this.videos[this.index].disLikes++;
                  });
                },
                icon: Icon(Icons.thumb_down),
              ),
              action(
                count: 10,
                icon: FaIcon(FontAwesomeIcons.comment),
              ),
              action(
                icon: FaIcon(FontAwesomeIcons.share),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class action extends StatelessWidget {
  final icon;
  final count;
  final callFunc;

  const action({Key? key, this.count, this.icon, this.callFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: this.callFunc,
          color: Colors.white,
          icon: this.icon,
        ),
        if (this.count != null)
          Text(
            this.count.toString(),
            style: TextStyle(color: Colors.white),
          )
      ],
    );
  }
}
