import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'providers/jackett_provider.dart';
import 'screens/search_results_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/premiumize_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Search',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          surface: Colors.grey[900]!,
          background: Colors.black,
          onBackground: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        cardTheme: CardTheme(
          color: Colors.grey[900],
          elevation: 2,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey[900],
          elevation: 8,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[850],
          border: const OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(200, 50),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Search'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainButton(
              label: 'Search Movies',
              type: SearchType.movies,
            ),
            SizedBox(height: 16),
            MainButton(
              label: 'Search TV Shows',
              type: SearchType.tvShows,
            ),
            SizedBox(height: 16),
            MainButton(
              label: 'Premiumize',
              type: SearchType.authenticate,
            ),
          ],
        ),
      ),
    );
  }
}

enum SearchType { movies, tvShows, authenticate }

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.label,
    required this.type,
  });

  final String label;
  final SearchType type;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (type == SearchType.authenticate) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PremiumizeScreen(),
            ),
          );
          return;
        }
        showSearch(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
      ),
      child: Text(label),
    );
  }

  void showSearch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SearchDialog(type: type),
    );
  }
}

class SearchDialog extends StatefulWidget {
  final SearchType type;

  const SearchDialog({
    super.key,
    required this.type,
  });

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final _textController = TextEditingController();
  int _selectedYear = DateTime.now().year;
  bool _isEpisodeSearch = false;
  bool _isSeasonSearch = false;
  int _selectedSeason = 1;
  int _selectedEpisode = 1;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final params = SearchParams(
      query: _textController.text,
      year: widget.type == SearchType.movies ? _selectedYear : null,
      isMovie: widget.type == SearchType.movies,
      isEpisodeSearch: widget.type == SearchType.tvShows ? _isEpisodeSearch : false,
      isSeasonSearch: widget.type == SearchType.tvShows ? _isSeasonSearch : false,
      season: (_isEpisodeSearch || _isSeasonSearch) ? _selectedSeason : null,
      episode: _isEpisodeSearch ? _selectedEpisode : null,
    );

    Navigator.pop(context);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          searchParams: params,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Search ${widget.type == SearchType.movies ? 'Movies' : 'TV Shows'}',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter Title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            if (widget.type == SearchType.movies) ...[
              const SizedBox(height: 16),
              const Text('Year'),
              NumberPicker(
                value: _selectedYear,
                minValue: 1900,
                maxValue: DateTime.now().year,
                onChanged: (value) => setState(() => _selectedYear = value),
              ),
            ],
            if (widget.type == SearchType.tvShows) ...[
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Episode Search'),
                value: _isEpisodeSearch,
                onChanged: (value) {
                  setState(() {
                    _isEpisodeSearch = value ?? false;
                    if (_isEpisodeSearch) {
                      _isSeasonSearch = false;
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Season Search'),
                value: _isSeasonSearch,
                onChanged: (value) {
                  setState(() {
                    _isSeasonSearch = value ?? false;
                    if (_isSeasonSearch) {
                      _isEpisodeSearch = false;
                    }
                  });
                },
              ),
              if (_isEpisodeSearch || _isSeasonSearch) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Season'),
                          NumberPicker(
                            value: _selectedSeason,
                            minValue: 1,
                            maxValue: 99,
                            onChanged: (value) {
                              setState(() => _selectedSeason = value);
                            },
                          ),
                        ],
                      ),
                    ),
                    if (_isEpisodeSearch) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Episode'),
                            NumberPicker(
                              value: _selectedEpisode,
                              minValue: 1,
                              maxValue: 99,
                              onChanged: (value) {
                                setState(() => _selectedEpisode = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _handleSearch,
          child: const Text('Search'),
        ),
      ],
    );
  }
}
