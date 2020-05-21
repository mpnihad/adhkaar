import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider_architecture/provider_architecture.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class PlayerWidget extends StatefulWidget {
  final String url;
  final int id;
  final int playStatus;
  final PlayerMode mode;

  PlayerWidget(
      {Key key,
      @required this.url,
        this.id,
      this.mode = PlayerMode.MEDIA_PLAYER,
      this.playStatus = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(url, mode, playStatus);
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  PlayerMode mode;
  int playStatus;
  int downloadStatus=0;
  double  progress=0;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  PlayingRouteState _playingRouteState = PlayingRouteState.speakers;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  MyViewModel myViewModel;

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  get _isPlayingThroughEarpiece =>
      _playingRouteState == PlayingRouteState.earpiece;

  _PlayerWidgetState(this.url, this.mode, this.playStatus);

  @override
  void initState() {
   myViewModel=new MyViewModel();
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerWidget oldWidget) {
    // TODO: implement didUpdateWidget
    if (_isPlaying) {
//      _pause();

      _pause();

//      _durationSubscription?.cancel();
//      _positionSubscription?.cancel();
//      _playerCompleteSubscription?.cancel();
//      _playerErrorSubscription?.cancel();
//      _playerStateSubscription?.cancel();

    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _controllers(context),
    );
  }

  List<Widget> _controllers(BuildContext context) {
//     Column(
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        Row(
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            IconButton(
//              key: Key('play_button'),
//              onPressed: _isPlaying ? null : () => _play(),
//              iconSize: 64.0,
//              icon: Icon(Icons.play_arrow),
//              color: Colors.cyan,
//            ),
//            IconButton(
//              key: Key('pause_button'),
//              onPressed: _isPlaying ? () => _pause() : null,
//              iconSize: 64.0,
//              icon: Icon(Icons.pause),
//              color: Colors.cyan,
//            ),
//            IconButton(
//              key: Key('stop_button'),
//              onPressed: _isPlaying || _isPaused ? () => _stop() : null,
//              iconSize: 64.0,
//              icon: Icon(Icons.stop),
//              color: Colors.cyan,
//            ),
//            IconButton(
//              onPressed: _earpieceOrSpeakersToggle,
//              iconSize: 64.0,
//              icon: _isPlayingThroughEarpiece
//                  ? Icon(Icons.volume_up)
//                  : Icon(Icons.hearing),
//              color: Colors.cyan,
//            ),
//          ],
//        ),
//        Column(
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            Padding(
//              padding: EdgeInsets.all(12.0),
//              child: Stack(
//                children: [
//                  Slider(
//                    onChanged: (v) {
//                      final Position = v * _duration.inMilliseconds;
//                      _audioPlayer
//                          .seek(Duration(milliseconds: Position.round()));
//                    },
//                    value: (_position != null &&
//                        _duration != null &&
//                        _position.inMilliseconds > 0 &&
//                        _position.inMilliseconds < _duration.inMilliseconds)
//                        ? _position.inMilliseconds / _duration.inMilliseconds
//                        : 0.0,
//                  ),
//                ],
//              ),
//            ),
//            Text(
//              _position != null
//                  ? '${_positionText ?? ''} / ${_durationText ?? ''}'
//                  : _duration != null ? _durationText : '',
//              style: TextStyle(fontSize: 24.0),
//            ),
//          ],
//        ),
//        Text('State: $_audioPlayerState')
//      ],
//    );

    return [
      SizedBox(
        height: 10,
        child: Visibility(
          visible: true,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: RectangularSliderTrackShape(),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
            ),
            child: new Slider(
//          onChangeStart: (v) {
//            _isSeeking = true;
//          },
              onChanged: (value) {
                setState(() {
                  _position =
                      Duration(seconds: (_duration.inSeconds * value).round());
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  _position =
                      Duration(seconds: (_duration.inSeconds * value).round());
                });
                _audioPlayer.seek(_position);

              },
              value: (_position != null &&
                      _duration != null &&
                      _position.inSeconds > 0 &&
                      _position.inSeconds < _duration.inSeconds)
                  ? _position.inSeconds / _duration.inSeconds
                  : 0.0,
              activeColor: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: ClipOval(
                child: Container(
              color: Theme.of(context).accentColor.withAlpha(30),
              width: 40.0,
              height: 40.0,
              child: downloadStatus == 1
                  ?Center(
                          child: SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: progress,
                            ),
                          ),
                        )

                  : IconButton(
                      onPressed: _isPlaying ? () => _pause() : () => _play(),
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 15.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
            )),
          ),
          IconButton(
            onPressed: () => {},
            icon: true
                ? Icon(
                    Icons.repeat,
                    size: 15.0,
                    color: Colors.grey,
                  )
                : Icon(
                    Icons.shuffle,
                    size: 25.0,
                    color: Colors.grey,
                  ),
          ),
        ],
      )
    ];
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30),
            // default is 30s
            backwardSkipInterval: const Duration(seconds: 30),
            // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });

    _playingRouteState = PlayingRouteState.speakers;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;

    String dir = (await getApplicationDocumentsDirectory()).path;

    int readdata = 0;
    bool abc;
    try {
      final file = await File('$dir/"Adkaar_${widget.id}"');
      abc = await File(file.path).exists();
      readdata = 1;
      // Read the file
//        String contents = await file.readAsString();

//        readdata= int.parse(contents);
      print(abc.toString() + file.path.toString());
    } catch (e) {
      // If we encounter an error, return 0
      readdata = 0;
      print(abc.toString() + readdata.toString());
    }
    playStatus = 1;
    setState(() {});
//      print(readdata +file.);
    if (!abc) {

      downloadStatus=1;
      setState(() {

      });
      var dio = Dio();
      await dio.download(url, '$dir/"Adkaar_${widget.id}"',
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
          // disable gzip
          onReceiveProgress: (received, total) {
            if (total != -1) {
              progress=received / total * 100;
              print(progress);
              setState(() {

              });
            }
          });


      File file = new File('$dir/"Adkaar_${widget.id}"');

//      var request = await http.get(
//        url,
//      );


//      var bytes = await request.bodyBytes; //close();
//      await file.writeAsBytes(bytes);
//      print(file.path);

      downloadStatus=0;
      setState(() {

      });
      final result = await _audioPlayer.play(file.path,
          isLocal: true, position: playPosition);
      if (result == 1) setState(() => _playerState = PlayerState.playing);
      _audioPlayer.setPlaybackRate(playbackRate: 1.0);

      _audioPlayer.setNotification();
      return result;
    } else {
//    final result = await _audioPlayer.play(url, position: playPosition);

      // default playback rate is 1.0
      // this should be called after _audioPlayer.play() or _audioPlayer.resume()
      // this can also be called everytime the user wants to change playback rate in the UI
      File file = File('$dir/"Adkaar_${widget.id}"');
      final result = await _audioPlayer.play(file.path,
          isLocal: true, position: playPosition);
      if (result == 1) setState(() => _playerState = PlayerState.playing);
      _audioPlayer.setPlaybackRate(playbackRate: 1.0);
      _audioPlayer.setNotification();
      return result;
    }
  }

  Future<int> _pause() async {
    playStatus = 0;
    setState(() {});
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _earpieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1)
      setState(() => _playingRouteState =
          _playingRouteState == PlayingRouteState.speakers
              ? PlayingRouteState.earpiece
              : PlayingRouteState.speakers);
    return result;
  }

  Future<int> _stop() async {
    playStatus = 0;
    setState(() {});
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    playStatus = 1;
    setState(() {});
    setState(() => _playerState = PlayerState.stopped);
  }

  Widget _timer(BuildContext context) {
    var style = new TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          _formatDuration(_position),
          style: style,
        ),
        new Text(
          _formatDuration(_duration),
          style: style,
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = "$minute" + ":" + ((second < 10) ? "0$second" : "$second");
    return format;
  }


}

class MyViewModel extends ChangeNotifier {
  double _progress = 0;

  File _file;

  File get file => _file;



  get downloadProgress => _progress;

  Future<File> startDownloading(String url,int id) async {
    _progress = null;
    notifyListeners();


    final request = http.Request('GET', Uri.parse(url));
    final http.StreamedResponse response = await http.Client().send(request);

    final contentLength = response.contentLength;
    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);

    _progress = 0;
    notifyListeners();

    List<int> bytes = [];
    String dir = (await getApplicationDocumentsDirectory()).path;

    _file = await _getFile('$dir/"Adkaar_${id}"');
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        _progress = downloadedLength / contentLength;
        notifyListeners();
      },
      onDone: () async {
        _progress = 0;
        notifyListeners();
        await file.writeAsBytes(bytes);
      },
      onError: (e) {
        print(e);
      },
      cancelOnError: true,
    );
    return file;
  }

  Future<File> _getFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/$filename");
  }




  Future<int> playAudio(AudioPlayer _audioPlayer, Duration playPosition, PlayerState _playerState) async {
    final result = await _audioPlayer.play(_file.path,
        isLocal: true, position: playPosition);

    _audioPlayer.setPlaybackRate(playbackRate: 1.0);
    return result;
  }
}
