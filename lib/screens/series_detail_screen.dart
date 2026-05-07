import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/index.dart';
import '../providers/index.dart';

class SeriesDetailScreen extends StatefulWidget {
  final String seriesId;

  const SeriesDetailScreen({
    Key? key,
    required this.seriesId,
  }) : super(key: key);

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SeriesProvider>().getSeriesById(widget.seriesId);
      context.read<EpisodeProvider>().fetchEpisodesBySeriesId(widget.seriesId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<SeriesProvider, EpisodeProvider>(
        builder: (context, seriesProvider, episodeProvider, _) {
          if (seriesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final series = seriesProvider.selectedSeries;
          if (series == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('المسلسل'),
              ),
              body: const Center(
                child: Text('لم يتم العثور على المسلسل'),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App bar
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: series.posterUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.surfaceVariant,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.background.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        series.title,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Info row
                      Row(
                        children: [
                          // Rating
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusSm),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: AppSizes.sm),
                                Text('${series.rating}'),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSizes.lg),

                          // Year
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusSm),
                            ),
                            child: Text('${series.year}'),
                          ),
                          const SizedBox(width: AppSizes.lg),

                          // Episodes count
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusSm),
                            ),
                            child: Text('${series.episodeCount} حلقة'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Genre
                      Text(
                        'النوع: ${series.genre}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Description
                      Text(
                        'الوصف',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(
                        series.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSizes.xxl),

                      // Episodes section
                      Text(
                        'الحلقات',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSizes.lg),
                    ],
                  ),
                ),
              ),

              // Episodes list
              if (episodeProvider.isLoading)
                SliverToBoxAdapter(
                  child: Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                )
              else if (episodeProvider.episodes.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Text(
                        'لا توجد حلقات متاحة',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final episode = episodeProvider.episodes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.lg,
                          vertical: AppSizes.md,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/video-player',
                              arguments: episode.id,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMd),
                            ),
                            child: Row(
                              children: [
                                // Thumbnail
                                Container(
                                  width: 120,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusMd,
                                    ),
                                  ),
                                  child: episode.thumbnailUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            AppSizes.radiusMd,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: episode.thumbnailUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(Icons.video_library),
                                        ),
                                ),
                                const SizedBox(width: AppSizes.lg),

                                // Episode info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'الحلقة ${episode.episodeNumber}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: AppSizes.sm),
                                      Text(
                                        episode.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),

                                // Play icon
                                const Icon(Icons.play_circle_fill),
                                const SizedBox(width: AppSizes.lg),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: episodeProvider.episodes.length,
                  ),
                ),

              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: AppSizes.xxl),
              ),
            ],
          );
        },
      ),
    );
  }
}
