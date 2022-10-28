import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../Utils/colors.dart';

class CustomMaterialControls extends StatefulWidget {
  const CustomMaterialControls({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomMaterialControlsState();
  }
}

class _CustomMaterialControlsState extends State<CustomMaterialControls>
    with SingleTickerProviderStateMixin {
  VideoPlayerValue? _latestValue;
  double? _latestVolume;
  bool _hideStuff = true;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  Duration? currentDuration;

  final barHeight = 50.0;
  final marginSize = 5.0;

  VideoPlayerController? controller;
  ChewieController? chewieController;
  AnimationController? playPauseIconAnimationController;

  @override
  Widget build(BuildContext context) {
    if (_latestValue!.hasError) {
      return chewieController!.errorBuilder != null
          ? chewieController!.errorBuilder!(
        context,
        chewieController!.videoPlayerController.value.errorDescription!,
      )
          : const Center(
        child: Icon(
          Icons.error,
          color: Colors.white,
          size: 42,
        ),
      );
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: () => _cancelAndRestartTimer(),
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Column(
            children: <Widget>[
              if (_latestValue != null &&
                  !_latestValue!.isPlaying &&
                  _latestValue!.duration == null ||
                  _latestValue!.isBuffering)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                _buildHitArea(),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    // print('Dispose called');
    //  if (_latestValue.initialized && _latestValue.isPlaying) {
    //   setState(() {
    //     isQualityChangeRequestInProgress = false;
    //   });
    // }
    super.dispose();
  }

  void _dispose() {
    controller!.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController!.videoPlayerController;

    playPauseIconAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(
      BuildContext context,
      ) {
    final iconColor = Theme.of(context).textTheme.button!.color;
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          height: barHeight,
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              _buildPlayPause(controller!),
              if (chewieController!.isLive)
                const Expanded(child: Text('LIVE'))
              else
                _buildPosition(iconColor),
              if (chewieController!.isLive)
                const SizedBox()
              else
                _buildProgressBar(),
              if (chewieController!.allowPlaybackSpeedChanging)
                _buildSpeedButton(controller),
              if (chewieController!.allowMuting) _buildMuteButton(controller),
              // _buildQualitySelector(chewieController),
              if (chewieController!.allowFullScreen) _buildExpandButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildQualitySelector(ChewieController chewieController) {
  //   return GestureDetector(
  //     onTap: () async {
  //       _hideTimer?.cancel();
  //       qualities.clear();
  //       m3u8List.forEach((element) {
  //         qualities.add(element.dataquality);
  //       });
  //       final chosenQuality = await showModalBottomSheet<String>(
  //         context: context,
  //         backgroundColor: secondaryColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(20.0),
  //             topRight: Radius.circular(20.0),
  //           ),
  //         ),
  //         isScrollControlled: true,
  //         useRootNavigator: true,
  //         builder: (context) => _QualitySelectorDialog(
  //           qualities: qualities,
  //           selected: selectedQuality,
  //         ),
  //       );
  //       if (chosenQuality != null && selectedQuality != chosenQuality) {
  //         currentDuration =
  //             await chewieController.videoPlayerController.position;
  //         setState(() {
  //           isQualityChangeRequestInProgress = true;
  //         });
  //         selectedQuality = chosenQuality;
  //         widget.onQualityChange(
  //           m3u8List[
  //                   qualities.indexWhere((quality) => quality == chosenQuality)]
  //               .dataurl,
  //           currentDuration,
  //         );
  //         qualities.clear();
  //       } else {
  //         _startHideTimer();
  //       }
  //       if (chosenQuality == null) {
  //         setState(() {
  //           isQualityChangeRequestInProgress = false;
  //           qualities.clear();
  //         });
  //       }
  //     },
  //     child: AnimatedOpacity(
  //       opacity: _hideStuff ? 0.0 : 1.0,
  //       duration: const Duration(milliseconds: 300),
  //       child: Container(
  //         height: barHeight,
  //         margin: const EdgeInsets.only(right: 0.0),
  //         padding: const EdgeInsets.only(
  //           left: 5.0,
  //           right: 5.0,
  //         ),
  //         child: Center(
  //           child: Icon(
  //             Icons.high_quality,
  //             color: secondaryColor,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: const EdgeInsets.only(right: 10.0),
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
          ),
          child: Center(
            child: Icon(
              chewieController!.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: videoControllerColor,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
    final bool isFinished = _latestValue!.position >= _latestValue!.duration;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_latestValue != null && _latestValue!.isPlaying) {
            if (_displayTapped) {
              setState(() {
                _hideStuff = true;
              });
            } else {
              _cancelAndRestartTimer();
            }
          } else {
            // _playPause();
            setState(() {
              _hideStuff = true;
            });
          }
        },
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: () {

                    },
                    onTap: () {
                      _playPause();
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _playPause();
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                color: Colors.transparent,
                height: 200,
                child: GestureDetector(
                  onTap: () {
                    if (_latestValue != null && _latestValue!.isPlaying) {
                      if (_displayTapped) {
                        setState(() {
                          _hideStuff = true;
                        });
                      } else {
                        _cancelAndRestartTimer();
                      }
                    } else {
                      // _playPause();
                      setState(() {
                        _hideStuff = true;
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _playPause();
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _playPause();
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: Container(
                          //     color: Colors.redAccent,
                          //     child: Center(
                          //       child: AnimatedOpacity(
                          //         opacity: _latestValue != null &&
                          //             !_latestValue!.isPlaying &&
                          //             !_dragging
                          //             ? 1.0
                          //             : 0.0,
                          //         duration: const Duration(milliseconds: 300),
                          //         child: GestureDetector(
                          //           child: Container(
                          //             decoration: BoxDecoration(
                          //               color: Theme.of(context).dialogBackgroundColor,
                          //               borderRadius: BorderRadius.circular(48.0),
                          //             ),
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(12.0),
                          //               child: IconButton(
                          //                 icon: isFinished
                          //                     ? const Icon(Icons.replay, size: 32.0)
                          //                     : AnimatedIcon(
                          //                   icon: AnimatedIcons.play_pause,
                          //                   progress: playPauseIconAnimationController!,
                          //                   size: 32.0,
                          //                 ),
                          //                 onPressed: () {
                          //                   _playPause();
                          //                 },
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          //
                          // Expanded(
                          //   child: Container(
                          //     color: Colors.yellow,
                          //     child: Center(
                          //       child: AnimatedOpacity(
                          //         opacity: _latestValue != null &&
                          //             !_latestValue!.isPlaying &&
                          //             !_dragging
                          //             ? 1.0
                          //             : 0.0,
                          //         duration: const Duration(milliseconds: 300),
                          //         child: GestureDetector(
                          //           child: Container(
                          //             decoration: BoxDecoration(
                          //               color: Theme.of(context).dialogBackgroundColor,
                          //               borderRadius: BorderRadius.circular(48.0),
                          //             ),
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(12.0),
                          //               child: IconButton(
                          //                 icon: isFinished
                          //                     ? const Icon(Icons.replay, size: 32.0)
                          //                     : AnimatedIcon(
                          //                   icon: AnimatedIcons.play_pause,
                          //                   progress: playPauseIconAnimationController!,
                          //                   size: 32.0,
                          //                 ),
                          //                 onPressed: () {
                          //                   _playPause();
                          //                 },
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      IgnorePointer(
                        child: GestureDetector(
                          onTap: () {
                            if (_latestValue != null && _latestValue!.isPlaying) {
                              if (_displayTapped) {
                                setState(() {
                                  _hideStuff = true;
                                });
                              } else {
                                _cancelAndRestartTimer();
                              }
                            } else {
                              // _playPause();
                              setState(() {
                                _hideStuff = true;
                              });
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: _latestValue != null &&
                                    !_latestValue!.isPlaying &&
                                    !_dragging
                                    ? 1.0
                                    : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).dialogBackgroundColor,
                                      borderRadius: BorderRadius.circular(48.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: IconButton(
                                        icon: isFinished
                                            ? const Icon(Icons.replay, size: 32.0)
                                            : AnimatedIcon(
                                          icon: AnimatedIcons.play_pause,
                                          progress: playPauseIconAnimationController!,
                                          size: 32.0,
                                        ),
                                        onPressed: () {
                                          _playPause();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedButton(
      VideoPlayerController? controller,
      ) {
    return GestureDetector(
      onTap: () async {
        _hideTimer?.cancel();

        final chosenSpeed = await showModalBottomSheet<double>(
          context: context,
          backgroundColor: videoControllerColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (context) => _PlaybackSpeedDialog(
            speeds: chewieController!.playbackSpeeds,
            selected: _latestValue!.playbackSpeed,
          ),
        );

        if (chosenSpeed != null) {
          controller!.setPlaybackSpeed(chosenSpeed);
        }

        if (_latestValue!.isPlaying) {
          _startHideTimer();
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 5.0,
            ),
            child: Icon(
              Icons.speed,
              color: videoControllerColor,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
      VideoPlayerController? controller,
      ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue!.volume == 0) {
          controller!.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller!.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 5.0,
            ),
            child: Icon(
              (_latestValue != null && _latestValue!.volume > 0)
                  ? Icons.volume_up
                  : Icons.volume_off,
              color: videoControllerColor,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: videoControllerColor,
        ),
      ),
    );
  }


  Widget _buildPosition(Color? iconColor) {
    final position =
    _latestValue != null ? _latestValue!.position : Duration.zero;
    final duration =
    _latestValue != null ? _latestValue!.duration : Duration.zero;

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Text(
        '${formatDuration(position)} / ${formatDuration(duration)}',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<void> _initialize() async {
    controller!.addListener(_updateState);

    _updateState();

    if ((controller!.value.isPlaying) || chewieController!.autoPlay) {
      _startHideTimer();
    }

    if (chewieController!.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController!.toggleFullScreen();
      _showAfterExpandCollapseTimer =
          Timer(const Duration(milliseconds: 300), () {
            setState(() {
              _cancelAndRestartTimer();
            });
          });
    });
  }

  void _playPause() {
    bool isFinished;
    if (_latestValue!.duration != null) {
      isFinished = _latestValue!.position >= _latestValue!.duration;
    } else {
      isFinished = false;
    }

    setState(() {
      if (controller!.value.isPlaying) {
        playPauseIconAnimationController!.reverse();
        _hideStuff = false;
        _hideTimer?.cancel();
        controller!.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller!.value.isInitialized) {
          controller!.initialize().then((_) {
            controller!.play();
            playPauseIconAnimationController!.forward();
          });
        } else {
          if (isFinished) {
            controller!.seekTo(const Duration());
          }
          playPauseIconAnimationController!.forward();
          controller!.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller!.value;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });
            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });
            _startHideTimer();
          },
          colors: chewieController!.materialProgressColors ??
              ChewieProgressColors(
                playedColor: Theme.of(context).colorScheme.secondary,
                handleColor: Theme.of(context).colorScheme.secondary,
                bufferedColor: Theme.of(context).backgroundColor,
                backgroundColor: Theme.of(context).disabledColor,
              ),
        ),
      ),
    );
  }
}

class _PlaybackSpeedDialog extends StatelessWidget {
  const _PlaybackSpeedDialog({
    Key? key,
    required List<double> speeds,
    required double selected,
  })  : _speeds = speeds,
        _selected = selected,
        super(key: key);

  final List<double> _speeds;
  final double _selected;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).primaryColor;

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        final _speed = _speeds[index];
        return ListTile(
          dense: true,
          title: Row(
            children: [
              if (_speed == _selected)
                Icon(
                  Icons.check,
                  size: 20.0,
                  color: selectedColor,
                )
              else
                Container(width: 20.0),
              const SizedBox(width: 16.0),
              Text(_speed.toString()),
            ],
          ),
          selected: _speed == _selected,
          onTap: () {
            Navigator.of(context).pop(_speed);
          },
        );
      },
      itemCount: _speeds.length,
    );
  }
}

// class _QualitySelectorDialog extends StatelessWidget {
//   const _QualitySelectorDialog({
//     Key key,
//     @required List<String> qualities,
//     @required String selected,
//   })  : _qualities = qualities,
//         _selected = selected,
//         super(key: key);

//   final List<String> _qualities;
//   final String _selected;

//   @override
//   Widget build(BuildContext context) {
//     final Color selectedColor = Theme.of(context).primaryColor;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const ScrollPhysics(),
//       itemBuilder: (context, index) {
//         final _quality = _qualities[index];
//         return ListTile(
//           dense: true,
//           title: Row(
//             children: [
//               if (_quality == _selected)
//                 Icon(
//                   Icons.check,
//                   size: 20.0,
//                   color: selectedColor,
//                 )
//               else
//                 Container(width: 20.0),
//               const SizedBox(width: 16.0),
//               Text(_quality),
//             ],
//           ),
//           selected: _quality == _selected,
//           onTap: () {
//             Navigator.of(context).pop(_quality);
//           },
//         );
//       },
//       itemCount: _qualities.length,
//     );
//   }
// }

class MaterialVideoProgressBar extends StatefulWidget {
  MaterialVideoProgressBar(
      this.controller, {
        ChewieProgressColors? colors,
        this.onDragEnd,
        this.onDragStart,
        this.onDragUpdate,
        Key? key,
      })  : colors = colors ?? ChewieProgressColors(),
        super(key: key);

  final VideoPlayerController? controller;
  final ChewieProgressColors colors;
  final Function()? onDragStart;
  final Function()? onDragEnd;
  final Function()? onDragUpdate;

  @override
  _VideoProgressBarState createState() {
    return _VideoProgressBarState();
  }
}

class _VideoProgressBarState extends State<MaterialVideoProgressBar> {
  _VideoProgressBarState() {
    listener = () {
      if (!mounted) return;
      setState(() {});
    };
  }

  late VoidCallback listener;
  bool _controllerWasPlaying = false;

  VideoPlayerController? get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller!.addListener(listener);
  }

  @override
  void deactivate() {
    controller!.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final box = context.findRenderObject() as RenderBox;
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller!.value.duration * relative;
      controller!.seekTo(position);
    }

    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        print("......");
        if (!controller!.value.isInitialized) {
          return;
        }
        _controllerWasPlaying = controller!.value.isPlaying;
        if (_controllerWasPlaying) {
          controller!.pause();
        }

        if (widget.onDragStart != null) {
          widget.onDragStart!();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller!.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);

        if (widget.onDragUpdate != null) {
          widget.onDragUpdate!();
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        print("*********");
        if (_controllerWasPlaying) {
          controller!.play();
        }

        if (widget.onDragEnd != null) {
          widget.onDragEnd!();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller!.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: CustomPaint(
            painter: _ProgressBarPainter(
              controller!.value,
              widget.colors,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(this.value, this.colors);

  VideoPlayerValue value;
  ChewieProgressColors colors;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const height = 2.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, size.height / 2),
          Offset(size.width, size.height / 2 + height),
        ),
        const Radius.circular(4.0),
      ),
      colors.backgroundPaint,
    );
    if (!value.isInitialized) {
      return;
    }
    final double playedPartPercent =
        value.position.inMilliseconds / value.duration.inMilliseconds;
    final double playedPart =
    playedPartPercent > 1 ? size.width : playedPartPercent * size.width;
    for (final DurationRange range in value.buffered) {
      final double start = range.startFraction(value.duration) * size.width;
      final double end = range.endFraction(value.duration) * size.width;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, size.height / 2),
            Offset(end, size.height / 2 + height),
          ),
          const Radius.circular(4.0),
        ),
        colors.bufferedPaint,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, size.height / 2),
          Offset(playedPart, size.height / 2 + height),
        ),
        const Radius.circular(4.0),
      ),
      colors.playedPaint,
    );
    canvas.drawCircle(
      Offset(playedPart, size.height / 2 + height / 2),
      height * 3,
      colors.handlePaint,
    );
  }
}

String formatDuration(Duration position) {
  final ms = position.inMilliseconds;

  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  final minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
      ? '00'
      : '0$hours';

  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
      ? '00'
      : '0$minutes';

  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
      ? '00'
      : '0$seconds';

  final formattedTime =
      '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

  return formattedTime;
}
