import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/index.dart';
import '../providers/index.dart';

class SeriesListScreen extends StatefulWidget {
  const SeriesListScreen({Key? key}) : super(key: key);

  @override
  State<SeriesListScreen> createState() => _SeriesListScreenState();
}

class _SeriesListScreenState extends State<SeriesListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    Future.microtask(
      () => context.read<SeriesProvider>().fetchSeries(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المسلسلات'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن مسلسل...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<SeriesProvider>().clearSearch();
                } else {
                  context.read<SeriesProvider>().searchSeries(value);
                }
              },
            ),
          ),

          // Series list
          Expanded(
            child: Consumer<SeriesProvider>(
              builder: (context, seriesProvider, _) {
                if (seriesProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (seriesProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSizes.lg),
                        Text(
                          'حدث خطأ: ${seriesProvider.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.lg),
                        ElevatedButton(
                          onPressed: () {
                            seriesProvider.fetchSeries();
                          },
                          child: const Text('إعادة محاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final series = _searchController.text.isEmpty
                    ? seriesProvider.seriesList
                    : seriesProvider.searchResults;

                if (series.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 48,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: AppSizes.lg),
                        const Text('لم يتم العثور على مسلسلات'),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: AppSizes.lg,
                    mainAxisSpacing: AppSizes.lg,
                  ),
                  itemCount: series.length,
                  itemBuilder: (context, index) {
                    final s = series[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/series-detail',
                          arguments: s.id,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusMd),
                                color: AppColors.surfaceVariant,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusMd),
                                child: CachedNetworkImage(
                                  imageUrl: s.posterUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: AppColors.surfaceVariant,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: AppColors.surfaceVariant,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),

                          // Title
                          Text(
                            s.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),

                          // Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: AppSizes.xs),
                              Text(
                                '${s.rating}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
