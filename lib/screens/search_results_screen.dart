import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/jackett_result.dart';
import '../providers/jackett_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/premiumize_provider.dart';
import '../utils/debouncer.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final SearchParams searchParams;

  const SearchResultsScreen({
    super.key,
    required this.searchParams,
  });

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCacheForResults();
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  void _checkCacheForResults() {
    final searchResults = ref.read(searchResultsProvider(widget.searchParams));
    searchResults.whenData((data) {
      final results = (data['Results'] as List)
          .map((e) => JackettResult.fromJson(e as Map<String, dynamic>))
          .toList();

      final magnetUrls = results
          .map((r) => r.magnetUri)
          .whereType<String>()
          .toSet()
          .toList();

      if (magnetUrls.isNotEmpty) {
        ref.invalidate(batchCacheCheckProvider(magnetUrls));
        ref.watch(batchCacheCheckProvider(magnetUrls));
      } else {
        print('No magnet URLs to check');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "${widget.searchParams.query}"'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ref.watch(searchResultsProvider(widget.searchParams)).when(
        data: (data) {
          final settings = ref.watch(settingsProvider);
          final filters = settings.getFiltersForType(widget.searchParams.isMovie);
          
          final results = (data['Results'] as List<JackettResult>)
              .where((result) {
                final sizeGB = result.size / (1024 * 1024 * 1024);
                return result.seeders >= filters.minimumSeeders &&
                    filters.matchesFilters(sizeGB);
              }).toList()
              ..sort(filters.compareResults);

          if (results.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return CachedResultTile(
                result: result,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class CachedResultTile extends ConsumerWidget {
  final JackettResult result;

  const CachedResultTile({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: ListTile(
        title: Text(
          result.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Size: ${result.formattedSize}'),
            Text('Seeders: ${result.seeders}'),
            Text(
              result.isCached ? 'Cached' : 'Not cached',
              style: TextStyle(
                color: result.isCached ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!result.isCached && result.magnetUri != null)
              IconButton(
                icon: const Icon(Icons.cloud_upload),
                onPressed: () {
                  ref.read(transferNotifierProvider.notifier)
                     .addTransfer(result.magnetUri!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Adding to Premiumize...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ResultDetailsDialog(result: result),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ResultDetailsDialog extends StatelessWidget {
  final JackettResult result;

  const ResultDetailsDialog({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Title: ${result.title}'),
            const SizedBox(height: 8),
            Text('Size: ${result.formattedSize}'),
            const SizedBox(height: 8),
            Text('Seeders: ${result.seeders}'),
            const SizedBox(height: 8),
            Text('Tracker: ${result.tracker}'),
            const SizedBox(height: 8),
            Text(
              'Published: ${result.publishDate.toLocal()}',
            ),
            if (result.description != null) ...[
              const SizedBox(height: 8),
              Text('Description: ${result.description}'),
            ],
            if (result.languages.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Languages: ${result.languages.join(", ")}'),
            ],
            if (result.categories.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Categories: ${result.categories.join(", ")}'),
            ],
            if (result.link != null) ...[
              const SizedBox(height: 8),
              Text('Link: ${result.link}'),
            ],
            if (result.magnetUri != null) ...[
              const SizedBox(height: 8),
              Text('Magnet Link: ${result.magnetUri}'),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
} 