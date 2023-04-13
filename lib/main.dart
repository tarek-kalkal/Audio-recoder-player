
// import 'dart:async';

// import 'package:audio_service/audio_service.dart';
// // import 'package:example/audio_player.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound_record/flutter_sound_record.dart';
// import 'package:just_audio/just_audio.dart' as ap;
// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';
// // import 'package:audio_service_example/common.dart';

// class AudioRecorder extends StatefulWidget {
//   const AudioRecorder({required this.onStop, Key? key}) : super(key: key);

//   final void Function(String path) onStop;

//   @override
//   _AudioRecorderState createState() => _AudioRecorderState();
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(ObjectFlagProperty<void Function(String path)>.has('onStop', onStop));
//   }
// }

// class _AudioRecorderState extends State<AudioRecorder> {
//   bool _isRecording = false;
//   bool _isPaused = false;
//   int _recordDuration = 0;
//   Timer? _timer;
//   Timer? _ampTimer;
//   final FlutterSoundRecord _audioRecorder = FlutterSoundRecord();
//   Amplitude? _amplitude;

//   @override
//   void initState() {
//     _isRecording = false;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _ampTimer?.cancel();
//     _audioRecorder.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 _buildRecordStopControl(),
//                 const SizedBox(width: 20),
//                 _buildPauseResumeControl(),
//                 const SizedBox(width: 20),
//                 _buildText(),
//               ],
//             ),
//             if (_amplitude != null) ...<Widget>[
//               const SizedBox(height: 40),
//               Text('Current: ${_amplitude?.current ?? 0.0}'),
//               Text('Max: ${_amplitude?.max ?? 0.0}'),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecordStopControl() {
//     late Icon icon;
//     late Color color;

//     if (_isRecording || _isPaused) {
//       icon = const Icon(Icons.stop, color: Colors.red, size: 30);
//       color = Colors.red.withOpacity(0.1);
//     } else {
//       final ThemeData theme = Theme.of(context);
//       icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
//       color = theme.primaryColor.withOpacity(0.1);
//     }

//     return ClipOval(
//       child: Material(
//         color: color,
//         child: InkWell(
//           child: SizedBox(width: 56, height: 56, child: icon),
//           onTap: () {
//             _isRecording ? _stop() : _start();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildPauseResumeControl() {
//     if (!_isRecording && !_isPaused) {
//       return const SizedBox.shrink();
//     }

//     late Icon icon;
//     late Color color;

//     if (!_isPaused) {
//       icon = const Icon(Icons.pause, color: Colors.red, size: 30);
//       color = Colors.red.withOpacity(0.1);
//     } else {
//       final ThemeData theme = Theme.of(context);
//       icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
//       color = theme.primaryColor.withOpacity(0.1);
//     }

//     return ClipOval(
//       child: Material(
//         color: color,
//         child: InkWell(
//           child: SizedBox(width: 56, height: 56, child: icon),
//           onTap: () {
//             _isPaused ? _resume() : _pause();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildText() {
//     if (_isRecording || _isPaused) {
//       return _buildTimer();
//     }

//     return const Text('Waiting to record');
//   }

//   Widget _buildTimer() {
//     final String minutes = _formatNumber(_recordDuration ~/ 60);
//     final String seconds = _formatNumber(_recordDuration % 60);

//     return Text(
//       '$minutes : $seconds',
//       style: const TextStyle(color: Colors.red),
//     );
//   }

//   String _formatNumber(int number) {
//     String numberStr = number.toString();
//     if (number < 10) {
//       numberStr = '0$numberStr';
//     }

//     return numberStr;
//   }

//   Future<void> _start() async {
//     try {
//       if (await _audioRecorder.hasPermission()) {
//         await _audioRecorder.start();

//         bool isRecording = await _audioRecorder.isRecording();
//         setState(() {
//           _isRecording = isRecording;
//           _recordDuration = 0;
//         });

