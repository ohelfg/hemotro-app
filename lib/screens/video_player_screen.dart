import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/index.dart';
import '../providers/index.dart';
import '../widgets/index.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String episodeId;

  const VideoPlayerScreen({
    Key? key,
    required this.episodeId,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late String _selectedQuality;

  @override
  void initState() {
    super.initState();
    _selectedQuality = '720p';
    Future.microtask(() {
      context.read<EpisodeProvider>().getEpisodeById(widget.episodeId);
    });
  }

  String _getVideoUrlForQuality(String quality) {
    final episode = context.read<EpisodeProvider>().selectedEpisode;
    if (episode == null) return '';

    switch (quality) {
      case '1080p':
        return episode.video1080pUrl ?? episode.video720pUrl ?? '';
      case '720p':
        return episode.video720pUrl ?? episode.video480pUrl ?? '';
      case '480p':
        return episode.video480pUrl ?? episode.video360pUrl ?? '';
      case '360p':
        return episode.video360pUrl ?? episode.video480pUrl ?? '';
      default:
        return episode.video720pUrl ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<EpisodeProvider>(
        builder: (context, episodeProvider, _) {
          if (episodeProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final episode = episodeProvider.selectedEpisode;
          if (episode == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('الفيديو'),
              ),
              body: const Center(
                child: Text('لم يتم العثور على الحلقة'),
              ),
            );
          }

          final availableQualities = <String>[];
          if (episode.video1080pUrl != null) availableQualities.add('1080p');
          if (episode.video720pUrl != null) availableQualities.add('720p');
          if (episode.video480pUrl != null) availableQualities.add('480p');
          if (episode.video360pUrl != null) availableQualities.add('360p');

          if (availableQualities.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('الفيديو'),
              ),
              body: const Center(
                child: Text('لا توجد جودات متاحة للفيديو'),
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // Video player
                Expanded(
                  child: AdvancedVideoPlayer(
                    videoUrl: _getVideoUrlForQuality(_selectedQuality),
                    title: episode.title,
                    availableQualities: availableQualities,
                    initialQuality: _selectedQuality,
                    onQualityChanged: (quality) {
                      setState(() {
                        _selectedQuality = quality;
                      });
                    },
                  ),
                ),

                // Episode info
                Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الحلقة ${episode.episodeNumber}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(
                        episode.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(
                        episode.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
