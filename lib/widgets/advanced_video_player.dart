import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../constants/index.dart';

class AdvancedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  final List<String> availableQualities;
  final String initialQuality;
  final Function(String) onQualityChanged;

  const AdvancedVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.title,
    required this.availableQualities,
    required this.initialQuality,
    required this.onQualityChanged,
  }) : super(key: key);

  @override
  State<AdvancedVideoPlayer> createState() => _AdvancedVideoPlayerState();
}

class _AdvancedVideoPlayerState extends State<AdvancedVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  String _selectedQuality = '';
  double _playbackSpeed = 1.0;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _selectedQuality = widget.initialQuality;
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل الفيديو: $error')),
        );
      });

    _controller.addListener(() {
      if (_controller.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Video player
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),

            // Controls overlay
            if (_showControls)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top controls
                    Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton<String>(
                            color: AppColors.surface,
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  enabled: false,
                                  child: Text(
                                    'الجودة: $_selectedQuality',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const PopupMenuDivider(),
                                ...widget.availableQualities.map((quality) {
                                  return PopupMenuItem(
                                    value: quality,
                                    child: Row(
                                      children: [
                                        if (_selectedQuality == quality)
                                          const Icon(
                                            Icons.check,
                                            color: AppColors.primary,
                                          )
                                        else
                                          const SizedBox(width: 24),
                                        const SizedBox(width: AppSizes.md),
                                        Text(quality),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedQuality = quality;
                                      });
                                      widget.onQualityChanged(quality);
                                    },
                                  );
                                }).toList(),
                              ];
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.md,
                                vertical: AppSizes.sm,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusSm),
                              ),
                              child: Text(
                                _selectedQuality,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom controls
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Progress bar
                          if (_controller.value.isInitialized)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.lg,
                              ),
                              child: Column(
                                children: [
                                  VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      playedColor: AppColors.primary,
                                      bufferedColor:
                                          AppColors.primary.withOpacity(0.5),
                                      backgroundColor: Colors.grey.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppSizes.sm),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(
                                          _controller.value.position,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(
                                          _controller.value.duration,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: AppSizes.lg),

                          // Control buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.lg,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Play/Pause
                                IconButton(
                                  icon: Icon(
                                    _isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPlaying
                                          ? _controller.pause()
                                          : _controller.play();
                                    });
                                  },
                                ),

                                // Speed
                                PopupMenuButton<double>(
                                  color: AppColors.surface,
                                  itemBuilder: (BuildContext context) {
                                    return [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                                        .map((speed) {
                                      return PopupMenuItem(
                                        value: speed,
                                        child: Row(
                                          children: [
                                            if (_playbackSpeed == speed)
                                              const Icon(
                                                Icons.check,
                                                color: AppColors.primary,
                                              )
                                            else
                                              const SizedBox(width: 24),
                                            const SizedBox(width: AppSizes.md),
                                            Text('${speed}x'),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _playbackSpeed = speed;
                                          });
                                          _controller.setPlaybackSpeed(speed);
                                        },
                                      );
                                    }).toList();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.md,
                                      vertical: AppSizes.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusSm,
                                      ),
                                    ),
                                    child: Text(
                                      '${_playbackSpeed}x',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),

                                // Fullscreen
                                IconButton(
                                  icon: Icon(
                                    _isFullScreen
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isFullScreen = !_isFullScreen;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSizes.lg),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
