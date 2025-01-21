import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../models/settings_model.dart';
import '../providers/premiumize_provider.dart';
import '../screens/transfers_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/jackett_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showJackettUrlDialog(BuildContext context) async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Jackett URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'http://yourjacketurl:9117',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            const Text(
              'Include protocol (http/https) and port if needed',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('jackett_base_url', controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Jackett URL Saved Successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showJackettApiKeyDialog(BuildContext context) async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Jackett API Key'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'API Key',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('jackett_api_key', controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Jackett API Key Saved Successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final jackettSettings = ref.watch(jackettSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Movie Filters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              FilterSection(
                filters: settings.movieFilters,
                isMovie: true,
                onUpdate: (seeders, minSize, maxSize, sortBy, sortOrder) {
                  ref.read(settingsProvider.notifier).updateMovieFilters(
                        minimumSeeders: seeders,
                        minimumSizeGB: minSize,
                        maximumSizeGB: maxSize,
                        sortBy: sortBy,
                        sortOrder: sortOrder,
                      );
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'TV Show Filters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              FilterSection(
                filters: settings.tvShowFilters,
                isMovie: false,
                onUpdate: (seeders, minSize, maxSize, sortBy, sortOrder) {
                  ref.read(settingsProvider.notifier).updateTVShowFilters(
                        minimumSeeders: seeders,
                        minimumSizeGB: minSize,
                        maximumSizeGB: maxSize,
                        sortBy: sortBy,
                        sortOrder: sortOrder,
                      );
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 32),
              const Text(
                'Jackett Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              jackettSettings.when(
                data: (settings) => Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Jackett URL:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (settings.baseUrl != null)
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      final prefs = await SharedPreferences.getInstance();
                                      await prefs.remove('jackett_base_url');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Jackett URL removed')),
                                      );
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (settings.baseUrl != null)
                              Text(settings.baseUrl!)
                            else
                              ElevatedButton(
                                onPressed: () => _showJackettUrlDialog(context),
                                child: const Text('Set Jackett URL'),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'API Key:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (settings.apiKey != null)
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      final prefs = await SharedPreferences.getInstance();
                                      await prefs.remove('jackett_api_key');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('API Key removed')),
                                      );
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (settings.apiKey != null)
                              const Text('✓ API Key is set')
                            else
                              ElevatedButton(
                                onPressed: () => _showJackettApiKeyDialog(context),
                                child: const Text('Set API Key'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Error: $error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterSection extends StatelessWidget {
  final MediaFilters filters;
  final Function(int? seeders, double? minSize, double? maxSize, SortField? sortBy, SortOrder? sortOrder) onUpdate;
  final bool isMovie;

  const FilterSection({
    super.key,
    required this.filters,
    required this.onUpdate,
    required this.isMovie,
  });

  @override
  Widget build(BuildContext context) {
    final minController = TextEditingController(
      text: filters.minimumSizeGB?.toString() ?? '',
    );
    final maxController = TextEditingController(
      text: filters.maximumSizeGB?.toString() ?? '',
    );

    void handleMinSave() {
      try {
        if (minController.text.isEmpty) {
          onUpdate(null, null, null, null, null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Minimum size filter cleared')),
          );
          return;
        }

        final value = double.parse(minController.text);
        if (value >= 0 && value <= 100) {
          if (!isMovie && value < 0.1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TV shows minimum size must be at least 0.1 GB')),
            );
            return;
          }
          onUpdate(null, value, null, null, null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Minimum size filter saved')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a value between 0 and 100 GB')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid number')),
        );
      }
    }

    void handleMaxSave() {
      try {
        if (maxController.text.isEmpty) {
          onUpdate(null, null, null, null, null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum size filter cleared')),
          );
          return;
        }

        final value = double.parse(maxController.text);
        if (value >= 0 && value <= 100) {
          onUpdate(null, null, value, null, null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum size filter saved')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a value between 0 and 100 GB')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid number')),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Minimum Seeders',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: filters.minimumSeeders.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          label: filters.minimumSeeders.toString(),
          onChanged: (value) {
            onUpdate(value.toInt(), null, null, null, null);
          },
        ),
        Text('Current value: ${filters.minimumSeeders}'),
        const SizedBox(height: 24),
        const Text(
          'Size Filters (GB)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (!isMovie) 
          const Text(
            '(For TV shows, enter sizes in GB. e.g., 0.2 for 200MB)',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: minController,
                    decoration: InputDecoration(
                      labelText: '${isMovie ? "Minimum" : "Minimum (0.2+)"} Size (GB)',
                      border: const OutlineInputBorder(),
                      suffixText: 'GB',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: handleMinSave,
                    child: const Text('Save Min Size'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: maxController,
                    decoration: const InputDecoration(
                      labelText: 'Maximum Size (GB)',
                      border: OutlineInputBorder(),
                      suffixText: 'GB',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: handleMaxSave,
                    child: const Text('Save Max Size'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class SizeFilterSettings extends ConsumerStatefulWidget {
  final String title;
  final double? currentValue;
  final Function(double?) onSave;

  const SizeFilterSettings({
    super.key,
    required this.title,
    required this.currentValue,
    required this.onSave,
  });

  @override
  ConsumerState<SizeFilterSettings> createState() => _SizeFilterSettingsState();
}

class _SizeFilterSettingsState extends ConsumerState<SizeFilterSettings> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize with current value or empty string
    _controller = TextEditingController(
      text: widget.currentValue?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    try {
      if (_controller.text.isEmpty) {
        widget.onSave(null);  // Allow clearing the value
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Size filter cleared')),
        );
        return;
      }

      final value = double.parse(_controller.text);
      if (value >= 0 && value <= 100) {
        widget.onSave(value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Size filter saved')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a value between 0 and 100 GB')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Enter size in GB (0-100)',
                  suffixText: 'GB',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _handleSave,
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
} 