//         _startTimer();
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   Future<void> _stop() async {
//     _timer?.cancel();
//     _ampTimer?.cancel();
//     final String? path = await _audioRecorder.stop();

//     widget.onStop(path!);

//     setState(() => _isRecording = false);
//   }

//   Future<void> _pause() async {
//     _timer?.cancel();
//     _ampTimer?.cancel();
//     await _audioRecorder.pause();

//     setState(() => _isPaused = true);
//   }

//   Future<void> _resume() async {
//     _startTimer();
//     await _audioRecorder.resume();

//     setState(() => _isPaused = false);
//   }

//   void _startTimer() {
//     _timer?.cancel();
//     _ampTimer?.cancel();

//     _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       setState(() => _recordDuration++);
//     });

//     _ampTimer = Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
//       _amplitude = await _audioRecorder.getAmplitude();
//       setState(() {});
//     });
//   }
// }
// late AudioHandler _audioHandler;
// void main()async {
//   //  _audioHandler = await AudioService.init(
//   //   builder: () => AudioPlayerHandler(),
//   //   config: const AudioServiceConfig(
//   //     androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
//   //     androidNotificationChannelName: 'Audio playback',
//   //     androidNotificationOngoing: true,
//   //   ),
//   // );
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool showPlayer = false;
//   ap.AudioSource? audioSource;

//   @override
//   void initState() {
//     showPlayer = false;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: showPlayer
//               ? 
//               SizedBox()
//               // Padding(
//               //     padding: const EdgeInsets.symmetric(horizontal: 25),
//               //     child: AudioPlayer(
//               //       source: audioSource!,
//               //       onDelete: () {
//               //         setState(() => showPlayer = false);
//               //       },
//               //     ),
//               //   )
//               : AudioRecorder(
//                   onStop: (String path) {
//                     setState(() {
//                       audioSource = ap.AudioSource.uri(Uri.parse(path));
//                       showPlayer = true;
//                     });
//                   },
//                 ),
//         ),
//       ),
//     );
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<bool>('showPlayer', showPlayer));
//     properties.add(DiagnosticsProperty<ap.AudioSource?>('audioSource', audioSource));
//   }
// }


// ignore_for_file: public_member_api_docs

// FOR MORE EXAMPLES, VISIT THE GITHUB REPOSITORY AT:
//
//  https://github.com/ryanheise/audio_service
//
// This example implements a minimal audio handler that renders the current
// media item and playback state to the system notification and responds to 4
// media actions:
//
// - play
// - pause
// - seek
// - stop
//
// To run this example, use:
//
// flutter run

import 'dart:async';

import 'package:audio/common.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

// You might want to provide this using dependency injection rather than a
// global variable.
late AudioHandler _audioHandler;

Future<void> main() async {
  _audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Service Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Service Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show media item title
            StreamBuilder<MediaItem?>(
              stream: _audioHandler.mediaItem,
              builder: (context, snapshot) {
                final mediaItem = snapshot.data;
                return Text(mediaItem?.title ?? '');
              },
            ),
            // Play/pause/stop buttons.
            StreamBuilder<bool>(
              stream: _audioHandler.playbackState
                  .map((state) => state.playing)
                  .distinct(),
              builder: (context, snapshot) {
                final playing = snapshot.data ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(Icons.fast_rewind, _audioHandler.rewind),
                    if (playing)
                      _button(Icons.pause, _audioHandler.pause)
                    else
                      _button(Icons.play_arrow, _audioHandler.play),
                    _button(Icons.stop, _audioHandler.stop),
                    _button(Icons.fast_forward, _audioHandler.fastForward),
                  ],
                );
              },
            ),
            // A seek bar.
            StreamBuilder<MediaState>(
              stream: _mediaStateStream,
              builder: (context, snapshot) {
                final mediaState = snapshot.data;
                return SeekBar(
                  duration: mediaState?.mediaItem?.duration ?? Duration.zero,
                  position: mediaState?.position ?? Duration.zero,
                  onChangeEnd: (newPosition) {
                    _audioHandler.seek(newPosition);
                  },
                );
              },
            ),
            // Display the processing state.
            StreamBuilder<AudioProcessingState>(
              stream: _audioHandler.playbackState
                  .map((state) => state.processingState)
                  .distinct(),
              builder: (context, snapshot) {
                final processingState =
                    snapshot.data ?? AudioProcessingState.idle;
                return Text(
                    "Processing state: ${describeEnum(processingState)}");
              },
            ),
          ],
        ),
      ),
    );
  }

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          _audioHandler.mediaItem,
          AudioService.position,
          (mediaItem, position) => MediaState(mediaItem, position));

  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
        icon: Icon(iconData),
        iconSize: 64.0,
        onPressed: onPressed,
      );
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

/// An [AudioHandler] for playing a single item.
class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  static final _item = MediaItem(
    id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    album: "Science Friday",
    title: "A Salute To Head-Scratching Science",
    artist: "Science Friday and WNYC Studios",
    duration: const Duration(milliseconds: 5739820),
    artUri: Uri.parse(
        'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  );

  final _player = AudioPlayer();

  /// Initialise our audio handler.
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
    mediaItem.add(_item);

    // Load the player.
    _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}